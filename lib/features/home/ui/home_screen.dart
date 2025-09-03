import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/favorite/provider/favorites_provider.dart';
import 'package:restaurant_app/features/home/provider/restaurant_provider.dart';
import 'package:restaurant_app/features/home/ui/widgets/hero_banner.dart';
import 'package:restaurant_app/features/restaurants/ui/restaurant_list_screen.dart';
import 'package:restaurant_app/features/setting/provider/navigation_routes.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<RestaurantProvider>(
              context,
              listen: false,
            ).refresh();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        Navigator.pushNamed(
                          context,
                          RestaurantListScreen.routeName,
                          arguments: query,
                        );
                        _searchController.clear();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search for restaurants...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(height: 200, child: HeroBanner()),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Restaurants',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RestaurantListScreen.routeName,
                          );
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Consumer<RestaurantProvider>(
                    builder: (context, provider, child) {
                      switch (provider.state) {
                        case ResultState.loading:
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[500]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              children: List.generate(
                                3,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        case ResultState.hasData:
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                provider.restaurants.length > 3
                                    ? 3
                                    : provider.restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant = provider.restaurants[index];
                              return RestaurantCard(
                                restaurant: restaurant,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    NavigationRoute.detailRoute.name,
                                    arguments: restaurant.id,
                                  ).then((_) {
                                    Provider.of<FavoritesProvider>(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      listen: false,
                                    ).refreshFavorites();
                                  });
                                },
                              );
                            },
                          );
                        case ResultState.noData:
                          return Center(child: Text(provider.message));
                        case ResultState.error:
                          return Center(child: Text(provider.message));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
