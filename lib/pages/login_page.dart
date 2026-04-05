import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_authentication/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Login')),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              label: Text('Email'),
            ),
          ),

          SizedBox(height: 20),

          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade900),
            ),
            onPressed: () async {
              try {
                final email = _emailController.text.trim();
                await supabase.auth.signInWithOtp(
                  email: email,
                  emailRedirectTo:
                      'io.supabase.flutterquickstart://login-callback/',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Check your inbox')));
                }
              } on AuthApiException catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error occured. please try')),
                );
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
