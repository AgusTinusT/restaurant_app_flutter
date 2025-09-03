import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/category_model.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';

class MenuTabs extends StatefulWidget {
  final RestaurantDetail restaurant;
  const MenuTabs({super.key, required this.restaurant});

  @override
  State<MenuTabs> createState() => MenuTabsState();
}

class MenuTabsState extends State<MenuTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Foods'), Tab(text: 'Drinks')],
          labelStyle: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMenuList(
                context,
                widget.restaurant.menu.foods,
                Icons.restaurant_menu,
              ),
              _buildMenuList(
                context,
                widget.restaurant.menu.drinks,
                Icons.local_bar,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList(
    BuildContext context,
    List<Category> items,
    IconData icon,
  ) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 140,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(items[index].name, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
