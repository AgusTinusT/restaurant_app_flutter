import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app/features/detail/ui/widgets/expandable_description.dart';
import 'package:restaurant_app/features/detail/ui/widgets/menu_tabs.dart';
import 'package:restaurant_app/features/detail/ui/widgets/review_section.dart';
import 'package:restaurant_app/features/detail/ui/widgets/sliver_app_bar_detail.dart';

class DetailContentLoaded extends StatelessWidget {
  final RestaurantDetail restaurant;

  const DetailContentLoaded({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBarDetail(restaurant: restaurant),

        SliverList(
          delegate: SliverChildListDelegate([
            _Section(
              title: 'Deskripsi',
              child: ExpandableDescription(text: restaurant.description),
            ),

            MenuTabs(restaurant: restaurant),
            const SizedBox(height: 24),

            ReviewSection(reviews: restaurant.customerReviews),
            const SizedBox(height: 24),
          ]),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(title, style: theme.textTheme.titleLarge),
          ),
          child,
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
