import 'package:flutter/material.dart';

import 'lesson.dart';

class SelectionDemo extends StatefulWidget {
  const SelectionDemo({super.key});
  @override
  State<SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<SelectionDemo> {
  bool agreed = false,
      notifications = true,
      filter = false,
      inputVisible = true;
  String level = 'Pemula', chip = 'Dart', menu = 'Belum dipilih';
  double score = 70;
  RangeValues range = const RangeValues(20, 80);
  DateTime? date;
  DateTimeRange? dates;
  TimeOfDay? time;
  String formatDate(DateTime value) =>
      '${value.day}/${value.month}/${value.year}';
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Lesson(
        title: 'Checkbox',
        description: 'Pilihan independen dengan nilai boolean.',
        child: CheckboxListTile(
          title: const Text('Saya sudah membaca modul'),
          value: agreed,
          onChanged: (value) => setState(() => agreed = value ?? false),
        ),
      ),
      Lesson(
        title: 'Chip',
        description: 'Chip informasi; ActionChip aksi; ChoiceChip tunggal; FilterChip filter; InputChip dapat dihapus.',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const Chip(
              avatar: Icon(Icons.school, size: 18),
              label: Text('Mobile'),
            ),
            ActionChip(
              label: const Text('Lihat info'),
              onPressed: () =>
                  notify(context, 'Praktikum berlangsung 100 menit'),
            ),
            for (final name in ['Dart', 'Flutter'])
              ChoiceChip(
                label: Text(name),
                selected: chip == name,
                onSelected: (_) => setState(() => chip = name),
              ),
            FilterChip(
              label: const Text('Sudah selesai'),
              selected: filter,
              onSelected: (value) => setState(() => filter = value),
            ),
            if (inputVisible)
              InputChip(
                label: const Text('Kelompok A'),
                onDeleted: () => setState(() => inputVisible = false),
              )
            else
              ActionChip(
                label: const Text('Pulihkan kelompok'),
                onPressed: () => setState(() => inputVisible = true),
              ),
          ],
        ),
      ),
      Lesson(
        title: 'DatePicker',
        description: 'showDatePicker memilih tanggal; showDateRangePicker memilih rentang. Batal mempertahankan pilihan sebelumnya.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date == null
                  ? 'Tanggal belum dipilih'
                  : 'Tanggal: ${formatDate(date!)}',
            ),
            Text(
              dates == null
                  ? 'Rentang belum dipilih'
                  : 'Rentang: ${formatDate(dates!.start)} – ${formatDate(dates!.end)}',
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final value = await showDatePicker(
                      context: context,
                      initialDate: date ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (!mounted || value == null) return;
                    setState(() => date = value);
                  },
                  child: const Text('Pilih tanggal'),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final value = await showDateRangePicker(
                      context: context,
                      initialDateRange: dates,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (!mounted || value == null) return;
                    setState(() => dates = value);
                  },
                  child: const Text('Pilih rentang'),
                ),
              ],
            ),
          ],
        ),
      ),
      Lesson(
        title: 'Menu',
        description: 'MenuAnchor dan MenuItemButton menyediakan menu Material; DropdownMenu untuk pilihan dalam form.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Menu: $menu'),
            MenuAnchor(
              builder: (context, controller, child) => OutlinedButton(
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                child: const Text('Buka menu'),
              ),
              menuChildren: [
                for (final item in ['Salin', 'Bagikan', 'Unduh'])
                  MenuItemButton(
                    onPressed: () => setState(() => menu = item),
                    child: Text(item),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              label: const Text('Kelas'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'A', label: 'Kelas A'),
                DropdownMenuEntry(value: 'B', label: 'Kelas B'),
              ],
              onSelected: (value) => setState(() => menu = 'Kelas $value'),
            ),
            PopupMenuButton<String>(
              tooltip: 'Menu alternatif',
              onSelected: (value) => setState(() => menu = value),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'Edit', child: Text('Edit')),
                PopupMenuItem(value: 'Simpan', child: Text('Simpan')),
              ],
            ),
          ],
        ),
      ),
      Lesson(
        title: 'Radio',
        description: 'RadioGroup mengelola satu pilihan untuk semua RadioListTile di dalamnya.',
        child: RadioGroup<String>(
          groupValue: level,
          onChanged: (value) => setState(() => level = value!),
          child: Column(
            children: [
              for (final item in ['Pemula', 'Menengah', 'Lanjut'])
                RadioListTile<String>(value: item, title: Text(item)),
            ],
          ),
        ),
      ),
      Lesson(
        title: 'Slider & RangeSlider',
        description: 'Nilai tunggal dan rentang; divisions membatasi langkah.',
        child: Column(
          children: [
            Text('Nilai: ${score.round()}'),
            Slider(
              value: score,
              min: 0,
              max: 100,
              divisions: 10,
              label: '${score.round()}',
              onChanged: (value) => setState(() => score = value),
            ),
            Text('Rentang: ${range.start.round()}–${range.end.round()}'),
            RangeSlider(
              values: range,
              min: 0,
              max: 100,
              divisions: 10,
              labels: RangeLabels(
                '${range.start.round()}',
                '${range.end.round()}',
              ),
              onChanged: (value) => setState(() => range = value),
            ),
          ],
        ),
      ),
      Lesson(
        title: 'Switch',
        description: 'Mengaktifkan atau menonaktifkan pengaturan.',
        child: SwitchListTile(
          title: const Text('Notifikasi kelas'),
          subtitle: Text(notifications ? 'Aktif' : 'Nonaktif'),
          value: notifications,
          onChanged: (value) => setState(() => notifications = value),
        ),
      ),
      Lesson(
        title: 'TimePicker',
        description:
            'showTimePicker mengembalikan TimeOfDay atau null saat dibatalkan.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time == null
                  ? 'Jam belum dipilih'
                  : 'Jam: ${time!.format(context)}',
            ),
            OutlinedButton(
              onPressed: () async {
                final value = await showTimePicker(
                  context: context,
                  initialTime: time ?? TimeOfDay.now(),
                );
                if (!mounted || value == null) return;
                setState(() => time = value);
              },
              child: const Text('Pilih jam'),
            ),
          ],
        ),
      ),
    ],
  );
}
