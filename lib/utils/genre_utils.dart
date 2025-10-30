import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_state_management/view_models/movie/movie_provider.dart';

import '../models/genre_model.dart';

class GenreUtils {
  static List<GenreModel> movieGenresNames(List<int> genreIds, WidgetRef ref) {
    final movieState = ref.watch(moviesProvider);
    final cachedGenres = movieState.genresList;
    List<GenreModel> genresNames = [];
    for (var genreId in genreIds) {
      var genre = cachedGenres.firstWhere(
        (g) => g.id == genreId,
        orElse: () => GenreModel(id: 5448484, name: 'Unknown'),
      );
      genresNames.add(genre);
    }
    return genresNames;
  }
}
