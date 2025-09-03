import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/features/authentication/auth_provider.dart';
import 'package:restaurant_app/features/authentication/auth_repository.dart';
import 'package:restaurant_app/features/authentication/auth_service.dart';
import 'package:restaurant_app/features/authentication/auth_wrapper.dart';
import 'package:restaurant_app/features/authentication/screens/login_screen.dart';
import 'package:restaurant_app/features/authentication/screens/register_screen.dart';
import 'package:restaurant_app/features/authentication/services/user_service.dart';
import 'package:restaurant_app/features/detail/provider/app_bar_provider.dart';
import 'package:restaurant_app/features/detail/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/features/detail/ui/detail_screen.dart';
import 'package:restaurant_app/features/detail/ui/edit_profile_screen.dart';
import 'package:restaurant_app/features/detail/ui/profile_provider.dart';
import 'package:restaurant_app/features/favorite/provider/favorites_provider.dart';
import 'package:restaurant_app/features/home/provider/restaurant_provider.dart';
import 'package:restaurant_app/features/restaurants/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/features/restaurants/ui/restaurant_list_screen.dart';
import 'package:restaurant_app/features/setting/provider/local_notification_provider.dart';
import 'package:restaurant_app/features/setting/provider/navigation_provider.dart';
import 'package:restaurant_app/features/setting/provider/theme_provider.dart';
import 'package:restaurant_app/features/setting/services/local_notification_service.dart';
import 'package:restaurant_app/firebase_options.dart';
import 'package:restaurant_app/style/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationService = LocalNotificationService();
  await localNotificationService.init();
  await localNotificationService.configureLocalTimeZone();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MainApp(prefs: prefs, localNotificationService: localNotificationService),
  );
}

class MainApp extends StatelessWidget {
  final SharedPreferences prefs;
  final LocalNotificationService localNotificationService;

  const MainApp({
    super.key,
    required this.prefs,
    required this.localNotificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<DatabaseHelper>(create: (_) => DatabaseHelper()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<AuthRepository>(
          create:
              (context) =>
                  AuthRepository(authService: context.read<AuthService>()),
        ),

        ChangeNotifierProvider<AuthProvider>(
          create:
              (context) =>
                  AuthProvider(authRepository: context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  RestaurantProvider(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider(create: (context) => RestaurantSearchProvider()),
        ChangeNotifierProvider(
          create:
              (context) => FavoritesProvider(
                databaseHelper: context.read<DatabaseHelper>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ProfileProvider(
                authRepository: context.read<AuthRepository>(),
              ),
        ),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create:
              (context) => LocalNotificationProvider(
                notificationService: localNotificationService,
                prefs: prefs,
              ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const AuthWrapper(),
            routes: {
              RestaurantListScreen.routeName: (context) {
                final initialSearchQuery =
                    ModalRoute.of(context)!.settings.arguments as String?;
                return RestaurantListScreen(
                  initialSearchQuery: initialSearchQuery,
                );
              },
              LoginScreen.routeName: (context) => const LoginScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              EditProfileScreen.routeName:
                  (context) => const EditProfileScreen(),

              DetailScreen.routeName: (context) {
                final restaurantId =
                    ModalRoute.of(context)!.settings.arguments as String;

                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (ctx) {
                        final provider = RestaurantDetailProvider(
                          apiService: ctx.read<ApiService>(),
                          id: restaurantId,
                        );
                        provider.fetchRestaurantDetail();
                        return provider;
                      },
                    ),
                    ChangeNotifierProvider(create: (ctx) => AppBarProvider()),
                  ],
                  child: const DetailScreen(),
                );
              },
            },
          );
        },
      ),
    );
  }
}
