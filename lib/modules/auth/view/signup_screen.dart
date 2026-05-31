import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/widgets/auth_snackbar.dart';
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
  late final FocusNode otpFocusNode;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    otpController = TextEditingController();
    otpFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    otpController.dispose();
    otpFocusNode.dispose();
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

                  const _SignupHeader(),

                  const SizedBox(height: 24),

                  _AuthField(
                    controller: nameController,
                    hintText: 'Full name',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 12),

                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: emailController,
                    builder: (context, value, child) {
                      return _AuthField(
                        controller: emailController,
                        hintText: 'Email address',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        suffixIcon: _ValidationTick(
                          isVisible: _isValidGmail(value.text.trim()),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: passwordController,
                    builder: (context, value, child) {
                      return _AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscureText: !isPasswordVisible,
                        textInputAction: TextInputAction.next,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ValidationTick(
                              isVisible: _isValidPassword(value.text),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(
                                  () => isPasswordVisible = !isPasswordVisible,
                                );
                              },
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFFE85D04),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _AuthField(
                    controller: phoneController,
                    hintText: 'Phone number',
                    icon: Icons.call_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 12),

                  _AuthField(
                    controller: addressController,
                    hintText: 'Delivery address',
                    icon: Icons.location_on_outlined,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 18),

                  OutlinedButton.icon(
                    style: _secondaryButtonStyle,
                    onPressed: _isBusy ? null : _sendOtp,
                    icon: isSendingOtp
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : const Icon(Icons.sms_outlined),
                    label: const Text('Send OTP'),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: otpController,
                    focusNode: otpFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (_) => _verifyOtp(),
                    decoration: _fieldDecoration(
                      hintText: 'Enter OTP',
                      icon: Icons.pin_outlined,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const _AuthError(),

                  const SizedBox(height: 22),

                  ElevatedButton(
                    style: _primaryButtonStyle,
                    onPressed: _isBusy ? null : _verifyOtp,
                    child: isVerifyingOtp
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.4,
                            ),
                          )
                        : const Text('Verify and create account'),
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

  Future<void> _sendOtp() async {
    if (!_isValidGmail(emailController.text.trim())) {
      showAuthSnackBar(
        ScaffoldMessenger.of(context),
        'Enter a valid Gmail address',
      );
      return;
    }

    setState(() => isSendingOtp = true);

    await ref.read(authControllerProvider.notifier).sendOtp(
          emailController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    setState(() => isSendingOtp = false);

    final error = ref.read(authControllerProvider).error;
    if (error == null || error.isEmpty) {
      FocusScope.of(context).requestFocus(otpFocusNode);
      return;
    }

    showAuthSnackBar(ScaffoldMessenger.of(context), error);
  }

  Future<void> _verifyOtp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

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

    setState(() => isVerifyingOtp = true);

    await ref.read(authControllerProvider.notifier).verifyOtp(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phone: phoneController.text.trim(),
          address: addressController.text.trim(),
          otp: otpController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    setState(() => isVerifyingOtp = false);

    final error = ref.read(authControllerProvider).error;
    if (error == null || error.isEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      showAuthSnackBar(
        messenger,
        'Account created successfully',
        isSuccess: true,
      );
      return;
    }

    showAuthSnackBar(ScaffoldMessenger.of(context), error);
  }

  bool get _isBusy => isSendingOtp || isVerifyingOtp;

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

class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFE85D04),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2EE85D04),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.local_dining_rounded,
            color: Colors.white,
            size: 34,
          ),
          SizedBox(height: 18),
          Text(
            'Create account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your details, request an OTP, then enter it below.',
            style: TextStyle(
              color: Color(0xFFFFE7D5),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: _fieldDecoration(
        hintText: hintText,
        icon: icon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _ValidationTick extends StatelessWidget {
  const _ValidationTick({required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.only(right: 8),
      child: Icon(
        Icons.check_circle_rounded,
        color: Color(0xFF1F7A63),
        size: 22,
      ),
    );
  }
}

class _AuthError extends ConsumerWidget {
  const _AuthError();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(
      authControllerProvider.select((state) => state.error),
    );

    if (error == null || error.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDE8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFC7B8)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFC84630),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFC84630),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _fieldDecoration({
  required String hintText,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: Icon(icon, color: const Color(0xFFE85D04)),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFEADBCF)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFEADBCF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFE85D04), width: 1.5),
    ),
  );
}

final ButtonStyle _primaryButtonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size.fromHeight(56),
  elevation: 0,
  backgroundColor: const Color(0xFFE85D04),
  foregroundColor: Colors.white,
  disabledBackgroundColor: const Color(0xFFF1B182),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
);

final ButtonStyle _secondaryButtonStyle = OutlinedButton.styleFrom(
  minimumSize: const Size.fromHeight(54),
  foregroundColor: const Color(0xFFE85D04),
  side: const BorderSide(color: Color(0xFFE85D04), width: 1.3),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
);
