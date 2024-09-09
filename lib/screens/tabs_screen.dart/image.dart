import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/providers/image_provider.dart';
import 'package:mindlink_web_app/widgets/image_tile.dart'; // Ensure you have this import for BoxWid

class ImageScreen extends ConsumerWidget {
  const ImageScreen({
    super.key,
    this.strmLink,
  });
  final String? strmLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avlbImagePosts = ref.watch(imageProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.builder(
            itemCount: avlbImagePosts.length,
            itemBuilder: (context, index) {
              final post = avlbImagePosts[index];
              final isLinked = post.url == strmLink;

              return Container(
                decoration: BoxDecoration(
                  border: isLinked
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: BoxWid(
                  post: post,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
