import '../models/book.dart';
import '../models/order.dart';

class AppData {
  AppData._();

  static final AppData instance = AppData._();

  final List<Book> cart = [];

  final List<BookOrder> orders = [];

  final List<Map<String, String>> users = [
    {
      'name': 'Demo Customer',
      'email': 'customer@booknest.com',
      'password': '123456',
      'role': 'Customer',
    },
    {
      'name': 'Store Staff',
      'email': 'staff@booknest.com',
      'password': '123456',
      'role': 'Store Staff',
    },
    {
      'name': 'System Administrator',
      'email': 'admin@booknest.com',
      'password': '123456',
      'role': 'Administrator',
    },
  ];

  void addToCart(Book book) {
    cart.add(book);
  }

  void removeFromCart(Book book) {
    cart.remove(book);
  }

  void clearCart() {
    cart.clear();
  }

  double get cartTotal {
    return cart.fold(
      0.0,
          (total, book) => total + book.price,
    );
  }

  void addOrder(BookOrder order) {
    orders.add(order);
  }

  bool emailExists(String email) {
    return users.any(
          (user) =>
      user['email']?.toLowerCase() ==
          email.toLowerCase(),
    );
  }

  void registerCustomer({
    required String name,
    required String email,
    required String password,
  }) {
    users.add({
      'name': name,
      'email': email,
      'password': password,
      'role': 'Customer',
    });
  }

  bool validateLogin({
    required String email,
    required String password,
    required String role,
  }) {
    return users.any(
          (user) =>
      user['email']?.toLowerCase() ==
          email.toLowerCase() &&
          user['password'] == password &&
          user['role'] == role,
    );
  }
}