import 'package:flutter/material.dart';

import 'auth_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.textInputAction,
    this.onSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);

  @override
  void dispose() {
    _isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPasswordVisible,
      builder: (context, isVisible, child) {
        return AuthField(
          controller: widget.controller,
          hintText: 'Password',
          icon: Icons.lock_outline_rounded,
          obscureText: !isVisible,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.suffixIcon != null) widget.suffixIcon!,
              IconButton(
                onPressed: () {
                  _isPasswordVisible.value = !_isPasswordVisible.value;
                },
                icon: Icon(
                  isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFFE85D04),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
