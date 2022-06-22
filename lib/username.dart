import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'echo_handler.dart';

class UserName extends StatelessWidget {
  const UserName({super.key});
  @override
  Widget build(BuildContext context) {
    final navigationbool = Navigator.of(context).canPop();
    return Scaffold(
      appBar: navigationbool == true
          ? AppBar(
              title: const Text('UserName'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : AppBar(
              title: const Text('UserName'),
            ),
      body: const UserNameWidget(),
    );
  }
}

class UserNameWidget extends StatefulWidget {
  const UserNameWidget({super.key});

  @override
  State<UserNameWidget> createState() => _UserNameStateWidget();
}

class _UserNameStateWidget extends State<UserNameWidget> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _uuid;
  var _user;

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        _uuid = FirebaseAuth.instance.currentUser?.uid.toString();
        _user = await DrfDatabase().userretrieve(_uuid);
        if (_user != null) {
          setState(
            () {
              _nameController.text = _user['name'];
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('みんながわかる名前を入力してください。'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ユーザー名',
                labelText: 'ユーザー名',
                filled: true,
              ),
              validator: (namevalue) {
                if (namevalue == null || namevalue.isEmpty) {
                  return '必須項目です';
                } else if (100 <= namevalue.length) {
                  return '100文字までしか入力できません。';
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            child: const Text('保存'),
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                await DrfDatabase().usernameupdate(
                  _nameController.text,
                  _user['id'],
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (_) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Processing Data'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
