import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'modules/auth/repository/auth_repository.dart';
import 'modules/auth/view/login_screen.dart';
import 'modules/home/view/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: AuthRepository.hasSavedToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              backgroundColor: Color(0xFFFFFBF5),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data == true ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
