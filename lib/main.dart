// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'Auth/signup_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://csssligtwaisybzogavl.supabase.co',
//     anonKey: 'sb_publishable_mNY5LeVO_Y0L0D3gEVao_Q_OD5M1Aeb',
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {  
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const SignupScreen(),
//     );
//   }
// }


//Riverpod 

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/Auth/home_screen.dart';
import 'package:food_delivery/Auth/login.dart';
import 'package:food_delivery/constants/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const MyApp());
} 

 class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {  
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}
