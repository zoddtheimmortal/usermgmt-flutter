import 'package:flutter/material.dart';
import 'package:usermgmt_flutter/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _getInitalProfile() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    setState(() {
      _usernameController.text = data['username'];
      _websiteController.text = data['website'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(label: Text('Username')),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(label: Text('Website')),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text.trim();
                  final website = _websiteController.text.trim();
                  final userId = supabase.auth.currentUser!.id;
                  await supabase.from('profiles').update({
                    'username': username,
                    'website': website,
                  }).eq('id', userId);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Data has been saved.'),
                    ));
                  }
                },
                child: const Text('Save')),
          ],
        ));
  }
}
