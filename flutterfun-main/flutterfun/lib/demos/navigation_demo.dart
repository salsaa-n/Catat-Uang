import 'package:flutter/material.dart';

import 'lesson.dart';

class NavigationDemo extends StatelessWidget {
  const NavigationDemo({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Lesson(
        title: 'AppBar, BottomAppBar, NavigationBar, NavigationDrawer, NavigationRail',
        description: 'Buka layar contoh untuk mencoba perubahan destinasi. Rail muncul pada lebar ≥700 px; NavigationBar pada layar kecil.',
        child: FilledButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const NavigationPlayground(),
            ),
          ),
          icon: const Icon(Icons.open_in_new),
          label: const Text('Buka demo navigasi'),
        ),
      ),
      const Lesson(
        title: 'TabBar & TabBarView',
        description: 'DefaultTabController menyinkronkan tab dan isi. Jumlah tab harus sama dengan jumlah halaman.',
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Materi'),
                  Tab(text: 'Tugas'),
                  Tab(text: 'Nilai'),
                ],
              ),
              SizedBox(
                height: 150,
                child: TabBarView(
                  children: [
                    Center(child: Text('Materi: komponen Material')),
                    Center(child: Text('Tugas: buat katalog sendiri')),
                    Center(child: Text('Nilai praktikum: 90')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class NavigationPlayground extends StatefulWidget {
  const NavigationPlayground({super.key});
  @override
  State<NavigationPlayground> createState() => _NavigationPlaygroundState();
}

class _NavigationPlaygroundState extends State<NavigationPlayground> {
  int selected = 0;
  static const labels = ['Beranda', 'Kelas', 'Profil'];
  static const icons = [
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.person_outline,
  ];
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo navigasi'),
        actions: [
          IconButton(
            tooltip: 'Kembali ke katalog',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: selected,
        onDestinationSelected: (index) {
          setState(() => selected = index);
          Navigator.pop(context);
        },
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Kampus • NavigationDrawer'),
          ),
          for (var i = 0; i < labels.length; i++)
            NavigationDrawerDestination(
              icon: Icon(icons[i]),
              label: Text(labels[i]),
            ),
        ],
      ),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              selectedIndex: selected,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (index) =>
                  setState(() => selected = index),
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  NavigationRailDestination(
                    icon: Icon(icons[i]),
                    label: Text(labels[i]),
                  ),
              ],
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icons[selected], size: 64),
                  Text(
                    'Halaman ${labels[selected]}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(wide ? 'NavigationRail aktif' : 'NavigationBar aktif'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!wide)
            NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (index) =>
                  setState(() => selected = index),
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  NavigationDestination(icon: Icon(icons[i]), label: labels[i]),
              ],
            ),
          BottomAppBar(
            child: Row(
              children: [
                const Expanded(child: Text('BottomAppBar • aksi halaman')),
                IconButton(
                  tooltip: 'Tambah kelas',
                  onPressed: () =>
                      notify(context, 'Kelas baru ditambahkan (simulasi)'),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
