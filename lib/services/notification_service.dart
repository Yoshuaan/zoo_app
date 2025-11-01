import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initNotifications() async {
    // Inisialisasi timezone
    tz.initializeTimeZones();

    // Inisialisasi channel
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'daily_zoo_channel',
        channelName: 'Daily Zoo Notification',
        channelDescription: 'Notifikasi harian tentang kebun binatang',
        defaultColor: const Color(0xFF4CAF50),
        ledColor: const Color(0xFFFFFFFF),
        importance: NotificationImportance.High,
      ),
    ]);

    // Minta izin notifikasi
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> scheduleDailyNotification({
    int hour = 15,
    int minute = 30,
  }) async {
    final jakarta = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime.now(jakarta);

    var scheduledTime = tz.TZDateTime(
      jakarta,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'daily_zoo_channel',
        title: 'Pengingat Penutupan Gembira Loka Zoo',
        body:
            'Gembira Loka Zoo akan tutup pukul 16.30! Yuk segera selesaikan kunjunganmu.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        repeats: true,
        timeZone: 'Asia/Jakarta',
      ),
    );

    print(
      ' Notifikasi dijadwalkan jam ${scheduledTime.hour}:${scheduledTime.minute} WIB',
    );
  }
}
