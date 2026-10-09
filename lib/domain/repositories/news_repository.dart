import '../entities/article.dart';

abstract class NewsRepository {
  Future<List<Article>> getNews({
    required String category,
    required int page,
  });

  Future<List<Article>> search({
    required String query,
    required int page,
  });
}
