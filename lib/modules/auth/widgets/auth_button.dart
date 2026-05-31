import 'package:flutter/material.dart';

final ButtonStyle authPrimaryButtonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size.fromHeight(56),
  elevation: 0,
  backgroundColor: const Color(0xFFE85D04),
  foregroundColor: Colors.white,
  disabledBackgroundColor: const Color(0xFFF1B182),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
);

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isBusy,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: authPrimaryButtonStyle,
      onPressed: onPressed,
      child: isBusy
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.4,
              ),
            )
          : Text(label),
    );
  }
}
