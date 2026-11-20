import 'package:flutter/material.dart';

import 'lesson.dart';

class CommunicationDemo extends StatefulWidget {
  const CommunicationDemo({super.key});
  @override
  State<CommunicationDemo> createState() => _CommunicationDemoState();
}

class _CommunicationDemoState extends State<CommunicationDemo> {
  int messages = 3;
  double progress = .4;
  bool archived = false;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Lesson(
        title: 'Badge',
        description: 'Klik ikon untuk menambah jumlah pesan.',
        child: Badge.count(
          count: messages,
          child: IconButton(
            tooltip: 'Tambah pesan',
            onPressed: () => setState(() => messages++),
            icon: const Icon(Icons.mail_outline),
          ),
        ),
      ),
      Lesson(
        title: 'Progress indicators',
        description: 'value 0–1 untuk progres terukur. Tanpa value berarti durasi belum diketahui.',
        child: Column(
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 16),
            CircularProgressIndicator(
              value: progress,
              semanticsLabel: 'Progres materi',
            ),
            Slider(
              value: progress,
              label: '${(progress * 100).round()}%',
              onChanged: (value) => setState(() => progress = value),
            ),
            Text('Selesai ${(progress * 100).round()}%'),
            const SizedBox(height: 12),
            const LinearProgressIndicator(
              semanticsLabel: 'Contoh proses tanpa durasi',
            ),
          ],
        ),
      ),
      Lesson(
        title: 'SnackBar',
        description:
            'ScaffoldMessenger menampilkan umpan balik dan aksi pembatalan.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(archived ? 'Catatan diarsipkan' : 'Catatan aktif'),
            FilledButton(
              onPressed: () {
                setState(() => archived = true);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: const Text('Catatan diarsipkan'),
                      action: SnackBarAction(
                        label: 'Urungkan',
                        onPressed: () {
                          if (mounted) setState(() => archived = false);
                        },
                      ),
                    ),
                  );
              },
              child: const Text('Arsipkan catatan'),
            ),
          ],
        ),
      ),
    ],
  );
}
