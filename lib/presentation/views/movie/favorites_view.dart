import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {

  const FavoritesView({ super.key });

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

  bool isLastPage = false;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {

    if ( isLoading || isLastPage ) return;

    isLoading = true;

    final movies = await ref.read( favoriteMoviesprodvider.notifier ).loadNextPage();
    isLoading = false;

    if ( movies.isEmpty ) {
      isLastPage = true;
    }

  }

  @override
  Widget build(BuildContext context) {

    final favoriteMovies = ref.watch( favoriteMoviesprodvider ).values.toList();

    if ( favoriteMovies.isEmpty ) {
      final colors = Theme.of( context ).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon( Icons.favorite_outline_sharp, size: 60, color: colors.primary ),
            Text('Ohh nooo!!', style:  TextStyle( fontSize: 30, color: colors.primary ) ),
            const Text('No favoirtes movies yet', style: TextStyle( fontSize: 20, color:  Colors.black45 ) ),

            const SizedBox( height:  20 ),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'), 
            child: const Text('Start looking for')
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites View'),
      ),
      body: MovieMasonry(
        loadNextPage: loadNextPage,
        movies: favoriteMovies
       )
      );
  }
}