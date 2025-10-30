import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_state_management/view_models/favorite/favorites_provider.dart';
import 'package:mvvm_state_management/views/movies_view.dart';

import '../service/init_getit.dart';
import '../service/navigation_service.dart';
import '../view_models/movie/movie_provider.dart';
import '../widgets/my_error_widget.dart';

final initializationProvider = FutureProvider.autoDispose<void>((ref) async {
  ref.keepAlive();
  await Future.microtask(() async {
    await ref.read(favoritesProvider.notifier).loadFavorites();
    await ref.read(moviesProvider.notifier).getMovies();
  });
});

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initWatch = ref.watch(initializationProvider);
    return Scaffold(
      body: initWatch.when(
        data: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            getIt<NavigationService>().navigateReplace(const MoviesView());
          });
          return const SizedBox.shrink();
        },
        error: (error, _) {
          return Center(
            child: MyErrorWidget(
              errorText: error.toString(),
              retryFunction: () => ref.refresh(initializationProvider),
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        },
      ),
    );
  }
}
