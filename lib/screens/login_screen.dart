import 'package:flutter/material.dart';

import '../core/auth/auth_service.dart';
import '../widgets/auth_form.dart';

/// Email sign-in / registration. Pops with `true` after a successful sign-in.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _register = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await _perform(() async {
      if (_register) {
        await widget.authService.registerWithEmail(_email.text, _password.text);
      } else {
        await widget.authService.signInWithEmail(_email.text, _password.text);
      }
    }, onDone: () => Navigator.of(context).pop(true));
  }

  Future<void> _forgotPassword() async {
    final email = _email.text.trim();
    if (!email.contains('@')) {
      setState(() => _error = 'Enter your email first.');
      return;
    }

    await _perform(
      () => widget.authService.sendPasswordReset(email),
      onDone: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      ),
    );
  }

  Future<void> _perform(
    Future<void> Function() action, {
    required VoidCallback onDone,
  }) async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await action();
      if (!mounted) return;
      onDone();
    } on AuthFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } catch (error) {
      debugPrint('Unexpected sign-in error: $error');
      if (mounted) setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toggleMode() {
    setState(() {
      _register = !_register;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_register ? 'Create account' : 'Sign in')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Save your progress and join the leaderboard.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  if (_register) ...[
                    const SizedBox(height: 8),
                    Text(
                      'By creating an account you confirm you are 13 or older.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 24),
                  AuthForm(
                    formKey: _formKey,
                    emailController: _email,
                    passwordController: _password,
                    isRegister: _register,
                    busy: _busy,
                    error: _error,
                    onSubmit: _submit,
                    onToggleMode: _toggleMode,
                    onForgotPassword: _forgotPassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
