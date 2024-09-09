import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/models/post_model.dart';
import 'package:mindlink_web_app/providers/video_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoTile extends ConsumerStatefulWidget {
  const VideoTile({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  ConsumerState<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends ConsumerState<VideoTile>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  var _isPlaying = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _hideTimer;
  bool _playerButtons = false;

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.post.url))
      ..initialize().then((_) {
        setState(() {
          _animationController.forward();
        });
      });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _animationController.dispose();
  }

  void _toggleControls() {
    setState(() {
      _playerButtons = !_playerButtons;
      if (_playerButtons) {
        _animationController.forward();
        _startHideTimer(); // Hide controls after 2 seconds
      }
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel(); // Cancel any previous timer
    _hideTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _playerButtons = false;
        _animationController.reverse();
      });
    });
  }

  void _sharePost(String postId, String postType) async {
    final String encodedUrl = Uri.encodeComponent(postId);
    final String postUrl =
        'https://mindlink-web.vercel.app/video?id=$encodedUrl&type=$postType';

    // Use the share_plus package to share the URL
    await Share.share('Check out this post: $postUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _toggleControls,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8)),
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : const SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    ),
                  ),
                ),
                if (_playerButtons)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: IconButton(
                          icon: Icon(
                            !_isPlaying
                                ? Icons.play_circle_outline_sharp
                                : Icons.pause_circle_outline_sharp,
                            color: Colors.white,
                            size: 90,
                          ),
                          onPressed: _togglePlayPause),
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (_controller.value.isInitialized)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  ref.read(videoProvider.notifier).addToLikedImage(
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
                  _sharePost(widget.post.url, widget.post.type!);
                },
              )
            ],
          ),
        const SizedBox(height: 20)
      ],
    );
  }
}
