import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../data/providers/repository_providers.dart';
import '../../../domain/entities/article.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'business');

final newsFeedProvider =
    AsyncNotifierProvider<NewsFeedController, List<Article>>(
  NewsFeedController.new,
);

class NewsFeedController extends AsyncNotifier<List<Article>> {
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<Article>> build() async {
    final category = ref.watch(selectedCategoryProvider);
    _page = 1;
    _hasMore = true;
    return _fetch(category: category, page: _page);
  }

  Future<List<Article>> _fetch({
    required String category,
    required int page,
  }) async {
    final articles = await ref.read(newsRepositoryProvider).getNews(
          category: category,
          page: page,
        );
    if (articles.isEmpty) _hasMore = false;
    return articles;
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final category = ref.read(selectedCategoryProvider);
      return _fetch(category: category, page: 1);
    });
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore || !state.hasValue) return;
    _loadingMore = true;
    try {
      final nextPage = _page + 1;
      final category = ref.read(selectedCategoryProvider);
      final next = await _fetch(category: category, page: nextPage);
      if (next.isNotEmpty) {
        _page = nextPage;
        state = AsyncData([...state.value!, ...next]);
      }
    } on AppException catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _loadingMore = false;
    }
  }
}
