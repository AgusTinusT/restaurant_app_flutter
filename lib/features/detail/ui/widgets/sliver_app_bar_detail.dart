import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app/features/detail/provider/app_bar_provider.dart';
import 'package:restaurant_app/features/detail/ui/widgets/category_row.dart';
import 'package:restaurant_app/features/detail/ui/widgets/favorite_button.dart';

class SliverAppBarDetail extends StatelessWidget {
  final RestaurantDetail restaurant;

  const SliverAppBarDetail({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AppBarProvider>(
      builder: (context, appBarProvider, _) {
        return SliverAppBar(
          pinned: true,
          expandedHeight: 300.0,
          backgroundColor: appBarProvider.appBarColor,
          elevation: appBarProvider.appBarElevation,

          automaticallyImplyLeading: false,

          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlurredIconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeader(context, theme),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),

              child: FavoriteButton(restaurant: restaurant),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: restaurant.id,
          child: Image.network(
            ApiService.buildPictureUrl(
              restaurant.pictureId,
              resolution: 'large',
            ),
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
          ),
        ),

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
              colors: [Colors.transparent, Colors.black87],
            ),
          ),
        ),
        Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                restaurant.name,

                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CategoryRow(categories: restaurant.categories),
              const SizedBox(height: 8),
              _buildAddressAndRating(context, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressAndRating(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${restaurant.address}, ${restaurant.city}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: theme.colorScheme.secondary, size: 18),
              const SizedBox(width: 4),
              Text(
                restaurant.rating.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
