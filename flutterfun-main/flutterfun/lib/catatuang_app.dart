import 'package:flutter/material.dart';

import 'auth_screens.dart';

const _blue = Color(0xFF43A6DD);
const _paleBlue = Color(0xFFBADEFC);
const _softBlue = Color(0xFFD4E7F7);
const _green = Color(0xFF078A28);
const _red = Color(0xFFF44355);

class CatatUangApp extends StatelessWidget {
  const CatatUangApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CatatUang',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: _blue),
      fontFamily: 'Roboto',
    ),
    builder: (context, child) => ColoredBox(
      color: const Color(0xFFEFEFEF),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: child!,
        ),
      ),
    ),
    home: const SplashScreen(),
  );
}

class CatatUangHome extends StatefulWidget {
  const CatatUangHome({super.key});
  @override
  State<CatatUangHome> createState() => _CatatUangHomeState();
}

class _CatatUangHomeState extends State<CatatUangHome> {
  int _tab = 0;
  String _transactionQuery = '';
  int _transactionMonth = 11;
  final List<_Transaction> _items = [
    _Transaction(
      'Gaji Bulanan',
      'Pendapatan',
      5000000,
      '01 Nov',
      Icons.receipt_long,
    ),
    _Transaction(
      'Belanja',
      'Kebutuhan',
      -350000,
      '02 Nov',
      Icons.shopping_cart,
    ),
    _Transaction(
      'Tagihan Listrik',
      'Utilitas',
      -210000,
      '03 Nov',
      Icons.electric_bolt,
    ),
    _Transaction(
      'Freelance',
      'Pendapatan',
      1500000,
      '04 Nov',
      Icons.receipt_long,
    ),
  ];

  Future<void> _addTransaction({required bool income}) async {
    final result = await Navigator.push<_Transaction>(
      context,
      MaterialPageRoute(builder: (_) => _TransactionPage(income: income)),
    );
    if (result != null) setState(() => _items.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard,
      _transactions,
      const _ReportPage(),
      const _ProfilePage(),
    ];
    return Scaffold(
      body: SafeArea(child: pages[_tab]),
      bottomNavigationBar: NavigationBar(
        height: _tab == 1 ? 121 : 101,
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            color: states.contains(WidgetState.selected)
                ? Colors.black
                : const Color(0xFF555555),
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.normal,
          ),
        ),
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Color(0xFF555555)),
            selectedIcon: Icon(Icons.home, color: Colors.black),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, color: Color(0xFF555555)),
            selectedIcon: Icon(Icons.receipt_long, color: Colors.black),
            label: 'Transaksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.donut_large_outlined, color: Color(0xFF555555)),
            selectedIcon: Icon(Icons.donut_large, color: Colors.black),
            label: 'Laporan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Color(0xFF555555)),
            selectedIcon: Icon(Icons.person, color: Colors.black),
            label: 'Profil',
          ),
        ],
      ),
      floatingActionButton: _tab == 1
          ? FloatingActionButton(
              backgroundColor: _paleBlue,
              foregroundColor: Colors.black,
              onPressed: () => _addTransaction(income: false),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget get _dashboard => ListView(
    padding: const EdgeInsets.only(bottom: 20),
    children: [
      const SizedBox(height: 67),
      Container(
        color: _paleBlue,
        height: 253,
        padding: const EdgeInsets.fromLTRB(17, 39, 17, 38),
        child: Container(
          height: 176,
          padding: const EdgeInsets.fromLTRB(23, 23, 23, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saldo Saat Ini', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 3),
              const Text(
                'Rp 4.250.000',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Expanded(
                    child: _Balance(
                      label: 'Pemasukan',
                      amount: 'Rp 6.500.000',
                      color: _green,
                      icon: Icons.trending_up,
                    ),
                  ),
                  Container(height: 38, width: 1, color: Colors.grey),
                  const Expanded(
                    child: _Balance(
                      label: 'Pengeluaran',
                      amount: 'Rp 2.250.000',
                      color: _red,
                      icon: Icons.trending_down,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 17, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aksi Cepat',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 17),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickAction(
                  icon: Icons.north_east,
                  label: 'Pemasukan',
                  color: const Color(0xFFD4EFEC),
                  onTap: () => _addTransaction(income: true),
                ),
                _QuickAction(
                  icon: Icons.south_east,
                  label: 'Pengeluaran',
                  color: const Color(0xFFF7D9DF),
                  onTap: () => _addTransaction(income: false),
                ),
                _QuickAction(
                  icon: Icons.donut_large,
                  label: 'Laporan',
                  color: _softBlue,
                  onTap: () => setState(() => _tab = 2),
                ),
                _QuickAction(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Anggaran',
                  color: const Color(0xFFE4DBFB),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _BudgetPage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.fromLTRB(29, 21, 24, 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terakhir',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => setState(() => _tab = 1),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      ..._items.take(4).map((e) => _TransactionTile(item: e)),
      const SizedBox(height: 8),
    ],
  );

  Widget get _transactions {
    final visible = _items.where((item) {
      final matchesText = '${item.title} ${item.category}'
          .toLowerCase()
          .contains(_transactionQuery.toLowerCase());
      final monthLabel = const {
        11: 'Nov',
        10: 'Okt',
        9: 'Sep',
      }[_transactionMonth];
      final matchesMonth = monthLabel == null || item.date.contains(monthLabel);
      return matchesText && matchesMonth;
    }).toList();
    final groups = <String, List<_Transaction>>{};
    for (final item in visible) {
      groups.putIfAbsent(item.date, () => []).add(item);
    }
    return Column(
      children: [
        Container(
          height: 216,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          decoration: const BoxDecoration(color: _paleBlue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 3),
              const Text(
                'Riwayat Transaksi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 44,
                child: TextField(
                  onChanged: (value) =>
                      setState(() => _transactionQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari transaksi...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color(0xFF171717),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color(0xFF171717),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _MonthChip(
                    label: 'Nov 2026',
                    active: _transactionMonth == 11,
                    onTap: () => setState(() => _transactionMonth = 11),
                  ),
                  const SizedBox(width: 6),
                  _MonthChip(
                    label: 'Okt 2026',
                    active: _transactionMonth == 10,
                    onTap: () => setState(() => _transactionMonth = 10),
                  ),
                  const SizedBox(width: 6),
                  _MonthChip(
                    label: 'Sep 2026',
                    active: _transactionMonth == 9,
                    onTap: () => setState(() => _transactionMonth = 9),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
            children: [
              for (final group in groups.entries)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${group.key} 2026',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      for (final item in group.value)
                        _TransactionTile(item: item),
                    ],
                  ),
                ),
              if (visible.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Center(child: Text('Tidak ada transaksi')),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Balance extends StatelessWidget {
  const _Balance({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });
  final String label, amount;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 57,
          height: 60,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, size: 22, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}

class _Transaction {
  const _Transaction(
    this.title,
    this.category,
    this.amount,
    this.date,
    this.icon,
  );
  final String title, category, date;
  final int amount;
  final IconData icon;
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item});
  final _Transaction item;
  @override
  Widget build(BuildContext context) {
    final income = item.amount > 0;
    final value = item.amount.abs().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: income ? const Color(0xFFD4EFEC) : const Color(0xFFF7D9DE),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 19, color: Colors.black),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.category,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${income ? '+' : '-'}Rp $value',
                style: TextStyle(
                  color: income
                      ? const Color(0xFF16833A)
                      : const Color(0xFFFF0004),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                item.date,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      height: 27,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? _blue : Colors.white,
        border: Border.all(color: active ? _blue : const Color(0xFFBAC6CE)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: active ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}

class _TopTitle extends StatelessWidget {
  const _TopTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 62,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Positioned(
          left: 8,
          child: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.chevron_left),
          ),
        ),
      ],
    ),
  );
}

class _TransactionPage extends StatefulWidget {
  const _TransactionPage({required this.income});
  final bool income;
  @override
  State<_TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<_TransactionPage> {
  final _name = TextEditingController();
  final _amount = TextEditingController();
  late bool _income = widget.income;
  String _category = 'Pilih kategori';
  DateTime _date = DateTime.now();
  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 70,
            color: _paleBlue,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Tambah Transaksi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Positioned(
                  left: 20,
                  child: InkWell(
                    onTap: () => Navigator.maybePop(context),
                    customBorder: const CircleBorder(),
                    child: const CircleAvatar(
                      radius: 19,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CategoryTab(
                      label: 'Pemasukan',
                      active: _income,
                      onTap: () => setState(() => _income = true),
                    ),
                    _CategoryTab(
                      label: 'Pengeluaran',
                      active: !_income,
                      onTap: () => setState(() => _income = false),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'NOMINAL',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 59,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: _blue, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Text('Rp'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amount,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '500.000',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'KATEGORI',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    final v = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _CategoryPage(isIncome: _income),
                      ),
                    );
                    if (v != null) setState(() => _category = v);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: _blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_category),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'TANGGAL',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                      initialDate: _date,
                    );
                    if (date != null) setState(() => _date = date);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: _blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}',
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'DESKRIPSI',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 84,
                  child: TextField(
                    controller: _name,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan catatan...',
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: _blue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: _blue, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'FOTO STRUK',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 76,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Foto'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFF2F5F7),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 88),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: _blue,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Simpan Transaksi',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  void _save() {
    final n =
        int.tryParse(_amount.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;
    if (_name.text.trim().isEmpty || n <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi nama dan jumlah transaksi terlebih dahulu'),
        ),
      );
      return;
    }
    Navigator.pop(
      context,
      _Transaction(
        _name.text.trim(),
        _category == 'Pilih kategori' ? 'Lainnya' : _category,
        _income ? n : -n,
        '${_date.day.toString().padLeft(2, '0')} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][_date.month - 1]}',
        Icons.receipt_long,
      ),
    );
  }
}

class _CategoryEntry {
  const _CategoryEntry(this.name, this.icon, this.color);
  final String name;
  final IconData icon;
  final Color color;
}

class _NewCategory {
  const _NewCategory(this.entry, this.isIncome);
  final _CategoryEntry entry;
  final bool isIncome;
}

class _CategoryPage extends StatefulWidget {
  const _CategoryPage({this.isIncome = false});

  final bool isIncome;

  @override
  State<_CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<_CategoryPage> {
  late bool _isIncome = widget.isIncome;
  final _incomeCategories = <_CategoryEntry>[
    const _CategoryEntry(
      'Freelance',
      Icons.account_balance_wallet_outlined,
      Color(0xFFD4EFEC),
    ),
    const _CategoryEntry(
      'Gaji',
      Icons.account_balance_wallet_outlined,
      Color(0xFFD4EFEC),
    ),
    const _CategoryEntry('Bonus', Icons.attach_money, Color(0xFF93F48F)),
    const _CategoryEntry('Investasi', Icons.trending_up, Color(0xFFF2D7F6)),
  ];
  final _expenseCategories = <_CategoryEntry>[
    const _CategoryEntry(
      'Makanan & Minuman',
      Icons.restaurant,
      Color(0xFFD4EFEC),
    ),
    const _CategoryEntry(
      'Transportasi',
      Icons.directions_bus,
      Color(0xFFD4E7F7),
    ),
    const _CategoryEntry('Belanja', Icons.shopping_cart, Color(0xFFF7D9DF)),
    const _CategoryEntry(
      'Tagihan Listrik',
      Icons.electric_bolt,
      Color(0xFFF7D9DF),
    ),
    const _CategoryEntry(
      'Kesehatan',
      Icons.medical_services,
      Color(0xFF43A6DD),
    ),
  ];

  List<_CategoryEntry> get _categories =>
      _isIncome ? _incomeCategories : _expenseCategories;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 42),
            Container(
              height: 67,
              color: _paleBlue,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Pilih kategori',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Positioned(
                    left: 12,
                    child: CircleAvatar(
                      radius: 19,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 26,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 38),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CategoryTab(
                  label: 'Pemasukan',
                  active: _isIncome,
                  onTap: () => setState(() => _isIncome = true),
                ),
                _CategoryTab(
                  label: 'Pengeluaran',
                  active: !_isIncome,
                  onTap: () => setState(() => _isIncome = false),
                ),
              ],
            ),
            const SizedBox(height: 63),
            for (final category in _categories)
              SizedBox(
                height: 74,
                child: InkWell(
                  onTap: () => Navigator.pop(context, category.name),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: category.color,
                          child: Icon(
                            category.icon,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          category.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(43, 0, 43, 30),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Kategori'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _paleBlue,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(313, 50),
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _add() async {
    final result = await Navigator.push<_NewCategory>(
      context,
      MaterialPageRoute(builder: (_) => _AddCategoryPage(isIncome: _isIncome)),
    );
    if (result == null) return;
    setState(() {
      (result.isIncome ? _incomeCategories : _expenseCategories).add(
        result.entry,
      );
      _isIncome = result.isIncome;
    });
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: active ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 96,
            color: active ? _blue : Colors.transparent,
          ),
        ],
      ),
    ),
  );
}

class _AddCategoryPage extends StatefulWidget {
  const _AddCategoryPage({required this.isIncome});
  final bool isIncome;
  @override
  State<_AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<_AddCategoryPage> {
  final _nameController = TextEditingController();
  late bool _isIncome = widget.isIncome;
  final _colors = const [
    Color(0xFFD4EFEC),
    Color(0xFFFE5B70),
    Color(0xFF8F6464),
    Color(0xFFFF913D),
    Color(0xFFFFDEC5),
    Color(0xFFFFE990),
    Color(0xFFDFBA43),
    Color(0xFF43A6DD),
    Color(0xFFDCAEF9),
    Color(0xFFE72226),
    Color(0xFFF7DADE),
  ];
  final _icons = const [
    Icons.receipt_long,
    Icons.directions_bus,
    Icons.trending_up,
    Icons.account_balance_wallet_outlined,
    Icons.restaurant,
  ];
  int _selectedColor = 7;
  int _selectedIcon = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 88,
            color: _paleBlue,
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batalkan',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Tambahkan Kategori',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _save,
                  icon: const Icon(Icons.check, color: Colors.black, size: 27),
                ),
              ],
            ),
          ),
          const SizedBox(height: 72),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CategoryTab(
                label: 'Pemasukan',
                active: _isIncome,
                onTap: () => setState(() => _isIncome = true),
              ),
              const SizedBox(width: 24),
              _CategoryTab(
                label: 'Pengeluaran',
                active: !_isIncome,
                onTap: () => setState(() => _isIncome = false),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _colors[_selectedColor],
                  foregroundColor: Colors.black,
                  radius: 20,
                  child: Icon(_icons[_selectedIcon], size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Silakan masukkan nama kategori',
                      filled: true,
                      fillColor: _softBlue,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 51, 20, 4),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _colors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 18,
                crossAxisSpacing: 20,
                mainAxisExtent: 40,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () => setState(() => _selectedColor = index),
                customBorder: const CircleBorder(),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _colors[index],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: _selectedColor == index ? .65 : .18,
                          ),
                          blurRadius: 0,
                          spreadRadius: _selectedColor == index ? 1 : .5,
                        ),
                      ],
                    ),
                    child: _selectedColor == index
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 112),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _icons.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () => setState(() => _selectedIcon = index),
                  customBorder: const CircleBorder(),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: _selectedIcon == index
                        ? _softBlue
                        : const Color(0xFFD9D9D9),
                    child: Icon(_icons[index], size: 17, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(
      context,
      _NewCategory(
        _CategoryEntry(name, _icons[_selectedIcon], _colors[_selectedColor]),
        _isIncome,
      ),
    );
  }
}

class _BudgetPage extends StatefulWidget {
  const _BudgetPage();

  @override
  State<_BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<_BudgetPage> {
  int _month = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 88,
            child: Stack(
              children: [
                Positioned(
                  top: 38,
                  left: 10,
                  child: InkWell(
                    onTap: () => Navigator.maybePop(context),
                    customBorder: const CircleBorder(),
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: _paleBlue,
                      child: Icon(Icons.chevron_left, color: _blue),
                    ),
                  ),
                ),
                const Positioned(
                  top: 52,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Anggaran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(19, 31, 19, 26),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _softBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var index = 0; index < 3; index++)
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _month = index),
                            child: Container(
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _month == index
                                    ? _blue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                ['Oktober', 'November', 'Desember'][index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _month == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(19, 0, 19, 28),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  decoration: BoxDecoration(
                    color: _paleBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Anggaran',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Rp. 3.000.000',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(
                        value: .6,
                        minHeight: 9,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: _blue,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp. 1.800.000 tersisa',
                            style: TextStyle(color: _blue, fontSize: 11),
                          ),
                          Text('60%', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(19, 0, 19, 28),
                  child: Text(
                    'Kategori Anggaran',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19, vertical: 10),
                  child: _BudgetCategory(
                    'Makanan & Minuman',
                    'Rp.800.000 / Rp.1.000.000',
                    .8,
                    Icons.donut_large,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19, vertical: 10),
                  child: _BudgetCategory(
                    'Transportasi',
                    'Rp.200.000 / Rp.500.000',
                    .4,
                    Icons.directions_bus,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19, vertical: 10),
                  child: _BudgetCategory(
                    'Belanja',
                    'Rp.200.000 / Rp.500.000',
                    .4,
                    Icons.shopping_cart,
                  ),
                ),
                const SizedBox(height: 80),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 50,
                    child: FilledButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) => const _AddBudgetDialog(),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _paleBlue,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Tambah Anggaran'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _BudgetCategory extends StatelessWidget {
  const _BudgetCategory(this.title, this.amount, this.progress, this.icon);
  final String title, amount;
  final double progress;
  final IconData icon;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      radius: 20,
      backgroundColor: _paleBlue,
      child: Icon(icon, color: Colors.black, size: 18),
    ),
    title: Text(title, style: const TextStyle(fontSize: 12)),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: const TextStyle(fontSize: 9, color: Colors.black54),
        ),
        LinearProgressIndicator(
          value: progress,
          minHeight: 4,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: _blue,
          backgroundColor: Colors.blueGrey.shade100,
        ),
      ],
    ),
    trailing: Text(
      '${(progress * 100).round()}%',
      style: const TextStyle(fontSize: 10),
    ),
  );
}

class _AddBudgetDialog extends StatelessWidget {
  const _AddBudgetDialog();
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Tambah Anggaran'),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(decoration: InputDecoration(labelText: 'Kategori')),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Batas anggaran'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Simpan'),
      ),
    ],
  );
}

class _ReportPage extends StatelessWidget {
  const _ReportPage();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
    children: [
      Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 27),
        color: _paleBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan Keuangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'November 2026',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 15),
            Row(
              children: const [
                _ReportRange(label: 'Bulan', active: true),
                SizedBox(width: 7),
                _ReportRange(label: '3 Bulan'),
                SizedBox(width: 7),
                _ReportRange(label: 'Tahun'),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Expanded(
                  child: _ReportCard(
                    label: 'Pemasukan',
                    value: 'Rp 6.500.000',
                    color: _green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ReportCard(
                    label: 'Pengeluaran',
                    value: 'Rp 2.250.000',
                    color: _red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Text(
          'Grafik Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      SizedBox(
        height: 139,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [45, 70, 58, 90, 54, 76]
                .asMap()
                .entries
                .map(
                  (entry) => Container(
                    width: 34,
                    height: entry.value.toDouble(),
                    decoration: BoxDecoration(
                      color: entry.key.isEven ? _paleBlue : _blue,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Text(
          'Per Kategori',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: _ReportLine(
          label: 'Kebutuhan',
          value: 'Rp 703.000',
          color: Color(0xFFD4E7F7),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: _ReportLine(
          label: 'Transportasi',
          value: 'Rp 442.000',
          color: Color(0xFFD4EFEC),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: _ReportLine(
          label: 'Utilitas',
          value: 'Rp 450.000',
          color: Color(0xFFFAE6D8),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: _ReportLine(
          label: 'Hiburan',
          value: 'Rp 270.000',
          color: Color(0xFFF2D7F6),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: _ReportLine(
          label: 'Lainnya',
          value: 'Rp 180.000',
          color: Color(0xFFE1E5EC),
        ),
      ),
    ],
  );
}

class _ReportRange extends StatelessWidget {
  const _ReportRange({required this.label, this.active = false});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    width: 84,
    height: 31,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: active ? _blue : Colors.white,
      border: Border.all(color: active ? _blue : const Color(0xFFA8B9C6)),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: active ? Colors.white : Colors.black,
      ),
    ),
  );
}

class _ReportLine extends StatelessWidget {
  const _ReportLine({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(width: 8, height: 34, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    children: [
      const _TopTitle('Profil'),
      const SizedBox(height: 28),
      Center(
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: const Icon(Icons.person_outline, size: 46),
        ),
      ),
      const SizedBox(height: 28),
      _profileRow(context, 'Nama panggilan', 'Salsa'),
      _profileRow(context, 'Jenis kelamin', 'Wanita'),
      const SizedBox(height: 12),
      _profileAction(
        context,
        'Keluar',
        () => _confirm(context, 'Keluar dari akun?'),
      ),
      const SizedBox(height: 5),
      _profileAction(
        context,
        'Hapus Akun',
        () => _confirm(context, 'Hapus akun CatatUang?'),
      ),
    ],
  );
  Widget _profileRow(BuildContext context, String label, String value) =>
      ListTile(
        tileColor: _paleBlue,
        dense: true,
        minTileHeight: 45,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(label, style: const TextStyle(fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontSize: 13)),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
        onTap: () {
          final c = TextEditingController(text: value);
          showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(label),
              content: TextField(controller: c),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          );
        },
      );
  Widget _profileAction(
    BuildContext context,
    String label,
    VoidCallback action,
  ) => ListTile(
    tileColor: _paleBlue,
    dense: true,
    minTileHeight: 43,
    contentPadding: EdgeInsets.zero,
    title: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13),
    ),
    onTap: action,
  );
  void _confirm(BuildContext context, String title) => showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ya'),
        ),
      ],
    ),
  );
}
