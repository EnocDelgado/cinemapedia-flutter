

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesprodvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>( ( ref ) {

  final localStorageRepository = ref.watch( localStorageRepositoryProvider );

  return StorageMoviesNotifier( localStorageRepository: localStorageRepository );
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {

  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({
    required this.localStorageRepository
  }): super({});


  Future<List<Movie>> loadNextPage() async {
    
    final movies = await localStorageRepository.loadMovies( offset: page * 10, limit: 20 ); //
    // load 10 pages
    page++;

    final tempMoviesMap = <int, Movie>{};
    for ( final movie in movies ) {
      tempMoviesMap[ movie.id ] = movie;
    }

    state = { ...state, ...tempMoviesMap };

    return movies;
  }

  Future<void> toggleFavorite( Movie movie ) async {

    await localStorageRepository.toggleFavorite( movie );

    // verify if movie exist
    final bool isMovieInFavorites = state[ movie.id ] != null;

    if ( isMovieInFavorites ) {
      state.remove( movie.id );
      // update state
      state = { ...state };
    } else {
      state = { ...state, movie.id: movie };
    }
  }

}