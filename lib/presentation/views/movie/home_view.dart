import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({ super.key });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState(){
    super.initState();

    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch( initialLoadingProvider );
    if ( initialLoading ) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final slideShowMovies = ref.watch( moviesSlideshowProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );

    return CustomScrollView(
      slivers: [

        // dislpay navbar when scroll up
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppBar(),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            ( context, index ) {
              return Column( 
                children: [
            
                  MoviesSlideshow( movies: slideShowMovies ),
            
                  MovieHorizontalListView(
                    movies: nowPlayingMovies,
                    title: 'In the cinema',
                    subtitle: 'Monday 20',
                    loadNextPage: () { 
                      ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
                    }
                  ),
            
                  MovieHorizontalListView(
                    movies: upcomingMovies,
                    title: 'Up-coming',
                    subtitle: 'This month',
                    loadNextPage: () { 
                      ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
                    }
                  ),
            
                  MovieHorizontalListView(
                    movies: popularMovies,
                    title: 'Popular',
                    // subtitle: 'Monday 20',
                    loadNextPage: () { 
                      ref.read( popularMoviesProvider.notifier ).loadNextPage();
                    }
                  ),
            
                  MovieHorizontalListView(
                    movies: topRatedMovies,
                    title: 'Top Rated',
                    subtitle: 'Of all time',
                    loadNextPage: () { 
                      ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
                    }
                  ),

                  const SizedBox( height:  10 ),
                ],
              );
            },
            // one page and not infinite
            childCount: 1
          ) 
        )
      ],
      
      
    );
  }
}