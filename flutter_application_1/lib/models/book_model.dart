class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final String isbn;
  final int? publishedYear;
  final String description;
  final String coverUrl;
  final int availableCopies;
  final int totalCopies;
  final String shelfLocation;
  final String status;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.isbn,
    required this.publishedYear,
    required this.description,
    required this.coverUrl,
    required this.availableCopies,
    required this.totalCopies,
    required this.shelfLocation,
    required this.status, 
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      category: json['category'] ?? '',
      isbn: json['isbn'] ?? '',
      publishedYear: json['published_year'],
      description: json['description'] ?? '',
      coverUrl: json['cover_url'] ?? '',
      availableCopies: json['available_copies'] ?? 0,
      totalCopies: json['total_copies'] ?? 0,
      shelfLocation: json['shelf_location'] ?? '',
      status: json['status'] ?? 'available', 
    );
  }
}