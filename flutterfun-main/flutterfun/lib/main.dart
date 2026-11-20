import 'package:flutter/material.dart';
import 'catatuang_app.dart';

import 'demos/actions_demo.dart';
import 'demos/auth_forms_demo.dart';
import 'demos/communication_demo.dart';
import 'demos/containment_demo.dart';
import 'demos/navigation_demo.dart';
import 'demos/selection_demo.dart';
import 'demos/text_inputs_demo.dart';

void main() => runApp(const CatatUangApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool dark = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Laboratorium Material',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
    ),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    home: CatalogPage(
      dark: dark,
      onThemeChanged: () => setState(() => dark = !dark),
    ),
  );
}

/// Model memisahkan metadata pelajaran dari tampilan katalog.
class Topic {
  const Topic(
    this.title,
    this.subtitle,
    this.keywords,
    this.file,
    this.icon,
    this.demo,
  );
  final String title, subtitle, keywords, file;
  final IconData icon;
  final Widget demo;
}

const topics = [
  Topic(
    'Actions',
    'Tombol dan aksi pengguna',
    'Common buttons ElevatedButton FilledButton OutlinedButton TextButton FloatingActionButton extended IconButton SegmentedButton',
    'actions_demo.dart',
    Icons.touch_app_outlined,
    ActionsDemo(),
  ),
  Topic(
    'Communication',
    'Status, progres, dan umpan balik',
    'Badge LinearProgressIndicator CircularProgressIndicator SnackBar',
    'communication_demo.dart',
    Icons.notifications_outlined,
    CommunicationDemo(),
  ),
  Topic(
    'Containment',
    'Wadah konten dan konfirmasi',
    'AlertDialog Bottom sheet Card Divider ListTile',
    'containment_demo.dart',
    Icons.dashboard_outlined,
    ContainmentDemo(),
  ),
  Topic(
    'Navigation',
    'Perpindahan halaman dan tab',
    'AppBar BottomAppBar NavigationBar NavigationDrawer NavigationRail TabBar TabBarView',
    'navigation_demo.dart',
    Icons.explore_outlined,
    NavigationDemo(),
  ),
  Topic(
    'Selection',
    'Pilihan dan pengaturan',
    'Checkbox Chip DatePicker Menu Radio Slider Switch TimePicker',
    'selection_demo.dart',
    Icons.checklist,
    SelectionDemo(),
  ),
  Topic(
    'Text inputs',
    'Input dan validasi formulir',
    'TextField TextFormField Form',
    'text_inputs_demo.dart',
    Icons.edit_note,
    TextInputsDemo(),
  ),
  Topic(
    'Login & registration',
    'Contoh formulir masuk dan pendaftaran',
    'Login registration sign in sign up autentikasi email password',
    'auth_forms_demo.dart',
    Icons.lock_outline,
    AuthFormsDemo(),
  ),
];

class CatalogPage extends StatefulWidget {
  const CatalogPage({
    super.key,
    required this.dark,
    required this.onThemeChanged,
  });
  final bool dark;
  final VoidCallback onThemeChanged;
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final filtered = topics
        .where(
          (topic) => '${topic.title} ${topic.subtitle} ${topic.keywords}'
              .toLowerCase()
              .contains(query.toLowerCase().trim()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratorium Material'),
        actions: [
          IconButton(
            tooltip: 'Ganti tema',
            onPressed: widget.onThemeChanged,
            icon: Icon(widget.dark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Learn Flutter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text('Search and explore Flutter components.'),
                const SizedBox(height: 24),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Cari komponen',
                    hintText: 'Contoh: Slider, Card, TextField',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => query = value),
                ),
                const SizedBox(height: 20),
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Komponen tidak ditemukan. Coba kata kunci lain.',
                    ),
                  ),
                for (final topic in filtered)
                  Card.outlined(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(topic.icon),
                      title: Text(topic.title),
                      subtitle: Text(topic.subtitle),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => TopicPage(topic: topic),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopicPage extends StatelessWidget {
  const TopicPage({super.key, required this.topic});
  final Topic topic;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(topic.title)),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  topic.subtitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                SelectableText('Kode: lib/demos/${topic.file}'),
                const SizedBox(height: 20),
                topic.demo,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
