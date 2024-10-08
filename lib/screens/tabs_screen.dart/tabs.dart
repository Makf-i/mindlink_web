import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/providers/image_provider.dart';
import 'package:mindlink_web_app/providers/text_provider.dart';
import 'package:mindlink_web_app/providers/video_provider.dart';
import 'package:mindlink_web_app/screens/liked_screen.dart';
import 'package:mindlink_web_app/screens/tabs_screen.dart/image.dart';
import 'package:mindlink_web_app/screens/tabs_screen.dart/text.dart';
import 'package:mindlink_web_app/screens/tabs_screen.dart/video.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({
    super.key,
    this.selectedTab,
    this.strmLink,
  });

  final String? selectedTab;
  final String? strmLink;

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(textProvider.notifier).loadData();
    ref.read(videoProvider.notifier).loadData();
    ref.read(imageProvider.notifier).loadData();

    if (widget.selectedTab == 'text') {
      _selectedIndex = 0; // Text tab index
    } else if (widget.selectedTab == 'video') {
      _selectedIndex = 1; // Video tab index
    } else if (widget.selectedTab == 'image') {
      _selectedIndex = 2; // Image tab index
    }
  }

  // final List<Widget> _screens = const [
  //   TextScreen(),
  //   VideoScreen(),
  //   ImageScreen(),
  //   LikedScreen(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindLinking'),
        actions: !isMobile
            ? [
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout))
              ]
            : null,
      ),
      drawer: isMobile
          ? Drawer(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      label: const Text("Liked posts"),
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LikedScreen()));
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.logout_outlined),
                      label: const Text("SignOut"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            NavigationRailWidget(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          Expanded(
            child: _buildSelectedScreen(),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_fields),
                  label: 'Text',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library),
                  label: 'Videos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.image),
                  label: 'Images',
                ),
              ],
            )
          : null, // Don't show BottomNavigationBar on larger screens
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return TextScreen(
            strmLink:
                widget.strmLink); // Pass the stream link to the TextScreen
      case 1:
        return VideoScreen(
            strmLink:
                widget.strmLink); // Pass the stream link to the VideoScreen
      case 2:
        return ImageScreen(
            strmLink:
                widget.strmLink); // Pass the stream link to the ImageScreen
      default:
        return const LikedScreen(); // Fallback to LikedScreen
    }
  }
}

class NavigationRailWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const NavigationRailWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.text_fields),
          label: Text('Text'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.video_library),
          label: Text('Videos'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.image),
          label: Text('Images'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.favorite),
          label: Text('Liked Posts'),
        ),
      ],
    );
  }
}
