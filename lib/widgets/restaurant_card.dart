import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/features/favorite/provider/favorites_provider.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Hero(
                tag: restaurant.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: 100,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: 100,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.city,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Consumer<FavoritesProvider>(
                builder: (context, provider, child) {
                  final isFavorited = provider.isFavorite(restaurant.id);
                  return IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.redAccent : null,
                    ),
                    onPressed: () async {
                      if (isFavorited) {
                        await provider.removeFavorite(restaurant.id);
                      } else {
                        await provider.addFavorite(restaurant);
                      }

                      if (context.mounted) {
                        final message =
                            isFavorited
                                ? '${restaurant.name} dihapus dari favorit'
                                : '${restaurant.name} ditambahkan ke favorit';
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
