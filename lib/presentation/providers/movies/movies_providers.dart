import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repositorry_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>( (ref) {

  // reference to provider
  final fectMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;

  return MoviesNotifier(
    fetchMoreMovies: fectMoreMovies
  );
});

final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>( (ref) {

  // reference to provider
  final fectMoreMovies = ref.watch( movieRepositoryProvider ).getPopular;

  return MoviesNotifier(
    fetchMoreMovies: fectMoreMovies
  );
});

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>( (ref) {

  // reference to provider
  final fectMoreMovies = ref.watch( movieRepositoryProvider ).getTopRated;

  return MoviesNotifier(
    fetchMoreMovies: fectMoreMovies
  );
});

final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>( (ref) {

  // reference to provider
  final fectMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming;

  return MoviesNotifier(
    fetchMoreMovies: fectMoreMovies
  );
});

typedef MovieCallback = Future<List<Movie>> Function({ int page });

class MoviesNotifier extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies
  }): super([]);

  Future<void> loadNextPage() async {

    if ( isLoading ) return;


    isLoading = true;

    currentPage++;

    final List<Movie> movies = await fetchMoreMovies( page: currentPage );

    state = [ ...state, ...movies ];
    await Future.delayed( const Duration( milliseconds: 300 ) );
    isLoading = false;
  }

}