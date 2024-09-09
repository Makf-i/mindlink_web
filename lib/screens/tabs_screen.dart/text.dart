import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/providers/text_provider.dart';
import 'package:mindlink_web_app/widgets/text_tile.dart'; // Ensure you have this import for BoxWid

class TextScreen extends ConsumerWidget {
  const TextScreen({
    super.key,
    this.strmLink,
  });
  final String? strmLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avlbTextPosts = ref.watch(textProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: !isMobile
              ? const EdgeInsets.only(top: 5, bottom: 0, left: 250, right: 250)
              : const EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
          child: ListView.builder(
            itemCount: avlbTextPosts.length,
            itemBuilder: (context, index) {
              final post = avlbTextPosts[index];
              final isLinked = post.id == strmLink;

              return TextTile(
                post: post,
                tileColor: isLinked,
              );
            },
          ),
        ),
      ),
    );
  }
}
