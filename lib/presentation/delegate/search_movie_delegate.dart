import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function( String query );

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  // 
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  // listener
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  // listener to change icon between laoding and delete
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  // determine a period time
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies
  }): super(
    // this change default placeholder
    searchFieldLabel: 'Search movie'
  );

  // When we no use debounce
  void clearStreams() {
    debounceMovies.close();
  }

  void _onQueryChanged( String query ) {
    // when somebody wrtite icon change
    isLoadingStream.add( true );

    // clear or cancel
    if ( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();

    // when stop writting
    _debounceTimer = Timer( const Duration(milliseconds: 500 ), () async{
      
      // get movies
      final movies = await searchMovies( query );
      // add movies to the array
      debounceMovies.add( movies );
      // have last movies searched
      initialMovies = movies;
      // change icon when somebody stop write
      isLoadingStream.add( false );
    });
  } 

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[ index ],
            onMovieSelected: ( context, movie ) {
              clearStreams();
              close(context, movie );
            },
          ),
        );
      },
    );
  }


  @override
  List<Widget>? buildActions(BuildContext context) {

    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: ( context, snapshot ) {
          if ( snapshot.data ?? false ) {
            return SpinPerfect(
              duration: const Duration( seconds: 20 ),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '', 
                icon: const Icon( Icons.refresh_rounded )
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration( milliseconds: 200 ),
            child: IconButton(
              onPressed: () => query = '', 
              icon: const Icon( Icons.clear )
            ),
          );
        }
      ),
      
        

        
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    
    return IconButton(
      onPressed: () {
        clearStreams();
        close( context, null );
      }, 
      icon: const Icon( Icons.arrow_back_ios_new_rounded )
    );
  }

  // results when people press enter
  @override
  Widget buildResults(BuildContext context) {

    return buildResultsAndSuggestions();
  }

  // results when people are writting
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged( query );
    
    return buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({ 
    required this.movie, 
    required this.onMovieSelected 
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of( context ).textTheme;
    final size = MediaQuery.of( context ).size;


    return GestureDetector(
      onTap: () {
        onMovieSelected( context, movie );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10, vertical:  5 ),
        child: Row(
          children: [
    
            //* Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:Image.network( 
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),
    
            const SizedBox( width: 10 ),
    
            //* Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( 
                    movie.title, 
                    style: textStyle.titleMedium 
                  ),
    
                  // validation
                  ( movie.overview.length > 100 ) 
                    ? Text( '${ movie.overview.substring(0, 100 )}...' )
                    : Text( movie.overview ),
                  
                  Row(
                    children: [
                      Icon(  Icons.star_half_rounded, color: Colors.yellow.shade800 ),
                      const SizedBox( width: 5 ),
                      Text( 
                        HumanFormats.number( movie.voteAverage, 1),
                        style: textStyle.bodyMedium!.copyWith( color: Colors.yellow.shade900 ),
                      ),
                    ],
                  )
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}