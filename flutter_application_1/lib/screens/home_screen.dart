import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';
import 'search_screen.dart';
import 'add_book_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = ApiService.fetchBooks();
  }

  Future<void> _refreshBooks() async {
    final future = ApiService.fetchBooks();
    setState(() => _booksFuture = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIT Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _refreshBooks,
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {

            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 140),
                  Center(child: Text('Error: ${snapshot.error}')),
                ],
              );
            }

            
            final books = snapshot.data ?? [];

            if (books.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Center(child: Text('No books available')),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

                return BookCard(
                  book: book,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(book: book),
                      ),
                    );

                    _refreshBooks(); 
                  },
                );
              },
            );
          },
        ),
      ),

  
      floatingActionButton: widget.role == "admin"
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddBookScreen(),
                  ),
                );

                _refreshBooks(); 
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}