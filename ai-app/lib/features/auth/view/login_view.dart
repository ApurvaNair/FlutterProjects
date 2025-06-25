import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';
import 'signup_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            if (viewModel.error != null)
              Text(viewModel.error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () => ref
                        .read(authViewModelProvider.notifier)
                        .login(emailCtrl.text.trim(), passCtrl.text.trim()),
              child: viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpView()),
              ),
              child: const Text("Don’t have an account? Sign Up"),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(authViewModelProvider.notifier)
                    .resetPassword(emailCtrl.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password reset email sent.")),
                );
              },
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
