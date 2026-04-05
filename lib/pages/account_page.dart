import 'package:flutter/material.dart';
import 'package:supabase_flutter_authentication/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _webController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAccount();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _webController.dispose();
  }

  Future<void> _fetchAccount() async {
    final userId = supabase.auth.currentUser!.id;
    final userData = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    setState(() {
      _usernameController.text = userData['username'];
      _webController.text = userData['website'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Account page'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _usernameController,
            decoration: InputDecoration(label: Text('Username')),
          ),

          SizedBox(height: 10),

          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _webController,
            decoration: InputDecoration(label: Text('Website')),
          ),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              final username = _usernameController.text.trim();
              final website = _webController.text.trim();
              final userId = supabase.auth.currentUser!.id;

              await supabase
                  .from('profiles')
                  .update({'username': username, 'website': website})
                  .eq('id', userId);
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Profile Data Saved')));
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
