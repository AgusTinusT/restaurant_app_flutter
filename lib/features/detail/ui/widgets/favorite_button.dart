import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app/features/favorite/provider/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  final RestaurantDetail restaurant;

  const FavoriteButton({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        final isFavorited = provider.isFavorite(restaurant.id);

        return BlurredIconButton(
          onPressed: () async {
            bool success;
            String message;

            if (isFavorited) {
              success = await provider.removeFavorite(restaurant.id);
              message =
                  success
                      ? '${restaurant.name} berhasil dihapus dari favorit.'
                      : 'Gagal menghapus ${restaurant.name} dari favorit.';
            } else {
              final restaurantToAdd = restaurant.toRestaurant();
              success = await provider.addFavorite(restaurantToAdd);
              message =
                  success
                      ? '${restaurant.name} berhasil ditambahkan ke favorit.'
                      : 'Gagal menambahkan ${restaurant.name} ke favorit.';
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  duration: const Duration(seconds: 2),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },

          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,

            color: isFavorited ? Colors.redAccent : Colors.white,
          ),
        );
      },
    );
  }
}

class BlurredIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;

  const BlurredIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
