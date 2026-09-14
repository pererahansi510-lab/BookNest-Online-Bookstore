class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final double price;
  final String category;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> volumeInfo =
        json['volumeInfo'] ?? {};

    final Map<String, dynamic> saleInfo =
        json['saleInfo'] ?? {};

    final List<dynamic>? authors =
    volumeInfo['authors'];

    final List<dynamic>? categories =
    volumeInfo['categories'];

    double price = 12.99;

    if (saleInfo['listPrice'] != null &&
        saleInfo['listPrice']['amount'] != null) {
      price =
          (saleInfo['listPrice']['amount'] as num)
              .toDouble();
    }

    String imageUrl = '';

    if (volumeInfo['imageLinks'] != null &&
        volumeInfo['imageLinks']['thumbnail'] != null) {
      imageUrl =
          volumeInfo['imageLinks']['thumbnail']
              .toString()
              .replaceFirst('http:', 'https:');
    }

    return Book(
      id: json['id']?.toString() ?? '',
      title:
      volumeInfo['title']?.toString() ??
          'Unknown Title',
      author:
      authors != null && authors.isNotEmpty
          ? authors.first.toString()
          : 'Unknown Author',
      description:
      volumeInfo['description']?.toString() ??
          'No description is available for this book.',
      imageUrl: imageUrl,
      price: price,
      category:
      categories != null &&
          categories.isNotEmpty
          ? categories.first.toString()
          : 'General',
    );
  }
}