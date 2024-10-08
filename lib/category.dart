import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MovieCategoryPage extends StatefulWidget {
  final String category;
  final String apiUrl;

  const MovieCategoryPage({
    required this.category,
    required this.apiUrl,
    Key? key,
  }) : super(key: key);

  @override
  _MovieCategoryPageState createState() => _MovieCategoryPageState();
}

class _MovieCategoryPageState extends State<MovieCategoryPage> {
  final Dio dio = Dio();
  final String apiKey = 'dde418abbb338f0a7718835523d2263b'; // TMDB API Key
  List<dynamic> movies = [];
  int currentPage = 1;
  bool isLoading = false;

  // Fetch movies from the selected category
  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await dio.get(
        widget.apiUrl,
        queryParameters: {
          'api_key': apiKey,
          'language': 'en-US',
          'page': currentPage,
        },
      );

      log('Status Code: ${response.statusCode}');
      setState(() {
        if (currentPage == 1) {
          movies = response.data['results'];
        } else {
          movies.addAll(response.data['results']);
        }
      });
    } catch (e) {
      log('Error fetching movies: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies(); // Fetch movies when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Movies'),
        actions: [
          // Search Icon in AppBar
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(movies: movies),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Movies Grid
          Expanded(
            child: movies.isEmpty && !isLoading
                ? const Center(child: Text('No movies found'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two movies per row
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7, // Adjusts the poster size
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      var movie = movies[index];
                      return Card(
                        child: Column(
                          children: [
                            // Movie Poster
                            movie['poster_path'] != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Text('No Image'),
                                    ),
                                  ),

                            // Movie Title
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                movie['title'] ?? 'Untitled',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Movie Release Date
                            Text(
                              'Release Date: ${movie['release_date'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Load more button
          if (movies.isNotEmpty && !isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  currentPage++;
                  fetchMovies(); // Fetch next page
                },
                child: const Text('Load More'),
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

// Search Delegate for searching movies
class MovieSearchDelegate extends SearchDelegate {
  final List<dynamic> movies;

  MovieSearchDelegate({required this.movies});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<dynamic> searchResults = movies.where((movie) {
      final title = movie['title']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two movies per row
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7, // Adjusts the poster size
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        var movie = searchResults[index];
        return Card(
          child: Column(
            children: [
              // Movie Poster
              movie['poster_path'] != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('No Image'),
                      ),
                    ),

              // Movie Title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie['title'] ?? 'Untitled',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Movie Release Date
              Text(
                'Release Date: ${movie['release_date'] ?? 'N/A'}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestions = movies.where((movie) {
      final title = movie['title']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        var movie = suggestions[index];
        return ListTile(
          title: Text(movie['title'] ?? 'Untitled'),
        );
      },
    );
  }
}
