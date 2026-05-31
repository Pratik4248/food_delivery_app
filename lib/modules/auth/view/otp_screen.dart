import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/widgets/auth_snackbar.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
  });

  final String name;
  final String email;
  final String password;
  final String phone;
  final String address;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late final TextEditingController otpController;
  bool isVerifyingOtp = false;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFFBF5),
        foregroundColor: const Color(0xFF24140D),
        iconTheme: const IconThemeData(color: Color(0xFF24140D)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _OtpHeader(),
                  const SizedBox(height: 24),
                  Text(
                    'Enter the 6-digit code sent to ${widget.email}',
                    style: const TextStyle(
                      color: Color(0xFF6F6259),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: otpController,
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
                    onPressed: isVerifyingOtp ? null : _verifyOtp,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      showAuthSnackBar(
        ScaffoldMessenger.of(context),
        'Enter the OTP received on your email',
      );
      return;
    }

    setState(() => isVerifyingOtp = true);

    await ref.read(authControllerProvider.notifier).verifyOtp(
          name: widget.name,
          email: widget.email,
          password: widget.password,
          phone: widget.phone,
          address: widget.address,
          otp: otpController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    setState(() => isVerifyingOtp = false);

    final error = ref.read(authControllerProvider).error;
    if (error == null || error.isEmpty) {
      Navigator.of(context).pop(true);
      return;
    }

    showAuthSnackBar(ScaffoldMessenger.of(context), error);
  }
}

class _OtpHeader extends StatelessWidget {
  const _OtpHeader();

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
            'Verify your account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Enter the OTP sent to your email to complete registration.',
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
