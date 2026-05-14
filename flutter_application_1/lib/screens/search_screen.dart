import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Book> _books = [];
  bool _isLoading = false;

  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Programming',
    'Database',
    'AI',
    'Networks',
    'Electronics'
  ];

  @override
  void initState() {
    super.initState();
    _searchBooks();
  }

  Future<void> _searchBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final books = await ApiService.fetchBooks(
        search: _searchController.text.trim(),
        category: _selectedCategory,
      );

      if (!mounted) return;

      setState(() {
        _books = books;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Books')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search books...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _searchBooks,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _searchBooks(),
                ),
                const SizedBox(height: 10),

                
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'All';
                    });
                    _searchBooks();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _books.isEmpty
                    ? const Center(child: Text('No books found'))
                    : ListView.builder(
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final book = _books[index];

                          return BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookDetailScreen(book: book),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}