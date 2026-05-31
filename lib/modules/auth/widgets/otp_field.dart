import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_field.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSubmitted: onSubmitted,
      decoration: authFieldDecoration(
        hintText: 'Enter OTP',
        icon: Icons.pin_outlined,
      ),
    );
  }
}
