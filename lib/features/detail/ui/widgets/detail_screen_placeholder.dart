import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailScreenPlaceholder extends StatelessWidget {
  const DetailScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300.0,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 200, height: 24, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  Container(width: 150, height: 24, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
