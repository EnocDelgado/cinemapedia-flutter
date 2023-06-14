import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasource {

  Future<List<Movie>> gteNowPlaying({ int page = 1 });
}