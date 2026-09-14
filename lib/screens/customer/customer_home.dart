import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../services/app_data.dart';
import '../../services/book_api_service.dart';
import '../../widgets/book_card.dart';
import '../login_screen.dart';
import 'book_details_screen.dart';
import 'cart_screen.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  final BookApiService _apiService = BookApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Book> _books = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedCategory = 'Fiction';

  final List<String> _categories = [
    'Fiction',
    'Technology',
    'Business',
    'Science',
    'History',
  ];

  @override
  void initState() {
    super.initState();
    _loadBooks('fiction');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final books = await _apiService.fetchBooks(query: query);

      if (!mounted) return;

      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _searchBooks() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _loadBooks(_selectedCategory.toLowerCase());
      return;
    }

    _loadBooks(query);
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _searchController.clear();
    });

    _loadBooks(category.toLowerCase());
  }

  void _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF155E4B),
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'BookNest',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: _openCart,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
              ),
              if (AppData.instance.cart.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${AppData.instance.cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          final query = _searchController.text.trim();

          await _loadBooks(
            query.isEmpty
                ? _selectedCategory.toLowerCase()
                : query,
          );
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF155E4B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find your next book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Search thousands of books and discover something new.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchBooks(),
                      decoration: InputDecoration(
                        hintText: 'Search by title, author or keyword',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF155E4B),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _searchBooks,
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF155E4B),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFB6D8CD),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  0,
                  8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Browse Categories',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E332D),
                            ),
                          ),
                          Icon(
                            Icons.tune,
                            color: Color(0xFF155E4B),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final selected =
                              category == _selectedCategory;

                          return ChoiceChip(
                            label: Text(category),
                            selected: selected,
                            onSelected: (_) {
                              _selectCategory(category);
                            },
                            selectedColor:
                            const Color(0xFF155E4B),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: selected
                                  ? const Color(0xFF155E4B)
                                  : const Color(0xFFDDE5E1),
                            ),
                            labelStyle: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF42534E),
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  14,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchController.text.trim().isEmpty
                          ? 'Popular $_selectedCategory Books'
                          : 'Search Results',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E332D),
                      ),
                    ),
                    if (!_isLoading && _errorMessage == null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F1EB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${_books.length} books',
                          style: const TextStyle(
                            color: Color(0xFF155E4B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF155E4B),
                  ),
                ),
              )
            else if (_errorMessage != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE1F1EB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wifi_off_rounded,
                            size: 42,
                            color: Color(0xFF155E4B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Unable to load books',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            _loadBooks(
                              _selectedCategory.toLowerCase(),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF155E4B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_books.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 70,
                          color: Colors.black26,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'No books found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Try searching with another keyword.',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    30,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final book = _books[index];

                        return BookCard(
                          book: book,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BookDetailsScreen(
                                      book: book,
                                    ),
                              ),
                            );

                            if (mounted) {
                              setState(() {});
                            }
                          },
                        );
                      },
                      childCount: _books.length,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.62,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}