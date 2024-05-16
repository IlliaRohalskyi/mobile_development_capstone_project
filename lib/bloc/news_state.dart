part of 'news_bloc.dart';


abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<ArticleModel> articles;
  final int page;
  final String category;
  final String language;
  final String? query;

  NewsLoadedState(this.articles, this.page, this.category, this.language, {this.query});
}

class NewsErrorState extends NewsState {
  final String error;

  NewsErrorState(this.error);
}
