class Article {
  final String id;
  final String title;
  final String description;
  final String content;
  final String url;
  final String imageUrl;
  final String sourceName;
  final String publishedAt;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'content': content,
        'url': url,
        'imageUrl': imageUrl,
        'sourceName': sourceName,
        'publishedAt': publishedAt,
      };

  factory Article.fromMap(Map<dynamic, dynamic> map) => Article(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        description: map['description']?.toString() ?? '',
        content: map['content']?.toString() ?? '',
        url: map['url']?.toString() ?? '',
        imageUrl: map['imageUrl']?.toString() ?? '',
        sourceName: map['sourceName']?.toString() ?? '',
        publishedAt: map['publishedAt']?.toString() ?? '',
      );
}
