import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Initialize Notifications
  static void initializeNotifications() {
    AwesomeNotifications().initialize(
      null, // Default app icon
      [
        NotificationChannel(
          channelKey: 'medication_channel',
          channelName: 'Medication Notifications',
          channelDescription: 'Notifications for scheduled medications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  // Schedule Medication Notification with Start and End Dates
  static void scheduleMedicationNotificationWithPeriod({
    required String childId,
    required String medicationName,
    required String childName,
    required TimeOfDay time,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    DateTime startNotificationTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      time.hour,
      time.minute,
    );

    for (DateTime currentDate = startNotificationTime;
        currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
        currentDate = currentDate.add(const Duration(days: 1))) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: currentDate.hashCode,
          channelKey: 'medication_channel',
          title: "Medication Reminder",
          body: 'It is time to give $childName their $medicationName',
          payload: {
            'childId': childId,
            'medicationName': medicationName,
          },
        ),
        schedule: NotificationCalendar(
          year: currentDate.year,
          month: currentDate.month,
          day: currentDate.day,
          hour: time.hour,
          minute: time.minute,
          second: 0,
          millisecond: 0,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
    }
  }
}
