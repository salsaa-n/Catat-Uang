import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Verification screen measured from the CatatUang Page 1 Figma frame.
class VerifikasiScreen extends StatefulWidget {
  const VerifikasiScreen({super.key, this.onVerified});

  final ValueChanged<String>? onVerified;

  @override
  State<VerifikasiScreen> createState() => _VerifikasiScreenState();
}

class _VerifikasiScreenState extends State<VerifikasiScreen> {
  static const _blue = Color(0xFFBADEFC);
  static const _accent = Color(0xFF43A6DD);
  static const _muted = Color(0xFFB3B3B3);
  static const _ink = Color(0xFF000000);

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  late final TapGestureRecognizer _resendRecognizer;

  @override
  void initState() {
    super.initState();
    _resendRecognizer = TapGestureRecognizer()..onTap = _resendCode;
  }

  @override
  void dispose() {
    _resendRecognizer.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode OTP dikirim ulang')),
    );
  }

  void _verify() {
    final code = _controllers.map((controller) => controller.text).join();
    widget.onVerified?.call(code);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode OTP siap diverifikasi')),
    );
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 402,
              height: 874,
              child: Stack(
                children: [
                  Positioned(
                    left: 11,
                    top: 75,
                    width: 38,
                    height: 35,
                    child: Material(
                      color: _blue,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => Navigator.maybePop(context),
                        child: const Center(
                          child: Icon(Icons.chevron_left, size: 22, color: _ink),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 61,
                    top: 82,
                    width: 271,
                    height: 24,
                    child: Text(
                      'Verifikasi Nomor Handphone',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                        color: _ink,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    top: 145,
                    width: 355,
                    height: 30,
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.25,
                          fontStyle: FontStyle.italic,
                          color: _muted,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'Masukkan kode OTP yang telah dikirim melalui WhatsApp ke\n',
                          ),
                          const TextSpan(
                            text: '+62',
                            style: TextStyle(color: _accent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 63,
                    top: 215,
                    width: 276,
                    height: 46,
                    child: Row(
                      children: List.generate(6, (index) => _otpField(index)),
                    ),
                  ),
                  Positioned(
                    left: 95,
                    top: 289,
                    width: 191,
                    height: 15,
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.25,
                          color: _ink,
                        ),
                        children: [
                          const TextSpan(text: 'Tidak menerima OTP?'),
                          TextSpan(
                            text: ' Kirim ulang',
                            style: const TextStyle(color: _accent),
                            recognizer: _resendRecognizer,
                          ),
                        ],
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Positioned(
                    left: 26,
                    top: 344,
                    width: 342,
                    height: 40,
                    child: Material(
                      color: _blue,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _verify,
                        child: const Center(
                          child: Text(
                            'Verifikasi',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              height: 19 / 16,
                              fontWeight: FontWeight.w400,
                              color: _ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpField(int index) {
    final radius = BorderRadius.circular(5);
    return SizedBox(
      width: 46,
      height: 46,
      child: Material(
        color: Colors.white,
        borderRadius: radius,
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 20, color: _ink),
          onChanged: (value) => _onDigitChanged(index, value),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(color: _accent, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(color: _accent, width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
