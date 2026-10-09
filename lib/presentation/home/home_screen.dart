import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/article.dart';
import '../article/article_detail_screen.dart';
import '../auth/providers/auth_provider.dart';
import '../favorites/favorites_screen.dart';
import '../search/search_screen.dart';
import '../widgets/article_card.dart';
import '../widgets/state_widgets.dart';
import 'providers/news_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  final categories = const [
    'business',
    'technology',
    'science',
    'health',
    'sports',
    'entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(newsFeedProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedCategoryProvider);
    final newsState = ref.watch(newsFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Intelligence',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
            icon: const Icon(Icons.bookmark_outline),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 58,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final category = categories[index];
                final isSelected = selected == category;
                return ChoiceChip(
                  label: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF172554),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF4F46E5),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFFCBD5E1),
                  ),
                  showCheckmark: false,
                  onSelected: (_) {
                    ref.read(selectedCategoryProvider.notifier).state = category;
                    ref.invalidate(newsFeedProvider);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(newsFeedProvider.notifier).refresh(),
              child: newsState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorState(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(newsFeedProvider),
                ),
                data: (articles) {
                  if (articles.isEmpty) {
                    return const EmptyState(
                      icon: Icons.newspaper_outlined,
                      message: 'No articles found.',
                    );
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: articles.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      if (index == articles.length) {
                        return ref.read(newsFeedProvider.notifier).hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox(height: 20);
                      }

                      final article = articles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () => _openArticle(article),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }
}
