import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
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
      appBar: AppBar(title: const Text("Sign Up")),
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
                  : () async {
                      await ref
                          .read(authViewModelProvider.notifier)
                          .signUp(emailCtrl.text.trim(), passCtrl.text.trim());
                      if (context.mounted) Navigator.pop(context); // Go back
                    },
              child: viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
