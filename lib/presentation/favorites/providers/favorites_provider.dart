import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/repository_providers.dart';
import '../../../domain/entities/article.dart';

final favoritesProvider =
    NotifierProvider<FavoritesController, List<Article>>(
  FavoritesController.new,
);

class FavoritesController extends Notifier<List<Article>> {
  @override
  List<Article> build() {
    return ref.read(favoritesRepositoryProvider).getFavorites();
  }

  bool isFavorite(String id) {
    return ref.read(favoritesRepositoryProvider).isFavorite(id);
  }

  Future<void> toggle(Article article) async {
    final repository = ref.read(favoritesRepositoryProvider);

    if (repository.isFavorite(article.id)) {
      await repository.remove(article.id);
    } else {
      await repository.add(article);
    }

    state = repository.getFavorites();
  }
}
