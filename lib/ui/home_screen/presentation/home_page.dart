import 'package:edstem_machine_test/ui/common/movie_card.dart';
import 'package:edstem_machine_test/ui/home_detail_screen/presentation/movie_detail_page.dart';
import 'package:edstem_machine_test/ui/home_screen/home_bloc/home_bloc.dart';
import 'package:edstem_machine_test/ui/home_screen/models/get_movie_res_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that displays a grid of movies with search and pagination functionality.
/// Uses BLoC pattern for state management and handles movie data fetching.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();
  
  // Lists to manage different states of movie data
  List<MovieList> _filteredMovies = []; // Movies that match the search query
  List<MovieList> _allMovies = []; // All movies fetched from the API
  List<MovieList> _displayedMovies = []; // Currently displayed movies (paginated)
  
  // State variables for search and pagination
  bool _isSearching = false;
  int _currentPage = 1;
  final int _itemsPerPage = 6; // Number of movies to display per page
  bool _isLoadingMore = false;
  bool _hasMoreItems = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// Handles search functionality by filtering movies based on the search query
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredMovies =
          _allMovies.where((movie) {
            final title = movie.title?.toLowerCase() ?? '';
            return title.contains(query);
          }).toList();
      // Reset pagination when searching
      _currentPage = 1;
      _displayedMovies = _filteredMovies.take(_itemsPerPage).toList();
      _hasMoreItems = _filteredMovies.length > _displayedMovies.length;
    });
  }

  /// Clears the search and resets the movie list to show all movies
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _filteredMovies = _allMovies;
      // Reset pagination when clearing search
      _currentPage = 1;
      _displayedMovies = _filteredMovies.take(_itemsPerPage).toList();
      _hasMoreItems = _filteredMovies.length > _displayedMovies.length;
    });
  }

  /// Loads more movies when the user scrolls to the bottom of the list
  void _loadMoreItems() {
    if (_isLoadingMore || !_hasMoreItems) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate network delay (remove this in production)
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentPage++;
        final nextItems =
            _filteredMovies
                .skip(_displayedMovies.length)
                .take(_itemsPerPage)
                .toList();
        _displayedMovies.addAll(nextItems);
        _isLoadingMore = false;
        _hasMoreItems = _filteredMovies.length > _displayedMovies.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(GetMovieEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: const Text(
            'Movie Platform',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.grey[900],
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            // Movie List with BLoC integration
            BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is HomeGetMovieSuccess) {
                  setState(() {
                    _allMovies = state.movieList.response ?? [];
                    _filteredMovies = _allMovies;
                    _displayedMovies =
                        _filteredMovies.take(_itemsPerPage).toList();
                    _hasMoreItems =
                        _filteredMovies.length > _displayedMovies.length;
                  });
                }
              },
              builder: (context, state) {
                // Show loading indicator for initial load
                if (state is HomeLoading && _currentPage == 1) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  );
                }

                // Show error state with retry option
                if (state is HomeError) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed:
                                () => context.read<HomeBloc>().add(
                                  GetMovieEvent(),
                                ),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show empty state or movie grid
                return _displayedMovies.isEmpty
                    ? Expanded(
                      child: Center(
                        child: Text(
                          _isSearching
                              ? 'No results found'
                              : state is HomeInitial
                              ? 'Search for movies'
                              : 'No movies available',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                    : Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          // Load more items when reaching the bottom
                          if (!_isLoadingMore &&
                              _hasMoreItems &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            _loadMoreItems();
                          }
                          return false;
                        },
                        child: Column(
                          children: [
                            Expanded(child: _buildMovieGrid()),
                            // Show loading indicator for pagination
                            if (_isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            // Show end of list message
                            if (!_hasMoreItems &&
                                _filteredMovies.length > _itemsPerPage)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No more movies to load',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the search bar widget with clear functionality
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.deepPurpleAccent,
        decoration: InputDecoration(
          hintText: 'Search movies...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: _clearSearch,
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[800]?.withValues(alpha: 0.8),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  /// Builds the grid of movie cards
  Widget _buildMovieGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _displayedMovies.length,
      itemBuilder: (context, index) {
        final movie = _displayedMovies[index];
        return MovieCard(
          movie: movie,
          onTap: () => _navigateToDetail(context, movie),
        );
      },
    );
  }

  /// Navigates to the movie detail page
  void _navigateToDetail(BuildContext context, MovieList movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
        fullscreenDialog: true,
      ),
    );
  }
}
