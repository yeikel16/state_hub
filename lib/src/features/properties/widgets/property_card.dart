import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/features/favorites/favorites.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    required this.property,
    this.onTap,
    super.key,
  });

  final PropertyModel property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property.city,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${property.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FavoriteIconButton(property: property),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (property.image == null || property.image!.isEmpty) {
      return Container(
        height: 180,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.home,
            size: 64,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Hero(
        tag: 'tag-${property.id}',
        child: CachedNetworkImage(
          imageUrl: property.image!,
          fit: BoxFit.fill,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 64,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
