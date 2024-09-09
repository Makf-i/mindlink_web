import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/providers/image_provider.dart';
import 'package:mindlink_web_app/providers/text_provider.dart';
import 'package:mindlink_web_app/providers/video_provider.dart';
import 'package:mindlink_web_app/widgets/image_tile.dart';
import 'package:mindlink_web_app/widgets/text_tile.dart';
import 'package:mindlink_web_app/widgets/video_tile.dart';

class LikedScreen extends ConsumerWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final likedImages = ref
        .watch(imageProvider)
        .where((element) => element.isFavorite == true)
        .toList();
    final likedVideos = ref
        .watch(videoProvider)
        .where((element) => element.isFavorite == true)
        .toList();
    final likedText = ref
        .watch(textProvider)
        .where((element) => element.isFavorite == true)
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: isMobile
              ? const EdgeInsets.all(18)
              : const EdgeInsets.only(left: 250.0, right: 250),
          child: likedImages.isNotEmpty ||
                  likedVideos.isNotEmpty ||
                  likedText.isNotEmpty
              ? Column(
                  children: [
                    if (likedImages.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: likedImages.length,
                        itemBuilder: (context, index) => BoxWid(
                          post: likedImages[index],
                        ),
                      ),
                    if (likedVideos.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: likedVideos.length,
                        itemBuilder: (context, index) => VideoTile(
                          post: likedVideos[index],
                        ),
                      ),
                    if (likedText.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: likedText.length,
                        itemBuilder: (context, index) => TextTile(
                          post: likedText[index],
                        ),
                      ),
                  ],
                )
              : const Center(child: Text("No liked post yet")),
        ),
      ),
    );
  }
}
