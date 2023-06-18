import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  
  final Movie movie;

  const MoviePosterLink({
    super.key, 
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 300 ),
      child: GestureDetector(
        onTap: () => context.push('/home/2/movie/${ movie.id }'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular( 20 ),
          child: Image.network( movie.posterPath ),
        ),
      ),
    );
  }
}