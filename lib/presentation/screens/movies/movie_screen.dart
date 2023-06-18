import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    // request
    ref.read( movieInfoProvider.notifier ).loadMovie( widget.movieId );
    ref.read( actorsByMovieProvider.notifier ).loadActors( widget.movieId );
  }


  @override
  Widget build(BuildContext context) {

    // get date
    final Movie? movie = ref.watch( movieInfoProvider )[ widget.movieId ];

    // validate data
    if ( movie == null ) {
      return const Scaffold( body: Center( child: CircularProgressIndicator( strokeWidth: 2 ) ));
    }


    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar( movie: movie ),
          SliverList( 
            delegate: SliverChildBuilderDelegate(
              ( context, index ) => _MovieDetails(movie: movie),
              childCount: 1
            ),
          )
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {

  final Movie movie;

  const _MovieDetails({ required this.movie });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of( context ).size;
    final textStyles = Theme.of( context ).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              // * Image
              ClipRRect(
                borderRadius: BorderRadius.circular( 20 ),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox( width: 10 ),

              // * Description
              SizedBox(
                width:  ( size.width - 40 ) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( movie.title, style:  textStyles.titleLarge ),
                    Text( movie.overview )
                  ],
                ),
              )
            ],
          ),
        ),

        // Movie Genders
        Padding(
          padding: const EdgeInsets.all( 8 ),
          child: Wrap(
            children: [
              ...movie.genreIds.map( ( gender ) => Container(
                margin: const EdgeInsets.only( right: 10 ),
                child: Chip(
                  label: Text( gender ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular( 20 )),
                ),
              ))
            ],
          ),
        ),

        _ActorsByMovies( movieId: movie.id.toString() ),

        const SizedBox( height: 50 ),
      ],
    );
  }
}

class _ActorsByMovies extends ConsumerWidget {

  final String movieId;

  const _ActorsByMovies({ required this.movieId});

  @override
  Widget build( BuildContext context, ref ) {

    final actorsByMovie = ref.watch( actorsByMovieProvider );

    if ( actorsByMovie[ movieId ] == null ) {
      return const CircularProgressIndicator( strokeWidth: 2 );
    }

    final actors = actorsByMovie[ movieId ]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: ( context, index ) {
          final actor = actors[ index ];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              children: [

                // Actor photo
                FadeIn(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular( 20 ),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit:  BoxFit.cover,
                    ),
                  ),
                ),

                // Name 
                const SizedBox( height: 5 ),

                Text( actor.name, maxLines: 2 ),
                Text( 
                  actor.character ?? '', 
                  maxLines: 2, 
                  style: const TextStyle( 
                    fontWeight:  FontWeight.bold, 
                    overflow: TextOverflow.ellipsis 
                ) )

              ],
            ),
          );
        }
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family( ( ref, int movieId) {
  // get reference
  final localStorageRepository =ref.watch( localStorageRepositoryProvider );

  return localStorageRepository.isMovieFavorite( movieId ); // if is on favorites
});

class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppBar({ 
    required this.movie 
  });

  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    // reference to is faveroite
    final isFavoritefuture = ref.watch( isFavoriteProvider( movie.id ) );

    // divice screen
    final size = MediaQuery.of( context ).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      // 70% divice screen
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white, 
      actions: [
        IconButton(
          onPressed: (){
            ref.watch( localStorageRepositoryProvider ).toggleFavorite( movie );
            // to not resart screen when add to favorite 
            ref.invalidate( isFavoriteProvider( movie.id ) );
          }, 
          icon: isFavoritefuture.when(
            loading: () => const CircularProgressIndicator( strokeWidth: 2 ),
            data: ( isFavorite ) => isFavorite
            ? const Icon( Icons.favorite_rounded, color:  Colors.red )
            : const Icon( Icons.favorite_border ), 
            error: ( _, __) => throw UnimplementedError(), 
          )
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 5 ),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle( fontSize: 20 ),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network( 
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  
                  if ( loadingProgress != null  ) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.3],
              colors: [
                Colors.black54,
                Colors.transparent
              ]
            ),

            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7, 1.0],
              colors: [
                Colors.transparent,
                Colors.black87
              ]
            ),

             
            const _CustomGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.3],
              colors: [
                Colors.black87,
                Colors.transparent
              ]
            ),

            
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    this.begin = Alignment.center, 
    this.end = Alignment.centerRight, 
    required this.stops, 
    required this.colors
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors
            )
          ),
       ),
      )
;  }
}