import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantListPlaceholder extends StatelessWidget {
  const RestaurantListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 18.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 14.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(width: 50, height: 14.0, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
