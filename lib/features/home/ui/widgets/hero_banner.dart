import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/27/d5/bb/74/lounge.jpg?w=900&h=500&s=1',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 200,
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 50,
              ),
            ),
          ),

          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(204)],
                stops: const [0.5, 1.0],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Temukan Kuliner Terbaik',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(blurRadius: 10.0, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rekomendasi pilihan khusus untuk Anda.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    shadows: [
                      const Shadow(blurRadius: 8.0, color: Colors.black54),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
