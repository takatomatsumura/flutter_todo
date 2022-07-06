import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'echo_handler.dart';

class Notificationoperation {
  static const int interval = -1;
  Future<void> notification() async {
    tz.initializeTimeZones();
    final preferences = await SharedPreferences.getInstance();
    final notificationbool = preferences.getBool('notificationbool') ?? true;
    if (notificationbool == true) {
      final uuid = FirebaseAuth.instance.currentUser?.uid;
      final targetlength = await EchiRequest().gettargetlength(uuid!);
      final notificationtarget =
          await EchiRequest().getnotificationtarget(uuid);
      var index = targetlength;
      if (notificationtarget.length != targetlength) {
        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings('icon'),
            iOS: IOSInitializationSettings(),
          ),
        );
        while (index < notificationtarget.length) {
          final deadline = DateTime.parse(
            notificationtarget[index]['fields']['date'],
          ).add(
            const Duration(minutes: interval),
          );
          final now = DateTime.now();
          var dif = deadline.difference(now).inSeconds;
          if (dif <= (-interval) * 60) {
            dif = 1;
          }
          await flutterLocalNotificationsPlugin.cancel(index);
          await flutterLocalNotificationsPlugin.zonedSchedule(
            index,
            '〆切が迫っています。',
            "${notificationtarget[index]['fields']['title']}",
            tz.TZDateTime.from(DateTime.now(), tz.local)
                .add(Duration(seconds: dif)),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'your channel id',
                'your channel name',
                importance: Importance.max,
                priority: Priority.high,
              ),
              iOS: IOSNotificationDetails(),
            ),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
          );
          index++;
        }
      }
    }
  }
}
