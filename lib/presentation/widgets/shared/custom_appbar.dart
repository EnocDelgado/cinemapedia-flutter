import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegate/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of( context ).colorScheme;
    final ttitleStyle = Theme.of( context ).textTheme.titleMedium;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10 ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon( Icons.movie_creation, color: colors.primary ),
              const SizedBox( width:  5 ),
              Text('Cinemapedia', style: ttitleStyle ),

              const Spacer(),

              IconButton(
                onPressed: (){

                  final movierepositoryProvider = ref.read( movieRepositoryProvider );

                  showSearch<Movie?>(
                    context: context, 
                    // delegate is who works the search
                    delegate: SearchMovieDelegate(
                      searchMovies: movierepositoryProvider.searchMovies,
                    )
                  ).then(( movie ) {
                    if ( movie == null ) return;
                    // go to movie screen
                    context.push('/movie/${ movie.id }');
                  });
                }, 
                icon: const Icon( Icons.search )
              ),
            ],
          ),
        ),
      ),
    );
  }
}