import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/detail/provider/app_bar_provider.dart';
import 'package:restaurant_app/features/detail/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/features/detail/ui/widgets/detail_content_loaded.dart';
import 'package:restaurant_app/features/detail/ui/widgets/detail_screen_placeholder.dart';
import 'package:restaurant_app/utils/result_state.dart';

class DetailScreen extends StatelessWidget {
  static const String routeName = '/detail';

  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        context.read<AppBarProvider>().onScroll(scrollInfo, context);
        return true;
      },
      child: Scaffold(
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, detailProvider, _) {
            switch (detailProvider.state) {
              case ResultState.loading:
                return const DetailScreenPlaceholder();

              case ResultState.error:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      detailProvider.message,
                      textAlign: TextAlign.center,

                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );

              case ResultState.hasData:
                return DetailContentLoaded(restaurant: detailProvider.result!);

              default:
                return const Center(child: Text('Data tidak ditemukan.'));
            }
          },
        ),
      ),
    );
  }
}
