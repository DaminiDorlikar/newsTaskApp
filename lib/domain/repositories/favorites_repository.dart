import '../entities/article.dart';

abstract class FavoritesRepository {
  List<Article> getFavorites();
  bool isFavorite(String id);
  Future<void> add(Article article);
  Future<void> remove(String id);
}
