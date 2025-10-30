import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_state_management/view_models/favorite/favorites_provider.dart';

import '../constants/my_app_icons.dart';
import '../widgets/movies/movies_widget.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Movies"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).clearAllFavs();
            },
            icon: const Icon(MyAppIcons.delete, color: Colors.red),
          ),
        ],
      ),
      body: favoriteState.favoritesList.isEmpty
          ? Center(
              child: Text(
                'No Favorites Yet...',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: favoriteState.favoritesList.length,
              itemBuilder: (context, index) {
                return MoviesWidget(
                  movieModel: favoriteState.favoritesList.reversed
                      .toList()[index],
                ); //const Text("data");
              },
            ),
    );
  }
}
