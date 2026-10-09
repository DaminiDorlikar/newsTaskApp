import 'package:dio/dio.dart';
import '../../core/error/app_exception.dart';
import '../models/article_model.dart';

class NewsRemoteDataSource {
  final Dio dio;
  NewsRemoteDataSource({required this.dio});

  Future<List<ArticleModel>> getTopHeadlines({required String category, required int page, int max = 10}) async {
    try {
      final response = await dio.get('/posts', queryParameters: {'limit': max, 'skip': (page - 1) * max});
      final data = response.data as Map<String, dynamic>;
      final posts = data['posts'] as List<dynamic>? ?? [];
      final filtered = posts.where((item) {
        final tags = ((item as Map<String, dynamic>)['tags'] as List<dynamic>? ?? []).map((e) => e.toString().toLowerCase());
        return category == 'business' || tags.any((tag) => tag.contains(category.toLowerCase()));
      }).toList();
      return filtered.map((item) => ArticleModel.fromDummyJson(item as Map<String, dynamic>)).toList();
    } on DioException {
      throw const AppException('Network error. Please check your connection and try again.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw const AppException('Unable to read the news response.');
    }
  }

  Future<List<ArticleModel>> search({required String query, required int page, int max = 10}) async {
    try {
      final response = await dio.get('/posts/search', queryParameters: {'q': query, 'limit': max, 'skip': (page - 1) * max});
      final data = response.data as Map<String, dynamic>;
      final posts = data['posts'] as List<dynamic>? ?? [];
      return posts.map((item) => ArticleModel.fromDummyJson(item as Map<String, dynamic>)).toList();
    } on DioException {
      throw const AppException('Search failed. Please check your connection and try again.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw const AppException('Unable to read the search response.');
    }
  }
}
