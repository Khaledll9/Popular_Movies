import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../models/movies_model.dart';
import '../../repository/movies_repo.dart';
import '../../service/init_getit.dart';
import 'movie_state.dart';

final moviesProvider = StateNotifierProvider<MoviesProvider, MovieState>(
  (_) => MoviesProvider(),
);

final currentMovie = Provider.family<MovieModel, int>((ref, index) {
  final movieState = ref.watch(moviesProvider);
  return movieState.moviesList[index];
});

class MoviesProvider extends StateNotifier<MovieState> {
  MoviesProvider() : super(MovieState());

  final MoviesRepository _moviesRepository = getIt<MoviesRepository>();
  Future<void> getMovies() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      if (state.genresList.isEmpty) {
        final genresList = await _moviesRepository.fetchGenres();
        state = state.copyWith(genresList: genresList);
      }
      List<MovieModel> movies = await _moviesRepository.fetchMovies(
        page: state.currentPage,
      );
      state = state.copyWith(
        moviesList: [...state.moviesList, ...movies],
        currentPage: state.currentPage + 1,
        fetchMovieError: '',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(fetchMovieError: e.toString(), isLoading: false);
      rethrow;
    }
  }
}
