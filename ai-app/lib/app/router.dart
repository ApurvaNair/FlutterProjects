import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/view/login_view.dart';
import '../features/auth/view/signup_view.dart';
import '../features/chat/view/chat_home_view.dart';
import '../features/vision/view/record_vision_view.dart';
import '../features/journal/view/journal_view.dart';
import '../core/utils/go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(
        FirebaseAuth.instance.authStateChanges(),
      ),
      redirect: (context, state) {
        final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
        final bool goingToAuth =
            state.uri.toString() == '/login' ||
            state.uri.toString() == '/signup';

        if (!isLoggedIn && !goingToAuth) return '/login';
        if (isLoggedIn && goingToAuth) return '/chat';

        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginView()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpView()),
        GoRoute(path: '/chat', builder: (_, __) => const ChatHomeView()),
        GoRoute(path: '/vision', builder: (_, __) => const RecordVisionView()),
        GoRoute(path: '/journal', builder: (_, __) => const JournalView()),
      ],
    );
  }
}
