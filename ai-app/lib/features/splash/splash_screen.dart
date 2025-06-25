import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/local_storage_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      final isFirst = await LocalStorageService().isFirstLaunch();
      if (isFirst) await LocalStorageService().setFirstLaunchDone();
      context.go('/login');
    });

    return const Scaffold(
      body: Center(child: Text('🌱 Gaia AI', style: TextStyle(fontSize: 28))),
    );
  }
}
