import 'package:flutter/material.dart';

class ValidationTick extends StatelessWidget {
  const ValidationTick({
    super.key,
    required this.isVisible,
  });

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
