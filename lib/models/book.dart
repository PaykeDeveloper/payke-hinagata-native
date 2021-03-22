class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.releaseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String author;
  DateTime releaseDate;
  DateTime createdAt;
  DateTime updatedAt;
}
