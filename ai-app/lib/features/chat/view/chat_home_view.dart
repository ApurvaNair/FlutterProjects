import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';

class ChatHomeView extends ConsumerWidget {
  const ChatHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(chatViewModelProvider);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.messages.length,
              itemBuilder: (_, i) {
                final msg = viewModel.messages[i];
                return ListTile(
                  title: Text(msg.message),
                  subtitle: Text(msg.sender),
                  trailing: Text(
                    "${msg.timestamp.hour}:${msg.timestamp.minute}",
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: controller)),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  ref
                      .read(chatViewModelProvider.notifier)
                      .send(controller.text);
                  controller.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
