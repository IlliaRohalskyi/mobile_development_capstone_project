part of 'news_bloc.dart';

abstract class NewsEvent {}

class LoadNewsEvent extends NewsEvent {
  final String category;
  final String language;

  LoadNewsEvent({required this.category, required this.language});
}

class LoadMoreNewsEvent extends NewsEvent {}

class SearchNewsEvent extends NewsEvent {
  final String query;

  SearchNewsEvent({required this.query});

  @override
  List<Object> get props => [query];
}
