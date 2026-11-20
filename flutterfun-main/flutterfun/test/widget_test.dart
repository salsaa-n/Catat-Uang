import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfun/main.dart';
import 'package:flutterfun/demos/actions_demo.dart';
import 'package:flutterfun/demos/auth_forms_demo.dart';
import 'package:flutterfun/demos/containment_demo.dart';
import 'package:flutterfun/demos/selection_demo.dart';
import 'package:flutterfun/demos/text_inputs_demo.dart';
import 'package:flutterfun/demos/navigation_demo.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  testWidgets(
    'Pencarian komponen membuka kategori dan menangani hasil kosong',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextField), 'Slider');
      await tester.pump();
      expect(find.text('Selection'), findsOneWidget);
      expect(find.text('Actions'), findsNothing);
      await tester.tap(find.text('Selection'));
      await tester.pumpAndSettle();
      expect(find.text('Checkbox'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'tidakada');
      await tester.pump();
      expect(find.textContaining('Komponen tidak ditemukan'), findsOneWidget);
    },
  );

  testWidgets('Tombol memperbarui state dan favorit', (tester) async {
    await tester.pumpWidget(host(const ActionsDemo()));
    await tester.tap(find.text('Filled'));
    await tester.pump();
    expect(find.text('Jumlah aksi: 1'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Favorit'));
    await tester.tap(find.byTooltip('Favorit'));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('Dialog mengembalikan keputusan', (tester) async {
    await tester.pumpWidget(host(const ContainmentDemo()));
    await tester.tap(find.text('Buka dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kumpulkan'));
    await tester.pumpAndSettle();
    expect(find.text('Tugas dikumpulkan'), findsOneWidget);
  });

  testWidgets('Checkbox mengubah nilai', (tester) async {
    await tester.pumpWidget(host(const SelectionDemo()));
    await tester.tap(find.text('Saya sudah membaca modul'));
    await tester.pump();
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
      isTrue,
    );
  });

  testWidgets('Form menolak input kosong dan menerima data valid', (
    tester,
  ) async {
    await tester.pumpWidget(host(const TextInputsDemo()));
    await tester.ensureVisible(find.text('Simpan mahasiswa'));
    await tester.tap(find.text('Simpan mahasiswa'));
    await tester.pump();
    expect(find.text('Nama wajib diisi'), findsOneWidget);
    expect(find.text('NIM harus 8–12 digit angka'), findsOneWidget);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Siti');
    await tester.enterText(fields.at(1), '12345678');
    await tester.enterText(fields.at(2), 'latihan123');
    await tester.ensureVisible(find.text('Simpan mahasiswa'));
    await tester.tap(find.text('Simpan mahasiswa'));
    await tester.pump();
    expect(find.text('Tersimpan: Siti (12345678)'), findsOneWidget);
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(find.text('Tersimpan: Siti (12345678)'), findsNothing);
  });

  testWidgets('Form login dan registrasi memvalidasi data', (tester) async {
    await tester.pumpWidget(host(const AuthFormsDemo()));
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi'), findsOneWidget);

    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('Konfirmasi kata sandi'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Siti');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'siti@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');
    await tester.ensureVisible(find.text('Buat akun'));
    await tester.tap(find.text('Buat akun'));
    await tester.pump();
    expect(find.text('Persetujuan wajib dicentang'), findsOneWidget);

    await tester.tap(find.text('Saya menyetujui syarat dan ketentuan'));
    await tester.pump();
    await tester.tap(find.text('Buat akun'));
    await tester.pump();
    expect(
      find.text('Form pendaftaran valid. Sambungkan ke layanan autentikasi.'),
      findsOneWidget,
    );
  });

  testWidgets('Navigasi adaptif mengganti halaman', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: NavigationPlayground()));
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.tap(find.text('Kelas'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman Kelas'), findsOneWidget);
    tester.view.physicalSize = const Size(1100, 900);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  for (final width in [360.0, 1100.0]) {
    for (final topic in topics) {
      testWidgets('${topic.title} tanpa overflow pada lebar $width', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(MaterialApp(home: TopicPage(topic: topic)));
        // Hindari pumpAndSettle: indikator indeterminate terus beranimasi.
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
