import 'package:flutter/material.dart';

const _ube = Color(0xFF4B2A6B);
const _pandan = Color(0xFF5E8C4A);
const _background = Color(0xFFF8F5FB);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Placeholder: replace with real authentication later.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login placeholder: no account check yet')),
      );
    }
  }

  InputDecoration _fieldStyle(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _ube),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ube, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _ube,
          foregroundColor: Colors.white,
          title: const Text('Login'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.bakery_dining, size: 64, color: _pandan),
                    const SizedBox(height: 12),
                    const Text(
                      'Delicacy System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _ube,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Log in to order and track your delicacies.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldStyle('Email', Icons.email_outlined),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter your email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration:
                          _fieldStyle('Password', Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Use at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pandan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Log in'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to home'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}