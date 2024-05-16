import 'package:mobile_development_capstone_project/models/article_model.dart';
import 'package:mobile_development_capstone_project/repositories/news_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _repository;

  NewsBloc(this._repository) : super(NewsInitialState()) {
    on<LoadNewsEvent>((event, emit) async {
      emit(NewsLoadingState());
      try {
        final articles =
            await _repository.fetchNews(event.category, event.language, 1);
        emit(NewsLoadedState(articles, 1, event.category, event.language));
      } catch (error) {
        emit(NewsErrorState(error.toString()));
      }
    });

    on<LoadMoreNewsEvent>((event, emit) async {
      final currentState = state;
      if (currentState is NewsLoadedState) {
        final nextPage = currentState.page + 1;
        try {
          List<ArticleModel> articles;
          if (currentState.category == 'search') {
            articles =
                await _repository.searchNews(currentState.query, currentState.language, nextPage);
          } else {
            articles = await _repository.fetchNews(
                currentState.category, currentState.language, nextPage);
          }
          final combinedArticles = List.unmodifiable(currentState.articles) +
              articles;
          emit(NewsLoadedState(combinedArticles.cast<ArticleModel>(), nextPage,
              currentState.category, currentState.language)); 
        } catch (error) {
          emit(NewsErrorState(error.toString()));
        }
      }
    });
    on<SearchNewsEvent>((event, emit) async {
      final currentState = state;
      if (currentState is NewsLoadedState) {
      emit(NewsLoadingState());
      try {
        final articles = await _repository.searchNews(event.query, currentState.language, 1);
        emit(NewsLoadedState(articles, 1, 'search', currentState.language, query: event.query));
      } catch (error) {
        emit(NewsErrorState(error.toString()));
      }
    }
    });
  }
}
