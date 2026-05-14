import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {

  late Book book;

  @override
  void initState() {
    super.initState();
    book = widget.book;
  }

  Future<void> issueBook() async {
    try {
      final res = await ApiService.issueBook(
        book.id,
        2,
        "student",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );

      Navigator.pop(context, true); // 🔥 refresh

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  
  Future<void> returnBook() async {
    try {
      final res = await ApiService.returnBook(
        book.id,
        2,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );

      Navigator.pop(context, true); // 🔥 refresh

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VIT Library"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: Text(
                "VIT Library",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: book.coverUrl.isNotEmpty
                    ? Image.network(
                        book.coverUrl,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              book.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _infoRow('Author', book.author),
                    _infoRow('Category', book.category),
                    _infoRow('ISBN', book.isbn),

                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          book.status == "available"
                              ? "Available"
                              : "Currently unavailable",
                          style: TextStyle(
                            color: book.status == "available"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            
            SizedBox(
              width: double.infinity,
              child: book.status == "available"
                  ? ElevatedButton(
                      onPressed: issueBook,
                      child: const Text("Issue Book"),
                    )
                  : ElevatedButton(
                      onPressed: returnBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("Return Book"),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  static Widget _placeholder() {
    return Container(
      height: 220,
      width: 160,
      color: Colors.indigo.shade50,
      child: const Icon(Icons.menu_book, size: 70, color: Colors.indigo),
    );
  }
}