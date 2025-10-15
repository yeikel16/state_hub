import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:state_hub/app/routes/routes.dart';
import 'package:state_hub/l10n/l10n.dart';
import 'package:state_hub/src/features/favorites/bloc/favorites_bloc.dart';
import 'package:state_hub/src/features/properties/widgets/widgets.dart';
import 'package:state_hub/src/widgets/widgets.dart';

class FavoritePropertiesView extends StatelessWidget {
  const FavoritePropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
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
                tooltip: l10n.clearAllFavorites,
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
                content: Text(state.error ?? l10n.anUnexpectedErrorOccurred),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return ErrorState(
              message: state.error!,
              onRetry: () {
                context.read<FavoritesBloc>().add(const LoadFavorites());
              },
            );
          }

          if (state.favorites.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: l10n.noFavoritesYet,
              message: l10n.saveYourFavoritePropertiesMessage,
            );
          }

          return ResponsiveBuilder(
            builder: (context, sizingInformation) {
              final isMobile =
                  sizingInformation.deviceScreenType == DeviceScreenType.mobile;

              if (isMobile) {
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
                          FavoritePropertyDetailsRoute(
                            $extra: property,
                          ).go(context);
                        },
                      );
                    },
                  ),
                );
              }

              // Grid layout for desktop/tablet
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoritesBloc>().add(const LoadFavorites());
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 360,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.favorites.length,
                  itemBuilder: (context, index) {
                    final property = state.favorites[index];
                    return PropertyCard(
                      property: property,
                      onTap: () {
                        FavoritePropertyDetailsRoute(
                          $extra: property,
                        ).go(context);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
