import 'package:flutter/material.dart';
import 'package:tmdb_integration/category.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MovieHomePage(),
    theme: ThemeData.dark(), // Dark theme for a modern look
  ));
}

class MovieHomePage extends StatelessWidget {
  const MovieHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Gradient background for AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Discover Movies', // Custom title
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true, // Centered title
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.2, // Slight transparency for the background
              child: Image.network(
                'https://image.tmdb.org/t/p/original//wO5QSWZPBT71gMLvrRex0bVc0V9.jpg', // A movie-themed background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20), // Spacing

                // Categories as Cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      // Category Card: Popular Movies
                      _buildCategoryCard(
                        context,
                        title: 'Popular Movies',
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg',
                        apiUrl: 'https://api.themoviedb.org/3/movie/popular',
                      ),
                      // Category Card: Top Rated Movies
                      _buildCategoryCard(
                        context,
                        title: 'Top Rated',
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
                        apiUrl: 'https://api.themoviedb.org/3/movie/top_rated',
                      ),
                      // Category Card: Upcoming Movies
                      _buildCategoryCard(
                        context,
                        title: 'Upcoming Movies',
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg',
                        apiUrl: 'https://api.themoviedb.org/3/movie/upcoming',
                      ),
                      // Category Card: Now Playing Movies
                      _buildCategoryCard(
                        context,
                        title: 'Now Playing',
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500/zNqR1fEd8ZsFW4SHXVAB3fFzZpX.jpg',
                        apiUrl:
                            'https://api.themoviedb.org/3/movie/now_playing',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // A function to build category cards
  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required String apiUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieCategoryPage(
              category: title,
              apiUrl: apiUrl,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
