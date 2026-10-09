import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/article.dart';

class LocalStorageDataSource {
  final Box sessionBox;
  final Box favoritesBox;

  LocalStorageDataSource({
    required this.sessionBox,
    required this.favoritesBox,
  });

  bool get isLoggedIn =>
      sessionBox.get(AppConstants.loggedInKey, defaultValue: false) == true;

  Future<void> setLoggedIn(bool value) async {
    await sessionBox.put(AppConstants.loggedInKey, value);
  }

  List<Article> getFavorites() {
    return favoritesBox.values
        .map((value) => Article.fromMap(Map<dynamic, dynamic>.from(value)))
        .toList();
  }

  bool isFavorite(String id) => favoritesBox.containsKey(id);

  Future<void> saveFavorite(Article article) async {
    await favoritesBox.put(article.id, article.toMap());
  }

  Future<void> removeFavorite(String id) async {
    await favoritesBox.delete(id);
  }
}
