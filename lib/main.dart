import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'firebase_options.dart';
import 'form.dart';
import 'homepage.dart';
import 'settings.dart';
import 'user.dart';
import 'userdisplay.dart';
import 'username.dart';

// class FirstLogin {
//   var _uuid;
//   var _todouser;
//   Future<void> login() async {
// AuthResult user = await firebaseAuth.signInAnonymously();
// _uuid = user.user.uid;
// _todouser = await DrfDatabase().userretrieve(_uuid);
// if (_todouser['uuid'] == null) {
//   await DrfDatabase().usercreate(_uuid);
//   _todouser = await DrfDatabase().userretrieve(_uuid);
//   var _initialdisplay = [_todouser['id']];
//   await DrfDatabase().userdisplayupdate(_initialdisplay, _todouser['id']);
//   initialbool = true;
// } else {
//   initialbool = false;
// }
//   }
// }

// class Getuuid {
//   Future<String> getuuid() async {
//     final _user = await firebaseAuth.signInAnonymously();
//     String _uuid = _user.user.uid;
//     return _uuid;
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fireAuth = FirebaseAuth.instance;
  if (fireAuth.currentUser == null) {
    await fireAuth.signInAnonymously();
  }
  // await FirstLogin().login();
  // if (initialbool == false) {
  //   await Notificationoperation().notification();
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser != null ? '/home' : '/username',
      routes: {
        '/home': (context) => const MyHomePage(),
        '/form': (context) => const FormPage(),
        '/detail': (context) => const DetailPage(),
        '/setting': (context) => const SettingPage(),
        '/user': (context) => const UserSetting(),
        '/username': (context) => const UserName(),
        '/displayuser': (context) => const UserDisplay(),
      },
    );
  }
}
