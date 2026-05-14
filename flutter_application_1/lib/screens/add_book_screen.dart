import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final title = TextEditingController();
  final author = TextEditingController();

  bool isLoading = false;

  void addBook() async {
    if (title.text.isEmpty || author.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter title & author")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await ApiService.addBook(
        title.text.trim(),
        author.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"] ?? "Book added")),
      );

      title.clear();
      author.clear();

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    title.dispose();
    author.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( 
          child: Column(
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: author,
                decoration: const InputDecoration(
                  labelText: "Author",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addBook,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Add Book"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}