import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE85D04),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33E85D04),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF24140D),
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF7A6A5F),
            fontSize: 16,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}