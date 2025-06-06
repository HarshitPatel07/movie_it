import 'dart:convert';
import 'package:get/get.dart';
import 'package:movie_it/controller/auth_controller.dart';
import 'package:movie_it/controller/database_controller.dart';
import 'package:movie_it/models/movie_detail_model.dart';
import 'package:movie_it/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie_it/models/movie_popular_model.dart';
import 'package:movie_it/models/movie_top_model.dart';

class MovieController extends GetxController {
  static const API_KEY = 'api_key=f2d2871130f2186d01353e79f53320b9';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  MovieModel? movieModel;
  var searchResults = <MovieModel>[].obs; // Observable list for search results
  MoviePopularModel? moviePopularModel;
  MovieTopModel? movieTopModel;
  MovieDetail? movieDetail;

  var isLoading = false.obs;
  var isLoadingPopular = false.obs;
  var isLoadingTop = false.obs;
  var isLoadingDetail = false.obs;

  final dbC = Get.find<DatabaseController>();
  final authC = Get.find<AuthController>();

  void fetchDataMovies() async {
    try {
      isLoading(true);
      var response =
          await http.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));
      print("Now Playing Response: ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        movieModel = MovieModel.fromJson(result);
        update(); // ✅ Force UI update
      } else {
        print("Error Fetching Data: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchDataPopularMovie() async {
    try {
      isLoadingPopular(true);
      var response =
          await http.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY'));
      print("Popular Movies Response: ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        moviePopularModel = MoviePopularModel.fromJson(result);
        update();
      } else {
        print("Error Fetching Data: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoadingPopular(false);
    }
  }

  void fetchDataTopMovie() async {
    try {
      isLoadingTop(true);
      var response =
          await http.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY'));
      print("Top Rated Movies Response: ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        movieTopModel = MovieTopModel.fromJson(result);
        update();
      } else {
        print("Error Fetching Data: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoadingTop(false);
    }
  }

  void fetchDataDetailMovie(int id) async {
    try {
      isLoadingDetail(true);
      var response = await http.get(Uri.parse('$BASE_URL/movie/$id?$API_KEY'));
      print("Movie Detail Response: ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        movieDetail = MovieDetail.fromJson(result);
        dbC.getIdMovie(authC.getUserId(), id);
        update();
      } else {
        print("Error Fetching Data: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoadingDetail(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchDataMovies();
    fetchDataPopularMovie();
    fetchDataTopMovie();
  }
}
