import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/genre_model.dart';
import '../../models/movies_model.dart';
import '../../utils/genre_utils.dart';

class GenresListWidget extends ConsumerWidget {
  const GenresListWidget({super.key, required this.movieModel});
  final MovieModel movieModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<GenreModel> moviesGenre = GenreUtils.movieGenresNames(
      movieModel.genreIds,
      ref,
    );
    return Wrap(
      children: List.generate(
        moviesGenre.length,
        (index) =>
            chipWidget(genreName: moviesGenre[index].name, context: context),
      ),
    );
  }

  Widget chipWidget({
    required String genreName,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
          border: Border.all(color: Theme.of(context).colorScheme.surface),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            genreName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
