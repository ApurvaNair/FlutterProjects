import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'core/services/firebase_service.dart';
import 'core/services/local_storage_service.dart';

import 'features/auth/view_model/auth_view_model.dart';
import 'features/chat/view_model/chat_view_model.dart';
import 'features/journal/view_model/journal_view_model.dart';
import 'features/vision/view_model/vision_view_model.dart';

// Core services
final firebaseServiceProvider = Provider((ref) => FirebaseService());
final localStorageProvider = Provider((ref) => LocalStorageService());

// ViewModels
final authViewModelProvider = ChangeNotifierProvider(
  (ref) => AuthViewModel(ref.read(firebaseServiceProvider)),
);

final chatViewModelProvider = ChangeNotifierProvider((ref) => ChatViewModel());

final journalViewModelProvider = ChangeNotifierProvider(
  (ref) => JournalViewModel(),
);

final visionViewModelProvider = ChangeNotifierProvider(
  (ref) => VisionViewModel(),
);

// 🔁 NEW: Auth state stream used by GoRouter
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
