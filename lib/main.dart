import 'package:flutter/material.dart';
import 'package:mobile_development_capstone_project/views/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_development_capstone_project/repositories/news_repository.dart';
import 'package:mobile_development_capstone_project/bloc/news_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mobile_development_capstone_project/preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferencesService prefs = PreferencesService();
  String language = await prefs.getLanguage() ?? 'en';

  runApp(
    ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: MyApp(language: language),
    ),
  );
}

class MyApp extends StatelessWidget {
  final NewsRepository _newsRepository = NewsRepository();
  final String language;

  MyApp({required this.language});

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    final newsBloc = NewsBloc(_newsRepository)..add(LoadNewsEvent(category: 'general', language: language));

    return BlocProvider<NewsBloc>(
      create: (context) => newsBloc,
      child: MaterialApp(
        title: 'News App',
        theme: themeChanger.getTheme(),
        home: HomePage(newsBloc: newsBloc, selectedLanguage: language),
      ),
    );
  }
}