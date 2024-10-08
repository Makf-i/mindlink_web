import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindlink_web_app/firebase_options.dart';
import 'package:mindlink_web_app/screens/auth_screens.dart/auth.dart';
import 'package:mindlink_web_app/screens/tabs_screen.dart/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return MaterialApp.router(
            routerConfig: router,
          );
        } else {
          return const MaterialApp(
            home: AuthScreen(),
          );
        }
      },
    );
  }
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TabsScreen(),
      routes: [
        GoRoute(
          path: 'text',
          builder: (context, state) => TabsScreen(
            selectedTab: 'text', 
            strmLink: state.uri.queryParameters['id'], 
          ),
        ),
        GoRoute(
          path: 'video',
          builder: (context, state) => TabsScreen(
            selectedTab: 'video', 
            strmLink: state.uri.queryParameters['id'], 
          ),
        ),
        GoRoute(
          path: 'image',
          builder: (context, state) => TabsScreen(
            selectedTab: 'image', 
            strmLink: state.uri.queryParameters['id'], 
          ),
        ),
      ],
    ),
  ],
);