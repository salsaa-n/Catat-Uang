import 'package:flutter/material.dart';

import 'lesson.dart';

enum _AuthMode { login, registration }

class AuthFormsDemo extends StatefulWidget {
  const AuthFormsDemo({super.key});

  @override
  State<AuthFormsDemo> createState() => _AuthFormsDemoState();
}

class _AuthFormsDemoState extends State<AuthFormsDemo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  _AuthMode _mode = _AuthMode.login;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _rememberMe = false;
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  bool get _isRegistration => _mode == _AuthMode.registration;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_isRegistration && !_acceptedTerms) {
      setState(() => _showTermsError = true);
      return;
    }

    setState(() => _showTermsError = false);
    notify(
      context,
      _isRegistration
          ? 'Form pendaftaran valid. Sambungkan ke layanan autentikasi.'
          : 'Form login valid. Sambungkan ke layanan autentikasi.',
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Lesson(
        title: 'Form Login & Registration',
        description: 'Contoh UI dengan validasi lokal. Belum terhubung ke backend atau menyimpan akun.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_AuthMode>(
              segments: const [
                ButtonSegment(
                  value: _AuthMode.login,
                  label: Text('Login'),
                  icon: Icon(Icons.login),
                ),
                ButtonSegment(
                  value: _AuthMode.registration,
                  label: Text('Daftar'),
                  icon: Icon(Icons.person_add_alt_1),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) {
                setState(() {
                  _mode = selection.first;
                  _formKey.currentState?.reset();
                  _showTermsError = false;
                });
              },
            ),
            const SizedBox(height: 24),
            Text(
              _isRegistration ? 'Buat akun baru' : 'Selamat datang kembali',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              _isRegistration
                  ? 'Isi data berikut untuk membuat akun.'
                  : 'Masuk menggunakan email dan kata sandi Anda.',
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isRegistration) ...[
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama lengkap',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? 'Nama wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'nama@email.com',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final email = (value ?? '').trim();
                      if (email.isEmpty) return 'Email wajib diisi';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return 'Masukkan alamat email yang valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: _isRegistration
                        ? TextInputAction.next
                        : TextInputAction.done,
                    autofillHints: [
                      _isRegistration
                          ? AutofillHints.newPassword
                          : AutofillHints.password,
                    ],
                    onFieldSubmitted: (_) {
                      if (!_isRegistration) _submit();
                    },
                    decoration: InputDecoration(
                      labelText: 'Kata sandi',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      final password = value ?? '';
                      if (password.isEmpty) return 'Kata sandi wajib diisi';
                      if (_isRegistration && password.length < 8) {
                        return 'Kata sandi minimal 8 karakter';
                      }
                      return null;
                    },
                  ),
                  if (_isRegistration) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmationController,
                      obscureText: _obscureConfirmation,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi kata sandi',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _obscureConfirmation
                              ? 'Tampilkan konfirmasi kata sandi'
                              : 'Sembunyikan konfirmasi kata sandi',
                          onPressed: () => setState(
                            () => _obscureConfirmation = !_obscureConfirmation,
                          ),
                          icon: Icon(
                            _obscureConfirmation
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return 'Konfirmasi kata sandi wajib diisi';
                        }
                        if (value != _passwordController.text) {
                          return 'Kata sandi tidak sama';
                        }
                        return null;
                      },
                    ),
                  ],
                  if (_isRegistration) ...[
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _acceptedTerms,
                      onChanged: (value) => setState(() {
                        _acceptedTerms = value ?? false;
                        if (_acceptedTerms) _showTermsError = false;
                      }),
                      title: const Text('Saya menyetujui syarat dan ketentuan'),
                    ),
                    if (_showTermsError)
                      const Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 8),
                        child: Text(
                          'Persetujuan wajib dicentang',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ] else
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _rememberMe,
                      onChanged: (value) =>
                          setState(() => _rememberMe = value ?? false),
                      title: const Text('Ingat saya'),
                    ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: Icon(
                      _isRegistration ? Icons.person_add_alt_1 : Icons.login,
                    ),
                    label: Text(_isRegistration ? 'Buat akun' : 'Masuk'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
