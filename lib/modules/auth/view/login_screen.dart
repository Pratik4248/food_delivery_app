import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/widgets/auth_snackbar.dart';
import '../controller/auth_controller.dart';
import '../../home/view/home_screen.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_error.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_field.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: 'Welcome back',
                    subtitle: 'Sign in and get your next meal moving.',
                  ),
                  const SizedBox(height: 28),
                  AuthField(
                    controller: emailController,
                    hintText: 'Email address',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  PasswordField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 16),
                  const AuthError(),
                  const SizedBox(height: 22),
                  AuthButton(
                    label: 'Login',
                    isBusy: isLoggingIn,
                    onPressed: isLoggingIn ? null : _login,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New here?',
                        style: TextStyle(color: Color(0xFF6F6259)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text('Create account'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = emailController.text.trim();

    if (!_isValidGmail(email)) {
      showAuthSnackBar(
        ScaffoldMessenger.of(context),
        'Enter a valid Gmail address',
      );
      return;
    }

    setState(() => isLoggingIn = true);

    await ref.read(authControllerProvider.notifier).login(
          email: email,
          password: passwordController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    setState(() => isLoggingIn = false);

    final error = ref.read(authControllerProvider).error;
    if (error == null || error.isEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    final message = error == 'User not found' || error == 'Invalid password'
        ? 'Invalid Credentials'
        : error;

    showAuthSnackBar(ScaffoldMessenger.of(context), message);
  }

  bool _isValidGmail(String email) {
    return RegExp(
      r'^[A-Za-z0-9._%+-]+@gmail\.com$',
      caseSensitive: false,
    ).hasMatch(email);
  }
}
