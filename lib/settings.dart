import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_handler.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SettingPageWidget(),
    );
  }
}

class SettingPageWidget extends StatefulWidget {
  const SettingPageWidget({super.key});

  @override
  State<SettingPageWidget> createState() => _SettingPageStateWidget();
}

class _SettingPageStateWidget extends State<SettingPageWidget> {
  bool switchvalue = true;

  Future<void> setpreferences({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationbool', value);
  }

  Future<void> getpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        switchvalue = prefs.getBool('notificationbool') ?? true;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getpreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications),
              const Text(
                '通知',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Switch.adaptive(
                value: switchvalue,
                onChanged: (value) async {
                  await setpreferences(value: value);
                  setState(
                    () {
                      switchvalue = value;
                    },
                  );
                  await Notificationoperation().notification();
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/user',
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person),
                Text(
                  'ユーザー設定',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
