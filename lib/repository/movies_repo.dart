import '../models/genre_model.dart';
import '../models/movies_model.dart';
import '../service/api_service.dart';

class MoviesRepository {
  final ApiService _apiService;
  MoviesRepository(this._apiService);

  Future<List<MovieModel>> fetchMovies({int page = 1}) async {
    return await _apiService.fetchMovies(page: page);
  }

  // List<MoviesGenre> cachedGenres = [];
  Future<List<GenreModel>> fetchGenres() async {
    // return cachedGenres = await _apiService.fetchGenres();
    return await _apiService.fetchGenres();
  }
}
