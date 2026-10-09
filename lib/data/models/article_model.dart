import '../../domain/entities/article.dart';

class ArticleModel {
  final String title, description, content, url, image, publishedAt, sourceName;

  const ArticleModel({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.sourceName,
  });

  factory ArticleModel.fromDummyJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final rawTags = json['tags'] as List<dynamic>? ?? [];
    final tags = rawTags.map((e) => e.toString()).join(', ');
    final title = json['title']?.toString() ?? 'Untitled article';
    final body = json['body']?.toString() ?? '';

    // DummyJSON /posts does not include article photos. Prefer an image from
    // the response if a future endpoint supplies one, otherwise use an
    // illustrative image chosen from the post's tags/title.
    final suppliedImage = (json['image'] ?? json['imageUrl'] ?? json['thumbnail'])
        ?.toString()
        .trim();
    final image = suppliedImage != null && suppliedImage.startsWith('http')
        ? suppliedImage
        : _imageFor(tags: tags, title: title, id: id);

    return ArticleModel(
      title: title,
      description: body,
      content: body,
      url: 'https://dummyjson.com/posts/$id',
      image: image,
      publishedAt: '',
      sourceName: tags.isEmpty ? 'DummyJSON News' : tags,
    );
  }

  static String _imageFor({
    required String tags,
    required String title,
    required String id,
  }) {
    final text = '$tags $title'.toLowerCase();
    if (text.contains('tech') || text.contains('computer') || text.contains('ai')) {
      return 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80';
    }
    if (text.contains('business') || text.contains('money') || text.contains('market')) {
      return 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80';
    }
    if (text.contains('science') || text.contains('research') || text.contains('space')) {
      return 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=1200&q=80';
    }
    if (text.contains('health') || text.contains('medical') || text.contains('doctor')) {
      return 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=1200&q=80';
    }
    if (text.contains('sport') || text.contains('football') || text.contains('game')) {
      return 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=1200&q=80';
    }
    if (text.contains('entertainment') || text.contains('movie') || text.contains('music')) {
      return 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1200&q=80';
    }
    // Stable selection keeps generic posts visually varied between cards.
    const generalImages = [
      'https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1495020689067-958852a7765e?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1503694978374-8a2fa686963a?auto=format&fit=crop&w=1200&q=80',
    ];
    final index = (int.tryParse(id) ?? 0) % generalImages.length;
    return generalImages[index];
  }

  Article toEntity() => Article(
        id: url,
        title: title,
        description: description,
        content: content,
        url: url,
        imageUrl: image,
        sourceName: sourceName,
        publishedAt: publishedAt,
      );
}
