import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final  x = Provider<String>((ref){
   return "Pratik";
});

final y = Provider<int>((ref){
    return 21;
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(x);
    final int age = ref.watch(y);
    return Scaffold(
      body: Center(
        child: Text(
          "Value is $value and age is $age",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}