import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/auth_controller.dart';

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

  late final TextEditingController otpController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();

    emailController = TextEditingController();

    passwordController = TextEditingController();

    phoneController = TextEditingController();

    addressController = TextEditingController();

    otpController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();

    emailController.dispose();

    passwordController.dispose();

    phoneController.dispose();

    addressController.dispose();

    otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(hintText: 'Phone'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(hintText: 'Address'),
            ),

            const SizedBox(height: 20),

            Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(
                  authControllerProvider.select(
                    (state) => state.isLoading,
                  ),
                );

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref.read(authControllerProvider.notifier).sendOtp(
                                emailController.text.trim(),
                              );
                        },
                  child: child!,
                );
              },
              child: const Text('Send OTP'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: otpController,
              decoration: const InputDecoration(hintText: 'Enter OTP'),
            ),

            const SizedBox(height: 20),

            Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(
                  authControllerProvider.select(
                    (state) => state.isLoading,
                  ),
                );

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref.read(authControllerProvider.notifier).verifyOtp(
                                name: nameController.text.trim(),

                                email: emailController.text.trim(),

                                password: passwordController.text.trim(),

                                phone: phoneController.text.trim(),

                                address: addressController.text.trim(),

                                otp: otpController.text.trim(),
                              );
                        },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : child!,
                );
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
