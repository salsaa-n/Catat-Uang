import 'package:flutter/material.dart';

import 'lesson.dart';

class TextInputsDemo extends StatefulWidget {
  const TextInputsDemo({super.key});
  @override
  State<TextInputsDemo> createState() => _TextInputsDemoState();
}

class _TextInputsDemoState extends State<TextInputsDemo> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nimController = TextEditingController();
  String preview = '';
  String result = '';
  bool obscure = true;
  // Controller dimiliki State: lepaskan saat widget dibuang.
  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Lesson(
        title: 'TextField',
        description: 'onChanged memperbarui tampilan setiap pengguna mengetik.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Catatan',
                hintText: 'Tulis materi hari ini',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
              onChanged: (value) => setState(() => preview = value),
            ),
            const SizedBox(height: 8),
            Text('Pratinjau: $preview'),
          ],
        ),
      ),
      Lesson(
        title: 'Form & TextFormField',
        description: 'validator memeriksa input; controller membaca nilai. Data hanya disimpan di memori.',
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama mahasiswa',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM (8–12 digit)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    RegExp(r'^\d{8,12}$').hasMatch(value ?? '')
                    ? null
                    : 'NIM harus 8–12 digit angka',
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Kata sandi latihan',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: obscure
                        ? 'Tampilkan kata sandi'
                        : 'Sembunyikan kata sandi',
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) =>
                    (value ?? '').length >= 6 ? null : 'Minimal 6 karakter',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(
                          () => result =
                              'Tersimpan: ${nameController.text.trim()} (${nimController.text})',
                        );
                      }
                    },
                    child: const Text('Simpan mahasiswa'),
                  ),
                  TextButton(
                    onPressed: () {
                      formKey.currentState!.reset();
                      nameController.clear();
                      nimController.clear();
                      setState(() {
                        result = '';
                        obscure = true;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              Text(result, key: const ValueKey('form-result')),
            ],
          ),
        ),
      ),
    ],
  );
}
