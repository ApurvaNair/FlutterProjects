import 'package:app/core/utils/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/view/login_view.dart';
import '../features/auth/view/signup_view.dart';
import '../features/chat/view/chat_home_view.dart';
import '../features/vision/view/record_vision_view.dart';
import '../features/journal/view/journal_view.dart';
import '../providers.dart';

class AppRouter {
  static GoRouter router(WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(
        FirebaseAuth.instance.authStateChanges(),
      ),
      redirect: (context, state) {
        // Let it load first
        if (authState.isLoading) return null;

        final bool isLoggedIn = authState.value != null;
        final bool goingToAuth =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';

        if (!isLoggedIn && !goingToAuth) return '/login';
        if (isLoggedIn && goingToAuth) return '/vision';

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
