import 'package:flutter/material.dart';

import 'lesson.dart';

class ContainmentDemo extends StatefulWidget {
  const ContainmentDemo({super.key});
  @override
  State<ContainmentDemo> createState() => _ContainmentDemoState();
}

class _ContainmentDemoState extends State<ContainmentDemo> {
  String decision = 'Belum ada keputusan';
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Lesson(
        title: 'AlertDialog',
        description: 'await membaca hasil Navigator.pop. Periksa mounted setelah operasi async.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(decision),
            FilledButton(
              onPressed: () async {
                final accepted = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Kumpulkan tugas?'),
                    content: const Text('Pastikan nama dan NIM sudah benar.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Batal'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Kumpulkan'),
                      ),
                    ],
                  ),
                );
                if (!mounted) return;
                setState(
                  () => decision = accepted == true
                      ? 'Tugas dikumpulkan'
                      : 'Pengumpulan dibatalkan',
                );
              },
              child: const Text('Buka dialog'),
            ),
          ],
        ),
      ),
      Lesson(
        title: 'Bottom sheet',
        description: 'Modal menghalangi halaman belakang; persistent menjadi bagian Scaffold.',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonal(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (sheetContext) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Materi praktikum minggu ini'),
                        const ListTile(
                          leading: Icon(Icons.code),
                          title: Text('Membuat komponen reusable'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              child: const Text('Modal sheet'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PersistentSheetPage(),
                ),
              ),
              child: const Text('Persistent sheet'),
            ),
          ],
        ),
      ),
      const Lesson(
        title: 'Card',
        description: 'Kelompokkan informasi dengan elevated, filled, atau outlined card.',
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Elevated card'),
                subtitle: Text('Praktikum Flutter'),
              ),
            ),
            Card.filled(
              child: ListTile(
                title: Text('Filled card'),
                subtitle: Text('Materi pertemuan'),
              ),
            ),
            Card.outlined(
              child: ListTile(
                title: Text('Outlined card'),
                subtitle: Text('Latihan mandiri'),
              ),
            ),
          ],
        ),
      ),
      Lesson(
        title: 'Divider & ListTile',
        description: 'leading, title, subtitle, trailing, dan onTap membentuk baris informasi.',
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.school)),
              title: const Text('Pemrograman Mobile'),
              subtitle: const Text('3 SKS • semester 4'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => notify(context, 'Mata kuliah dipilih'),
            ),
            const Divider(),
            const SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(child: Text('Teori')),
                  VerticalDivider(),
                  Expanded(child: Text('Praktik')),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class PersistentSheetPage extends StatelessWidget {
  const PersistentSheetPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Persistent bottom sheet')),
    body: const Center(child: Text('Konten utama tetap terlihat')),
    bottomSheet: const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Panel materi selalu tampil di bawah. Kembali untuk menutup halaman.',
        ),
      ),
    ),
  );
}
