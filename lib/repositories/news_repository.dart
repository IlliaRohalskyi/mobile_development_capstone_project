import 'package:http/http.dart' as http;
import 'package:mobile_development_capstone_project/models/article_model.dart';
import 'package:mobile_development_capstone_project/constants/news_api_constants.dart';
import 'dart:convert';

class NewsRepository {
  Future<List<ArticleModel>> fetchNews(
      String category, String language, int page) async {
    final url = "${NewsApiConstants.baseUrl}"
        "apiKey=${NewsApiConstants.newsApiKey}"
        "&category=$category"
        "&language=$language"
        "&page=$page";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final articles = data['articles'] as List<dynamic>;
      return articles.map((json) => ArticleModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

    Future<List<ArticleModel>> searchNews(String? query, String language, int page) async {
      final url = "${NewsApiConstants.baseUrl}"
          "apiKey=${NewsApiConstants.newsApiKey}"
          "&q=$query"
          "&language=$language"
          "&page=$page";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final articles = data['articles'] as List<dynamic>;
        return articles.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        return [];
      }
    }
  }
