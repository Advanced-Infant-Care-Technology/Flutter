import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Store active notifications in memory (or use a local database)
  static final Map<int, String> activeNotifications = {};

  // Counter for generating unique IDs
  static int notificationCounter = 0;

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
      // Generate unique notification ID using the counter
      int notificationId = notificationCounter++;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'medication_channel',
          title: "Medication Reminder",
          body: 'It is time to give $childName their $medicationName',
          payload: {
            'notificationId': notificationId.toString(),
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

      // Save notification ID to active notifications
      activeNotifications[notificationId] = medicationName;
    }
  }

  // Remove Medication Notification
  static void removeMedicationNotification(int notificationId) {
    // Check if the notification ID exists
    if (activeNotifications.containsKey(notificationId)) {
      AwesomeNotifications().cancel(notificationId);
      activeNotifications.remove(notificationId);
    }
  }

  // Update Medication Notification
  static void updateMedicationNotification({
    required String childId,
    required String medicationName,
    required String childName,
    required TimeOfDay time,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Generate a new notification ID
    int notificationId = notificationCounter++;

    // First remove the existing notification if applicable
    removeMedicationNotification(notificationId);

    // Schedule the updated notification
    scheduleMedicationNotificationWithPeriod(
      childId: childId,
      medicationName: medicationName,
      childName: childName,
      time: time,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
