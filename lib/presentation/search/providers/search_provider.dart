import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/repository_providers.dart';
import '../../../domain/entities/article.dart';

final searchProvider =
    AsyncNotifierProvider<SearchController, List<Article>>(
  SearchController.new,
);

class SearchController extends AsyncNotifier<List<Article>> {
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  String _query = '';

  bool get hasMore => _hasMore;

  @override
  Future<List<Article>> build() async => [];

  Future<void> search(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    _query = normalized;
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final results = await ref.read(newsRepositoryProvider).search(
            query: _query,
            page: 1,
          );
      if (results.isEmpty) _hasMore = false;
      return results;
    });
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore || _query.isEmpty || !state.hasValue) {
      return;
    }

    _loadingMore = true;
    try {
      final nextPage = _page + 1;
      final next = await ref.read(newsRepositoryProvider).search(
            query: _query,
            page: nextPage,
          );

      if (next.isEmpty) {
        _hasMore = false;
      } else {
        _page = nextPage;
        state = AsyncData([...state.value!, ...next]);
      }
    } finally {
      _loadingMore = false;
    }
  }
}
