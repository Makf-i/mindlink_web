import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/models/post_model.dart';
import 'package:mindlink_web_app/providers/image_provider.dart';
import 'package:share_plus/share_plus.dart';

class BoxWid extends ConsumerStatefulWidget {
  const BoxWid({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  ConsumerState<BoxWid> createState() => _BoxWidState();
}

class _BoxWidState extends ConsumerState<BoxWid> {
  void _sharePost(String postId, String postType) async {
    final String encodedUrl = Uri.encodeComponent(postId);
    final String postUrl =
        'https://mindlink.com/image?id=$encodedUrl&type=$postType';

    // Use the share_plus package to share the URL
    await Share.share('Check out this post: $postUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 0, left: 250, right: 250),
      child: Container(
        color: Colors.blueAccent, // Temporary background color for visibility
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.post.url,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Image failed to load: $error'));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(imageProvider.notifier).addToLikedImage(
                        widget.post.id, widget.post.isFavorite);
                  },
                  icon: Icon(
                    widget.post.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                    color: widget.post.isFavorite ? Colors.red : Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    _sharePost(widget.post.id, widget.post.type!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
