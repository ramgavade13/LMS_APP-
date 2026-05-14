import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiService {

  static const BASE_URL = "http://10.20.27.32:5000";

  // ---------------- SIGNUP ----------------
  static Future<Map<String, dynamic>> signup(
      String email, String password, String role) async {

    final res = await http.post(
      Uri.parse('$BASE_URL/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "role": role,
      }),
    );

    return jsonDecode(res.body);
  }

  // ---------------- LOGIN ----------------
  static Future<Map<String, dynamic>> login(
      String email, String password) async {

    final res = await http.post(
      Uri.parse('$BASE_URL/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(res.body);
  }

  // ---------------- ADD BOOK ----------------
  static Future<Map<String, dynamic>> addBook(
      String title, String author) async {

    final res = await http.post(
      Uri.parse('$BASE_URL/add-book'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "author": author,
        "isbn": "123456",
        "role": "admin",
      }),
    );

    return jsonDecode(res.body);
  }

  // ---------------- FETCH BOOKS ----------------
  static Future<List<Book>> fetchBooks({
    String? search,
    String? category,
  }) async {

    final queryParameters = <String, String>{};

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    if (category != null && category != 'All') {
      queryParameters['category'] = category;
    }

    final uri = Uri.parse('$BASE_URL/books')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    print("Fetch Books Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  // ---------------- RETURN BOOK ----------------
  static Future<Map<String, dynamic>> returnBook(
    int bookId,
    int userId,
  ) async {
    final res = await http.post(
      Uri.parse('$BASE_URL/return_book'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "book_id": bookId,
        "user_id": userId,
      }),
    );

    return jsonDecode(res.body);
  }

  // ---------------- ISSUE BOOK ----------------
  static Future<Map<String, dynamic>> issueBook(
      int bookId, int userId, String role) async {

    final res = await http.post(
      Uri.parse('$BASE_URL/issue_book'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "book_id": bookId,
        "user_id": userId,
        "role": role,
      }),
    );

    return jsonDecode(res.body);
  }
}