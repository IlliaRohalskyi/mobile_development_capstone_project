import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_development_capstone_project/bloc/news_bloc.dart';
import 'package:mobile_development_capstone_project/repositories/news_repository.dart';
import 'package:mobile_development_capstone_project/widgets/card.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:mobile_development_capstone_project/preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  final prefs = PreferencesService();

  ThemeChanger() : _themeData = ThemeData.light() {
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    bool isDarkTheme = await prefs.getTheme() ?? false;
    _themeData = isDarkTheme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
    prefs.setTheme(theme == ThemeData.dark());
  }
}

class HomePage extends StatefulWidget {
  final NewsBloc newsBloc;
  String selectedLanguage;

  HomePage({required this.newsBloc, required this.selectedLanguage});

  @override
  _HomePageState createState() =>
      _HomePageState(newsBloc: newsBloc, selectedLanguage: selectedLanguage);
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'general';
  String selectedLanguage;
  final prefs = PreferencesService();
  NewsBloc? newsBloc;
  final _searchController = TextEditingController();

  _HomePageState({required this.newsBloc, required this.selectedLanguage});

  List<String> categories = [
    'general',
    'business',
    'technology',
    'science',
    'health',
    'sports',
  ];
  List<String> languages = ['en', 'de', 'fr'];

  void selectLanguage() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Select the news language'),
          children: languages.map((language) {
            return SimpleDialogOption(
              child: Text(language),
              onPressed: () {
                Navigator.pop(context);
                selectedLanguage = language;
                prefs.setLanguage(language);
                BlocProvider.of<NewsBloc>(context).add(LoadNewsEvent(
                    category: selectedCategory, language: selectedLanguage));
              },
            );
          }).toList(),
        );
      },
    );
  }

  void switchTheme() {
    final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    bool isDarkTheme = themeChanger.getTheme() == ThemeData.dark();
    themeChanger.setTheme(isDarkTheme ? ThemeData.light() : ThemeData.dark());
    prefs.setTheme(!isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App', textDirection: TextDirection.ltr),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.language),
            onPressed: selectLanguage,
          ),
          IconButton(
            icon: themeChanger.getTheme() == ThemeData.light()
                ? Icon(Icons.brightness_3)
                : Icon(Icons.brightness_7),
            onPressed: switchTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categories', style: TextStyle(fontSize: 20)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search News...',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  final query = _searchController.text;
                                  if (query.isNotEmpty) {
                                    BlocProvider.of<NewsBloc>(context)
                                        .add(SearchNewsEvent(query: query));
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            onSubmitted: (query) {
                              if (query.isNotEmpty) {
                                BlocProvider.of<NewsBloc>(context)
                                    .add(SearchNewsEvent(query: query));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            for (var category in categories)
              ListTile(
                title: Text(category),
                onTap: () {
                  selectedCategory = category;
                  BlocProvider.of<NewsBloc>(context).add(LoadNewsEvent(
                      category: selectedCategory, language: selectedLanguage));
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<NewsBloc>(context).add(LoadNewsEvent(
                    category: selectedCategory, language: selectedLanguage));
              },
              child: LazyLoadScrollView(
                onEndOfPage: () =>
                    BlocProvider.of<NewsBloc>(context).add(LoadMoreNewsEvent()),
                child: ListView.builder(
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) {
                    final article = state.articles[index];
                    return FancyNewsCard(
                      imgUrl: article.urlToImage ?? "",
                      title: article.title,
                      desc: article.description ?? "",
                      content: article.content ?? "",
                      postUrl: article.url,
                    );
                  },
                ),
              ),
            );
          } else if (state is NewsErrorState) {
            return Center(child: Text(state.error));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    newsBloc!.close();
    super.dispose();
  }
}
