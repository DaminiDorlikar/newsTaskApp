import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remote;

  NewsRepositoryImpl(this.remote);

  @override
  Future<List<Article>> getNews({
    required String category,
    required int page,
  }) async {
    final models = await remote.getTopHeadlines(
      category: category,
      page: page,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Article>> search({
    required String query,
    required int page,
  }) async {
    final models = await remote.search(
      query: query,
      page: page,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
