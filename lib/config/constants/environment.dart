import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static String theMovieDbKey = dotenv.env['THE_MOVIEBD_KEY'] ?? 'There is not any api key';
}