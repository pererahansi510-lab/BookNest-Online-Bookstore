import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookApiService {
  static const String apiKey = String.fromEnvironment(
    'GOOGLE_BOOKS_API_KEY',
  );
  Future<List<Book>> fetchBooks({
    String query = 'fiction',
  }) async {
    final Uri uri = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {
        'q': query,
        'maxResults': '20',
        'key': apiKey,
      },
    );

    try {
      final http.Response response = await http
          .get(uri)
          .timeout(
        const Duration(seconds: 20),
      );

      debugPrint('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        jsonDecode(response.body);

        final List<dynamic> items =
            data['items'] ?? [];

        return items
            .map((item) => Book.fromJson(item))
            .toList();
      }

      if (response.statusCode == 429) {
        throw Exception(
          'Book service is temporarily busy. Please try again later.',
        );
      }

      throw Exception(
        'Failed to load books. Error: ${response.statusCode}',
      );
    } catch (error) {
      debugPrint('Book API error: $error');

      throw Exception(
        'Please check your internet connection and try again.',
      );
    }
  }
}