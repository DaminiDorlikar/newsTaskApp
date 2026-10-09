import '../../domain/entities/article.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/local_storage_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final LocalStorageDataSource local;

  FavoritesRepositoryImpl(this.local);

  @override
  List<Article> getFavorites() => local.getFavorites();

  @override
  bool isFavorite(String id) => local.isFavorite(id);

  @override
  Future<void> add(Article article) => local.saveFavorite(article);

  @override
  Future<void> remove(String id) => local.removeFavorite(id);
}
