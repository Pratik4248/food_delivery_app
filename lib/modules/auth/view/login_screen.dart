import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/auth_controller.dart';


class LoginScreen
extends ConsumerStatefulWidget {

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}


class _LoginScreenState
extends ConsumerState<LoginScreen> {

  late final TextEditingController
  emailController;

  late final TextEditingController
  passwordController;


  @override
  void initState() {

    super.initState();

    emailController =
        TextEditingController();

    passwordController =
        TextEditingController();
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(
                hintText: 'Email',
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                hintText: 'Password',
              ),
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
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            ref.read(authControllerProvider.notifier).login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator()
                          : child!,
                );
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
