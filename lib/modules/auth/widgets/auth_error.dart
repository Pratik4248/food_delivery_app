import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class AuthError extends ConsumerWidget {
  const AuthError({super.key});

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
