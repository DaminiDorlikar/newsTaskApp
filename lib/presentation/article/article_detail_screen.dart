import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/article.dart';
import '../favorites/providers/favorites_provider.dart';
import '../widgets/article_image.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final Article article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteController = ref.read(favoritesProvider.notifier);
    final isFavorite = ref.watch(
      favoritesProvider.select(
        (articles) => articles.any((item) => item.id == article.id),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove favorite' : 'Save favorite',
            onPressed: () => favoriteController.toggle(article),
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ArticleImage(
              imageUrl: article.imageUrl,
              height: 250,
              borderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(height: 20),
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  article.sourceName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                const Text('•'),
                const SizedBox(width: 8),
                Text(_formatDate(article.publishedAt)),
              ],
            ),
            const SizedBox(height: 20),
            if (article.description.isNotEmpty)
              Text(
                article.description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            const SizedBox(height: 16),
            Text(
              article.content.isNotEmpty
                  ? article.content
                  : 'Open the original article for the complete story.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.65,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final uri = Uri.tryParse(article.url);
                if (uri != null) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Read original article'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return DateFormat('dd MMM yyyy, hh:mm a').format(date.toLocal());
  }
}
