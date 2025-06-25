import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../../../providers.dart';

class RecordVisionView extends ConsumerWidget {
  const RecordVisionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(visionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Record Your Vision")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AudioWaveforms(
              size: const Size(double.infinity, 100),
              recorderController: vm.recorderController,
              waveStyle: const WaveStyle(
                waveColor: Colors.blue,
                showMiddleLine: false,
                extendWaveform: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(vm.isRecording ? Icons.stop : Icons.mic),
              label: Text(
                vm.isRecording ? "Stop Recording" : "Start Recording",
              ),
              onPressed: vm.isRecording ? vm.stopRecording : vm.startRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: vm.isRecording ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            if (vm.transcript.isNotEmpty) ...[
              const Text("🗣️ Transcribed Text:"),
              Text(vm.transcript),
              const SizedBox(height: 20),
            ],
            if (vm.aiResponse != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(vm.aiResponse!),
              ),
          ],
        ),
      ),
    );
  }
}
