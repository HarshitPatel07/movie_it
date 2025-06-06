import 'package:get/get.dart';
import 'package:movie_it/models/movie_model.dart';

class MovieService extends GetConnect {
  static const API_KEY = 'api_key=f2d2871130f2186d01353e79f53320b9';
  Future<Response> fetchNowPlayingMovies() =>
      get('$BASE_URL/movie/now_playing?$API_KEY');

  Future<Response> searchMovies(String query) =>
      get('$BASE_URL/search/movie?$API_KEY&query=$query');
  static const BASE_URL = 'https://api.themoviedb.org/3';

  Future<Response> getNowPlayingMovies() =>
      get('$BASE_URL/movie/now_playing?$API_KEY');
}
