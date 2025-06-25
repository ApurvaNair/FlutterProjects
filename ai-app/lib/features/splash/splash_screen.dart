import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/local_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final isFirst = await LocalStorageService().isFirstLaunch();
    if (isFirst) {
      await LocalStorageService().setFirstLaunchDone();
    }

    // Safely navigate only if widget is still mounted
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('🌱 Gaia AI', style: TextStyle(fontSize: 28))),
    );
  }
}
