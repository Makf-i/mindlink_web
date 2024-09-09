import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/models/post_model.dart';
import 'package:mindlink_web_app/providers/text_provider.dart';
import 'package:share_plus/share_plus.dart';

class TextTile extends ConsumerWidget {
  final PostModel post;
  final bool? tileColor;

  const TextTile({
    super.key,
    required this.post,
    this.tileColor = false,
  });

  void _sharePost(String postId, String postType) async {
    // final String encodedUrl = Uri.encodeComponent(postId);
    final String postUrl =
        'https://mindlink-web.vercel.app/text?id=$postId&type=$postType';

    print(postUrl);
    // Use the share_plus package to share the URL
    await Share.share('Check out this post: $postUrl');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return ListTile(
      tileColor: tileColor! ? Colors.grey[300] : Colors.transparent,
      trailing: !isMobile
          ? IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final Offset offset = renderBox.localToGlobal(Offset.zero);
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx + renderBox.size.width - 100, // Adjust X position
                    offset.dy +
                        renderBox.size.height, // Position it below the tile
                    offset.dx + renderBox.size.width, // Right edge
                    offset.dy, // Top edge
                  ),
                  items: [
                    PopupMenuItem(
                      onTap: () {
                        _sharePost(post.id, post.type!);
                      },
                      child: const Text("Share"),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        ref
                            .read(textProvider.notifier)
                            .addToLikedImage(post.id, post.isFavorite);
                      },
                      child: Text(post.isFavorite
                          ? "Remove from liked posts"
                          : "Like this message"),
                    ),
                  ],
                );
              },
            )
          : null,
      onLongPress: isMobile
          ? () {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  offset.dx + renderBox.size.width - 100, // Adjust X position
                  offset.dy +
                      renderBox.size.height, // Position it below the tile
                  offset.dx + renderBox.size.width, // Right edge
                  offset.dy, // Top edge
                ),
                items: [
                  PopupMenuItem(
                    onTap: () {
                      _sharePost(post.id, post.type!);
                    },
                    child: const Text("Share"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      ref
                          .read(textProvider.notifier)
                          .addToLikedImage(post.id, post.isFavorite);
                    },
                    child: Text(post.isFavorite
                        ? "Remove from liked posts"
                        : "Like this message"),
                  ),
                ],
              );
            }
          : null,
      title: Text(post.description!),
      contentPadding: const EdgeInsets.only(left: 10),
    );
  }
}
