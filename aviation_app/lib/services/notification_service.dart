import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Top-level function for handling background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[NotificationService] 🔔 BACKGROUND MESSAGE RECEIVED');
  debugPrint('[NotificationService] Message ID: ${message.messageId}');
  debugPrint('[NotificationService] Notification: ${message.notification != null ? "YES" : "NO"}');
  if (message.notification != null) {
    debugPrint('[NotificationService] Title: ${message.notification?.title}');
    debugPrint('[NotificationService] Body: ${message.notification?.body}');
  }
  debugPrint('[NotificationService] Data: ${message.data}');
}

class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService _instance =
      NotificationService._privateConstructor();
  static NotificationService get instance => _instance;

  // Firebase Messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Local Notifications plugin
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification channel for Android
  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      debugPrint('[NotificationService] ========================================');
      debugPrint('[NotificationService] 🚀 Starting Notification Service...');
      debugPrint('[NotificationService] ========================================');

      // Request permissions
      debugPrint('[NotificationService] Step 1: Requesting permissions...');
      await _requestPermissions();

      // Initialize local notifications
      debugPrint('[NotificationService] Step 2: Initializing local notifications...');
      await _initializeLocalNotifications();

      // Get FCM token
      debugPrint('[NotificationService] Step 3: Getting FCM token...');
      await _getFCMToken();

      // Setup message handlers
      debugPrint('[NotificationService] Step 4: Setting up message handlers...');
      _setupMessageHandlers();

      // Setup token refresh listener
      debugPrint('[NotificationService] Step 5: Setting up token refresh listener...');
      _setupTokenRefreshListener();

      debugPrint('[NotificationService] ========================================');
      debugPrint('[NotificationService] ✅ Notification Service Initialized Successfully');
      debugPrint('[NotificationService] ========================================');
    } catch (e) {
      debugPrint('[NotificationService] ========================================');
      debugPrint('[NotificationService] ❌ Initialization error: $e');
      debugPrint('[NotificationService] ========================================');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      // Request iOS permissions
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint(
        '[NotificationService] iOS permission status: ${settings.authorizationStatus}',
      );
    } else if (Platform.isAndroid) {
      // Request Android 13+ permissions
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.createNotificationChannel(_channel);

      debugPrint('[NotificationService] Android permissions requested');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with settings and callback
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    debugPrint('[NotificationService] Local notifications initialized');
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('[NotificationService] FCM Token: $_fcmToken');

      // TODO: Send token to your backend server
      // await _sendTokenToServer(_fcmToken);
    } catch (e) {
      debugPrint('[NotificationService] Error getting FCM token: $e');
    }
  }

  /// Setup token refresh listener
  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      debugPrint('[NotificationService] Token refreshed: $newToken');

      // TODO: Send updated token to your backend server
      // await _sendTokenToServer(newToken);
    });
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    debugPrint('[NotificationService] Setting up message handlers...');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    debugPrint('[NotificationService] ✓ Foreground message handler registered');

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    debugPrint('[NotificationService] ✓ Background tap handler registered');

    // Handle notification tap when app was terminated
    _checkInitialMessage();
    debugPrint('[NotificationService] ✓ Initial message check completed');
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('[NotificationService] 📱 FOREGROUND MESSAGE RECEIVED');
    debugPrint('[NotificationService] Message ID: ${message.messageId}');
    debugPrint('[NotificationService] Notification: ${message.notification != null ? "YES" : "NO"}');

    if (message.notification != null) {
      debugPrint('[NotificationService] Title: ${message.notification!.title}');
      debugPrint('[NotificationService] Body: ${message.notification!.body}');
    }

    debugPrint('[NotificationService] Data: ${message.data}');

    // Show local notification when app is in foreground
    if (message.notification != null) {
      debugPrint('[NotificationService] Showing local notification...');
      await _showLocalNotification(
        title: message.notification!.title ?? 'New Message',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    } else {
      debugPrint('[NotificationService] ⚠️ No notification payload - skipping local notification');
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('[NotificationService] 👆 NOTIFICATION TAPPED (Background)');
    debugPrint('[NotificationService] Message ID: ${message.messageId}');
    debugPrint('[NotificationService] Data: ${message.data}');

    // Navigate based on notification data
    _navigateBasedOnData(message.data);
  }

  /// Check for initial message (when app was terminated)
  Future<void> _checkInitialMessage() async {
    debugPrint('[NotificationService] Checking for initial message (terminated state)...');
    final initialMessage = await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('[NotificationService] 🚀 App opened from TERMINATED state via notification');
      debugPrint('[NotificationService] Message ID: ${initialMessage.messageId}');
      _handleNotificationTap(initialMessage);
    } else {
      debugPrint('[NotificationService] No initial message (normal app launch)');
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      debugPrint('[NotificationService] Creating local notification...');
      debugPrint('[NotificationService] ID: $notificationId');
      debugPrint('[NotificationService] Title: $title');
      debugPrint('[NotificationService] Body: $body');
      debugPrint('[NotificationService] Payload: $payload');

      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      debugPrint('[NotificationService] ✅ Local notification shown successfully');
    } catch (e) {
      debugPrint('[NotificationService] ❌ Error showing local notification: $e');
    }
  }

  /// Handle notification tap (local notifications)
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('[NotificationService] 👆 LOCAL NOTIFICATION TAPPED');
    debugPrint('[NotificationService] Notification ID: ${response.id}');
    debugPrint('[NotificationService] Action ID: ${response.actionId}');
    debugPrint('[NotificationService] Payload: ${response.payload}');

    // TODO: Parse payload and navigate
    // Example: Navigate to specific screen based on payload
  }

  /// Navigate based on notification data
  void _navigateBasedOnData(Map<String, dynamic> data) {
    // Example navigation logic
    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'chat':
          final flightId = data['flight_id'];
          if (flightId != null) {
            // Navigate to chat screen
            // Get.toNamed('/chat', arguments: flightId);
            debugPrint('[NotificationService] Navigate to chat: $flightId');
          }
          break;

        case 'flight_update':
          final flightId = data['flight_id'];
          if (flightId != null) {
            // Navigate to flight details
            // Get.toNamed('/flight-details', arguments: flightId);
            debugPrint('[NotificationService] Navigate to flight: $flightId');
          }
          break;

        default:
          debugPrint('[NotificationService] Unknown notification type: ${data['type']}');
      }
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('[NotificationService] Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('[NotificationService] Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('[NotificationService] Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('[NotificationService] Error unsubscribing from topic: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    debugPrint('[NotificationService] All notifications cancelled');
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    debugPrint('[NotificationService] Notification $id cancelled');
  }

  /// Show custom notification (for app-generated notifications)
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      payload: data?.toString(),
    );
  }

  /// Get notification badge count (iOS)
  Future<int?> getBadgeCount() async {
    if (Platform.isIOS) {
      // This requires additional setup for iOS
      return null;
    }
    return null;
  }

  /// Set notification badge count (iOS)
  Future<void> setBadgeCount(int count) async {
    if (Platform.isIOS) {
      // This requires additional setup for iOS
      debugPrint('[NotificationService] Badge count set to: $count');
    }
  }

  /// Clear badge count
  Future<void> clearBadge() async {
    await setBadgeCount(0);
  }
}
