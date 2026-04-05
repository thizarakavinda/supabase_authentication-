import 'package:flutter/material.dart';
import 'package:supabase_flutter_authentication/components/avatar.dart';
import 'package:supabase_flutter_authentication/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _webController = TextEditingController();
  String? _imgUrl;

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
      _imgUrl = userData['avatar_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Account')),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        children: [
          Avatar(
            imgUrl: _imgUrl,
            onUpload: (imgUrl) async {
              setState(() {
                _imgUrl = imgUrl;
              });
              final userId = supabase.auth.currentUser!.id;
              await supabase
                  .from('profiles')
                  .update({'avatar_url': imgUrl})
                  .eq('id', userId);
            },
          ),

          SizedBox(height: 30),

          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _usernameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              label: Text('Username'),
            ),
          ),

          SizedBox(height: 30),

          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _webController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              label: Text('Website'),
            ),
          ),

          SizedBox(height: 50),

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
