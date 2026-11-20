import 'package:flutter/material.dart';

import 'lesson.dart';

class ActionsDemo extends StatefulWidget {
  const ActionsDemo({super.key});
  @override
  State<ActionsDemo> createState() => _ActionsDemoState();
}

class _ActionsDemoState extends State<ActionsDemo> {
  int count = 0;
  bool favorite = false;
  Set<String> view = {'Daftar'};
  Set<String> subjects = {'Flutter'};
  void increment() => setState(() => count++);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Lesson(
        title: 'Common buttons',
        description:
            'Callback onPressed mengubah state. null menonaktifkan tombol.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah aksi: $count'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: increment,
                  child: const Text('Elevated'),
                ),
                FilledButton(onPressed: increment, child: const Text('Filled')),
                FilledButton.tonal(
                  onPressed: increment,
                  child: const Text('Tonal'),
                ),
                OutlinedButton(
                  onPressed: increment,
                  child: const Text('Outlined'),
                ),
                TextButton(onPressed: increment, child: const Text('Text')),
                const FilledButton(onPressed: null, child: Text('Nonaktif')),
              ],
            ),
          ],
        ),
      ),
      Lesson(
        title: 'FloatingActionButton & extended',
        description: 'Aksi utama halaman; setiap FAB memiliki heroTag unik.',
        child: Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            FloatingActionButton(
              heroTag: 'regular',
              onPressed: increment,
              tooltip: 'Tambah aksi',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton.extended(
              heroTag: 'extended',
              onPressed: increment,
              icon: const Icon(Icons.edit),
              label: const Text('Tambah catatan'),
            ),
          ],
        ),
      ),
      Lesson(
        title: 'IconButton',
        description:
            'isSelected menampilkan pilihan; tooltip memberi label aksesibel.',
        child: IconButton(
          isSelected: favorite,
          tooltip: 'Favorit',
          onPressed: () => setState(() => favorite = !favorite),
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite),
        ),
      ),
      Lesson(
        title: 'SegmentedButton',
        description: 'Set menyimpan pilihan tunggal atau jamak.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Daftar', label: Text('Daftar')),
                ButtonSegment(value: 'Grid', label: Text('Grid')),
              ],
              selected: view,
              onSelectionChanged: (value) => setState(() => view = value),
            ),
            Text('Tampilan: ${view.first}'),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              multiSelectionEnabled: true,
              emptySelectionAllowed: true,
              segments: const [
                ButtonSegment(value: 'Flutter', label: Text('Flutter')),
                ButtonSegment(value: 'Dart', label: Text('Dart')),
              ],
              selected: subjects,
              onSelectionChanged: (value) => setState(() => subjects = value),
            ),
            Text('Materi: ${subjects.join(', ')}'),
          ],
        ),
      ),
    ],
  );
}
