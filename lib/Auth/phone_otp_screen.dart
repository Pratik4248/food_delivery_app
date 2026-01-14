// Deprecated: Phone OTP flow removed in favor of email magic link flow.
// Keep this file only for history; navigation now points to `EmailOtpScreen`.

// If you want to remove the file from the project completely, delete it.

import 'package:flutter/material.dart';

class PhoneOtpScreen extends StatelessWidget {
  const PhoneOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deprecated')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Phone OTP has been removed. Use Email magic link instead.'),
        ),
      ),
    );
  }
}
