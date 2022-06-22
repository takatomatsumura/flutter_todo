import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'echo_handler.dart';

class UserDisplay extends StatelessWidget {
  const UserDisplay({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DisplayUser'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const UserDisplayWidget(),
    );
  }
}

class UserDisplayWidget extends StatefulWidget {
  const UserDisplayWidget({super.key});

  @override
  State<UserDisplayWidget> createState() => _UserDisplayStateWidget();
}

class _UserDisplayStateWidget extends State<UserDisplayWidget> {
  List _userlist = [];
  List<bool> _checkvalue = [];
  String _uuid = '';
  int? userindex;
  int? userid;
  List _truelist = [];
  Map user = {};
  @override
  void initState() {
    super.initState();
    Future(
      () async {
        _checkvalue = [];
        _userlist = await DrfDatabase().userlist();
        _uuid = FirebaseAuth.instance.currentUser?.uid.toString() ?? '';
        user = await DrfDatabase().userretrieve(_uuid);
        _userlist.asMap().forEach(
          (index, value) {
            if (value['uuid'] == _uuid) {
              userindex = index;
              userid = value['id'];
              _truelist = value['displayuser'];
            } else {
              _checkvalue.add(false);
            }
          },
        );
        _userlist.removeAt(userindex!);
        _truelist.asMap().forEach(
          (index, value) {
            _userlist.asMap().forEach(
              (index, value) {
                if (value == value['id']) {
                  _checkvalue[index] = true;
                }
              },
            );
          },
        );
        _userlist.add('');
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userlist.isNotEmpty) {
      return ListView.builder(
        itemCount: _userlist.length,
        itemBuilder: (context, index) {
          if (index != _userlist.length - 1) {
            return ListTile(
              title: Text('${_userlist[index]['name']}'),
              trailing: Checkbox(
                value: _checkvalue[index],
                onChanged: (boolvalue) {
                  setState(
                    () {
                      _checkvalue[index] = boolvalue!;
                    },
                  );
                },
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    _truelist = [];
                    _checkvalue.asMap().forEach(
                      (index, element) {
                        if (element == true) {
                          _truelist.add(_userlist[index]['id']);
                        }
                      },
                    );
                    _truelist.add(userid);
                    await DrfDatabase().userdisplayupdate(
                      _truelist,
                      userid!,
                    );
                    await Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (_) => false,
                    );
                  },
                  child: const Text('送信'),
                ),
              ),
            );
          }
        },
      );
    } else {
      return const Text('ユーザーが取得できません。');
    }
  }
}
