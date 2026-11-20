import 'package:flutter/material.dart';

import 'demos/verifikasi_screen.dart';

void main() {
  runApp(const CatatUangApp());
}

class CatatUangApp extends StatelessWidget {
  const CatatUangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatatUang',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF43A6DD)),
      ),
      home: const VerifikasiScreen(),
    );
  }
}
