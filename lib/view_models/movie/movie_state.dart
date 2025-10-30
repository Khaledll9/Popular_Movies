import 'package:mvvm_state_management/models/genre_model.dart';
import 'package:mvvm_state_management/models/movies_model.dart';

class MovieState {
  final int currentPage;
  final List<MovieModel> moviesList;
  final List<GenreModel> genresList;
  final String fetchMovieError;
  final bool isLoading;

  MovieState({
    this.currentPage = 1,
    this.moviesList = const [],
    this.genresList = const [],
    this.fetchMovieError = '',
    this.isLoading = false,
  });

  MovieState copyWith({
    int? currentPage,
    List<MovieModel>? moviesList,
    List<GenreModel>? genresList,
    String? fetchMovieError,
    bool? isLoading,
  }) {
    return MovieState(
      currentPage: currentPage ?? this.currentPage,
      moviesList: moviesList ?? this.moviesList,
      genresList: genresList ?? this.genresList,
      isLoading: isLoading ?? this.isLoading,
      fetchMovieError: fetchMovieError ?? this.fetchMovieError,
    );
  }
}
