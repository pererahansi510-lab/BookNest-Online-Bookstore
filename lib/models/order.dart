import 'book.dart';

class BookOrder {
  final String id;
  final String customerName;
  final String email;
  final String address;
  final List<Book> books;
  final double total;
  String status;
  final DateTime createdAt;

  BookOrder({
    required this.id,
    required this.customerName,
    required this.email,
    required this.address,
    required this.books,
    required this.total,
    required this.createdAt,
    this.status = 'Pending',
  });
}