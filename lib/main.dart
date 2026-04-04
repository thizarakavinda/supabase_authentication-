import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_authentication/pages/account_page.dart';
import 'package:supabase_flutter_authentication/pages/login_page.dart';
import 'package:supabase_flutter_authentication/pages/splash.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://xdhhjxzuycmufmcxgetg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkaGhqeHp1eWNtdWZtY3hnZXRnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzMDcxOTMsImV4cCI6MjA5MDg4MzE5M30.-0fxEuYDlFQ2xcJ8vWcYSIEsOnV-WTpp8hoibNZ8O-4',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/login': (context) => const LoginPage(),
        '/account': (context) => const AccountPage(),
      },
    );
  }
}
