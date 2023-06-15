
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {

 static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNvigationBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

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