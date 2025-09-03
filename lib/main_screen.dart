import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/favorite/ui/favorites_screen.dart';
import 'package:restaurant_app/features/home/ui/home_screen.dart';
import 'package:restaurant_app/features/setting/provider/local_notification_provider.dart';
import 'package:restaurant_app/features/setting/provider/navigation_provider.dart';
import 'package:restaurant_app/features/setting/ui/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  static final List<String> _appBarTitles = <String>[
    'Home',
    'Favorite Restaurants',
    'Settings',
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocalNotificationProvider>(
        context,
        listen: false,
      ).requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(MainScreen._appBarTitles[provider.selectedIndex]),
          ),
          body: MainScreen._widgetOptions[provider.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_outlined),
                activeIcon: Icon(Icons.restaurant),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: provider.selectedIndex,
            onTap: (index) => provider.setIndex(index),
          ),
        );
      },
    );
  }
}
