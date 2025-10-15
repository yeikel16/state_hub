import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_hub/app/routes/routes.dart';
import 'package:state_hub/src/features/favorites/bloc/favorites_bloc.dart';
import 'package:state_hub/src/features/properties/widgets/widgets.dart';

class FavoritePropertiesView extends StatelessWidget {
  const FavoritePropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state.favorites.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  context.read<FavoritesBloc>().add(const ClearAllFavorites());
                },
                tooltip: 'Clear all favorites',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          final hasError = state.error != null;
          if (hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'An unexpected error occurred'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<FavoritesBloc>().add(const LoadFavorites());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding properties to your favorites',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoritesBloc>().add(const LoadFavorites());
            },
            child: ListView.builder(
              itemCount: state.favorites.length,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                final property = state.favorites[index];
                return PropertyCard(
                  property: property,
                  onTap: () {
                    FavoritePropertyDetailsRoute($extra: property).go(context);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
