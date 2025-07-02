import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(settings);
  initializeTimeZones(); 
}

Future<void> scheduleMultipleHealthTips() async {
  const androidDetails = AndroidNotificationDetails(
    'health_tip_channel',
    'Health Tips',
    channelDescription: 'Daily tips and wellness reminders',
    importance: Importance.high,
    priority: Priority.high,
    icon: 'ic_notification',
  );

  const details = NotificationDetails(android: androidDetails);

  final List<Map<String, int>> scheduleTimes = [
    {'id': 1, 'hour': 8, 'minute': 0},   // Morning
    {'id': 2, 'hour': 13, 'minute': 0},  // Afternoon
    {'id': 3, 'hour': 19, 'minute': 0},  // Evening
  ];

  for (var entry in scheduleTimes) {
    final id = entry['id']!;
    final hour = entry['hour']!;
    final minute = entry['minute']!;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Health Tip 💡',
      _getRandomTip(),
      _nextInstanceOfTime(hour, minute),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}


Future<void> cancelAllHealthTips() async {
  await flutterLocalNotificationsPlugin.cancel(1);
  await flutterLocalNotificationsPlugin.cancel(2);
  await flutterLocalNotificationsPlugin.cancel(3);
}


tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

/// Picks a random health tip
String _getRandomTip() {
  final tips = [
    "Measure your calories before you eat.",
    "Drink at least 8 glasses of water today.",
    "Eat more fiber-rich foods like fruits and veggies.",
    "Take a short walk after every meal.",
    "Avoid late-night snacking.",
    "Include protein in every meal.",
    "Limit sugary drinks for better energy.",
    "Take regular screen breaks during the day.",
    "Stretch your body after long sitting periods.",
    "Get at least 7-8 hours of sleep every night.",
  ];
  tips.shuffle();
  return tips.first;
}
