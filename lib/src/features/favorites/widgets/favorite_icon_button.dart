import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/features/favorites/bloc/favorites_bloc.dart';

class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({
    required this.property, super.key,
  });

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(property.id);

        return IconButton(
          icon: isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(Icons.favorite_border),
          onPressed: () {
            context.read<FavoritesBloc>().add(
              ToggleFavorite(property),
            );
          },
          iconSize: 28,
        );
      },
    );
  }
}
