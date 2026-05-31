import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/widgets/auth_snackbar.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_error.dart';
import '../widgets/auth_field.dart';
import '../widgets/password_field.dart';
import '../widgets/signup_header.dart';
import '../widgets/validation_tick.dart';
import 'otp_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  bool isSendingOtp = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
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
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF24140D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const SignupHeader(),
                  const SizedBox(height: 24),
                  AuthField(
                    controller: nameController,
                    hintText: 'Full name',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: emailController,
                    builder: (context, value, child) {
                      return AuthField(
                        controller: emailController,
                        hintText: 'Email address',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        suffixIcon: ValidationTick(
                          isVisible: _isValidGmail(value.text.trim()),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: passwordController,
                    builder: (context, value, child) {
                      return PasswordField(
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ValidationTick(
                              isVisible: _isValidPassword(value.text),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AuthField(
                    controller: phoneController,
                    hintText: 'Phone number',
                    icon: Icons.call_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  AuthField(
                    controller: addressController,
                    hintText: 'Delivery address',
                    icon: Icons.location_on_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 22),
                  const AuthError(),
                  const SizedBox(height: 22),
                  AuthButton(
                    label: 'Create account',
                    isBusy: isSendingOtp,
                    onPressed: isSendingOtp ? null : _createAccount,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already registered?',
                        style: TextStyle(color: Color(0xFF6F6259)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Text('Login'),
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

  Future<void> _createAccount() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (nameController.text.trim().isEmpty) {
      showAuthSnackBar(ScaffoldMessenger.of(context), 'Enter your full name');
      return;
    }

    if (!_isValidGmail(email)) {
      showAuthSnackBar(
        ScaffoldMessenger.of(context),
        'Enter a valid Gmail address',
      );
      return;
    }

    if (!_isValidPassword(password)) {
      showAuthSnackBar(
        ScaffoldMessenger.of(context),
        'Password needs 6 characters, one uppercase letter, and one special character',
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      showAuthSnackBar(
        ScaffoldMessenger.of(context),
        'Enter your phone number',
      );
      return;
    }

    if (addressController.text.trim().isEmpty) {
      showAuthSnackBar(
        ScaffoldMessenger.of(context),
        'Enter your delivery address',
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    setState(() => isSendingOtp = true);

    await ref.read(authControllerProvider.notifier).sendOtp(email);

    if (!mounted) {
      return;
    }

    setState(() => isSendingOtp = false);

    final error = ref.read(authControllerProvider).error;
    if (error == null || error.isEmpty) {
      final created = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            name: nameController.text.trim(),
            email: email,
            password: password,
            phone: phoneController.text.trim(),
            address: addressController.text.trim(),
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      if (created == true) {
        showAuthSnackBar(
          messenger,
          'Account created successfully',
          isSuccess: true,
        );
        Navigator.of(context).pop();
      }
      return;
    }

    showAuthSnackBar(ScaffoldMessenger.of(context), error);
  }

  bool _isValidGmail(String email) {
    return RegExp(
      r'^[A-Za-z0-9._%+-]+@gmail\.com$',
      caseSensitive: false,
    ).hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasSpecial = RegExp(r'[^A-Za-z0-9]').hasMatch(password);
    return password.length >= 6 && hasUppercase && hasSpecial;
  }
}
