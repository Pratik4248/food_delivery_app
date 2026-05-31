import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

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
            'Add your details and verify the OTP on the next screen.',
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
