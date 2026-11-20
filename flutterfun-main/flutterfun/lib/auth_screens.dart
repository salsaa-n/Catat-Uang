import 'dart:async';

import 'package:flutter/material.dart';

import 'catatuang_app.dart';

const Color _brandBlue = Color(0xFF43A6DD);
const Color _paleBlue = Color(0xFFBADEFC);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) _open(const LoginScreen());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _open(Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _paleBlue,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _WalletLogo(size: 100),
          SizedBox(height: 18),
          Text(
            'CatatUang',
            style: TextStyle(
              color: _brandBlue,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _login() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const CatatUangHome()),
    );
  }

  @override
  Widget build(BuildContext context) => _AuthScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 66),
        const Center(child: _WalletLogo(size: 99)),
        const SizedBox(height: 8),
        const Text(
          'CatatUang',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _brandBlue,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 341,
            height: 189,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.fromLTRB(32, 26, 32, 0),
            decoration: BoxDecoration(
              color: _paleBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Masukkan 6 digit PIN anda'),
                const SizedBox(height: 30),
                _PinBoxes(controller: _pinController),
              ],
            ),
          ),
        ),
        const SizedBox(height: 45),
        Center(
          child: SizedBox(
            width: 214,
            height: 40,
            child: _PrimaryButton(
              label: 'Masuk',
              onPressed: _login,
              radius: 10,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
          ),
          child: const Text('Belum punya akun? Daftar'),
        ),
      ],
    ),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _register() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VerificationScreen(phone: _phoneController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _AuthScaffold(
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 66),
          const Center(child: _WalletLogo(size: 99)),
          const SizedBox(height: 8),
          const Text(
            'CatatUang',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _brandBlue,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Buat Akun Baru',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 0),
          const Text(
            'Mulai Kelola Keuanganmu Dengan Lebih Mudah.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 60),
          _AuthField(
            label: 'Nama',
            hint: 'Masukkan Nama Lengkap',
            controller: _nameController,
            validator: (value) => _required(value, 'Nama'),
          ),
          _AuthField(
            label: 'No HP',
            hint: '+62   Masukkan Nomor Handphone',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) => _required(value, 'Nomor HP'),
          ),
          _AuthField(
            label: 'PIN',
            hint: 'Masukkan 6 digit PIN',
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) => (value?.length ?? 0) == 6
                ? null
                : 'PIN harus terdiri dari 6 digit.',
          ),
          _AuthField(
            label: 'Konfirmasi PIN',
            hint: 'Masukkan ulang PIN',
            controller: _confirmPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) => value == _pinController.text
                ? null
                : 'Konfirmasi PIN tidak sama.',
          ),
          const SizedBox(height: 37),
          Center(
            child: SizedBox(
              width: 214,
              height: 40,
              child: _PrimaryButton(
                label: 'Daftar',
                onPressed: _register,
                radius: 10,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.phone});

  final String phone;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verify() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const CatatUangHome()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => _AuthScaffold(
    topPadding: 71,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.chevron_left, color: _brandBlue, size: 32),
            ),
            const Expanded(
              child: Text(
                'Verifikasi Nomor Handphone',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 47),
        Text(
          'Masukkan kode OTP yang telah dikirim melalui WhatsApp ke ${widget.phone.isEmpty ? '+62' : widget.phone}',
          style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 73),
        _PinBoxes(controller: _otpController, label: 'Kode OTP'),
        const SizedBox(height: 15),
        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Tidak menerima OTP? '),
              TextButton(
                onPressed: () => _showMessage(context, 'OTP dikirim ulang.'),
                child: const Text('Kirim ulang'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: FilledButton(
            onPressed: _verify,
            style: FilledButton.styleFrom(
              backgroundColor: _paleBlue,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
            ),
            child: const Text('Verifikasi'),
          ),
        ),
      ],
    ),
  );
}

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold({required this.child, this.topPadding = 42});

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, topPadding, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: child,
          ),
        ),
      ),
    ),
  );
}

class _WalletLogo extends StatelessWidget {
  const _WalletLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: _brandBlue,
      borderRadius: BorderRadius.circular(size * .2),
    ),
    child: Center(
      child: SizedBox(
        width: size * .4,
        height: size * .4,
        child: CustomPaint(painter: _WalletPainter()),
      ),
    ),
  );
}

class _WalletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 30;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(-1, 4)
      ..lineTo(25.35, 4)
      ..cubicTo(27.83, 4, 30, 4.93, 30, 6)
      ..cubicTo(30, 7.07, 27.83, 8, 25.35, 8)
      ..lineTo(-1, 8)
      ..close()
      ..moveTo(28.1, 9.4)
      ..lineTo(0, 9.4)
      ..lineTo(0, 26.3)
      ..cubicTo(0, 28.35, 1.65, 30, 3.75, 30)
      ..lineTo(28.1, 30)
      ..cubicTo(29.15, 30, 30, 29.15, 30, 28.1)
      ..lineTo(30, 11.25)
      ..cubicTo(30, 10.23, 29.12, 9.4, 28.1, 9.4)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(const Offset(26.2, 19.7), 2.8, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PinBoxes extends StatelessWidget {
  const _PinBoxes({required this.controller, this.label = 'PIN'});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: SizedBox(
      height: 54,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.015,
              child: TextField(
                controller: controller,
                autofocus: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                onChanged: (_) {},
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) => LayoutBuilder(
                  builder: (context, constraints) {
                    final rowWidth = constraints.maxWidth < 306
                        ? constraints.maxWidth
                        : 306.0;
                    final cellWidth = (rowWidth - 30) / 6;
                    return Center(
                      child: SizedBox(
                        width: rowWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            final filled = index < controller.text.length;
                            return Container(
                              width: cellWidth,
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: _brandBlue),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                filled ? '•' : '',
                                style: const TextStyle(fontSize: 25, height: 1),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: keyboardType == TextInputType.number ? 6 : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            filled: true,
            fillColor: const Color(0xFFF2F5F7),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC9D3DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC9D3DA)),
            ),
          ),
        ),
      ],
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.radius = 20,
  });

  final String label;
  final VoidCallback onPressed;
  final double radius;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: _brandBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    ),
  );
}

String? _required(String? value, String label) =>
    value == null || value.trim().isEmpty ? '$label wajib diisi.' : null;

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
