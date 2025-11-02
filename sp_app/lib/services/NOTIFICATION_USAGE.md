# Notification Service Usage Guide

## Overview
The `NotificationService` manages both Firebase Cloud Messaging (FCM) and local notifications in your Flutter app.

## Features
✅ Firebase Cloud Messaging (FCM) integration
✅ Local notifications support
✅ Foreground notification handling
✅ Background & terminated state handling
✅ Notification tap handling & navigation
✅ Topic subscription/unsubscription
✅ Token management
✅ Permission requests (iOS & Android)

## Installation

The service is already initialized in `main.dart`. No additional setup needed!

## Basic Usage

### 1. Get FCM Token
```dart
String? token = NotificationService.instance.fcmToken;
print('FCM Token: $token');
```

### 2. Show Custom Notification
```dart
await NotificationService.instance.showNotification(
  title: 'Flight Update',
  body: 'Flight BA123 is now boarding',
  data: {
    'type': 'flight_update',
    'flight_id': '123',
  },
);
```

### 3. Subscribe to Topic
```dart
await NotificationService.instance.subscribeToTopic('flight_updates');
```

### 4. Unsubscribe from Topic
```dart
await NotificationService.instance.unsubscribeFromTopic('flight_updates');
```

### 5. Cancel Notifications
```dart
// Cancel all notifications
await NotificationService.instance.cancelAllNotifications();

// Cancel specific notification
await NotificationService.instance.cancelNotification(notificationId);
```

## Notification Navigation

### How it works:
When a user taps on a notification, the app automatically navigates based on the `data` payload.

### Supported Navigation Types:

#### 1. Chat Notifications
```dart
// Backend sends:
{
  "notification": {
    "title": "New Message",
    "body": "Ali Adnan sent you a message"
  },
  "data": {
    "type": "chat",
    "flight_id": "123"
  }
}
```

#### 2. Flight Update Notifications
```dart
// Backend sends:
{
  "notification": {
    "title": "Flight Update",
    "body": "Flight BA123 is now delayed"
  },
  "data": {
    "type": "flight_update",
    "flight_id": "123"
  }
}
```

### Custom Navigation

Update the `_navigateBasedOnData` method in `notification_service.dart`:

```dart
void _navigateBasedOnData(Map<String, dynamic> data) {
  if (data.containsKey('type')) {
    switch (data['type']) {
      case 'chat':
        final flightId = data['flight_id'];
        Get.toNamed('/chat', arguments: flightId);
        break;

      case 'flight_update':
        final flightId = data['flight_id'];
        Get.toNamed('/flight-details', arguments: flightId);
        break;

      case 'my_custom_type':
        // Add your custom navigation
        Get.toNamed('/custom-screen');
        break;
    }
  }
}
```

## Backend Integration

### Send Token to Server

Update the `_getFCMToken` method in `notification_service.dart`:

```dart
Future<void> _getFCMToken() async {
  try {
    _fcmToken = await _firebaseMessaging.getToken();

    // Send to your backend
    await BaseService.instance.dio.post(
      '/api/save-fcm-token',
      data: {
        'token': _fcmToken,
        'user_id': DataStorageController.to.user.id,
      },
    );
  } catch (e) {
    debugPrint('Error: $e');
  }
}
```

## Testing Notifications

### Using Firebase Console:
1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Enter notification details
4. Select your app
5. Click "Send test message"
6. Enter your FCM token
7. Click "Test"

### Using CURL:
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "USER_FCM_TOKEN",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test"
    },
    "data": {
      "type": "chat",
      "flight_id": "123"
    }
  }'
```

## Notification States

### 1. Foreground
When app is open and active:
- Shows local notification
- Handles in `_handleForegroundMessage`

### 2. Background
When app is minimized:
- System tray notification shown automatically
- Tap handled in `FirebaseMessaging.onMessageOpenedApp`

### 3. Terminated
When app is completely closed:
- System tray notification shown automatically
- Tap handled via `getInitialMessage()`

## Permissions

### Android
Permissions are automatically requested on Android 13+

### iOS
Permissions are requested with these settings:
- Alert: ✅
- Badge: ✅
- Sound: ✅
- Provisional: ❌
- Critical Alert: ❌

## Platform-Specific Configuration

### Android (already configured)
- High importance notification channel
- Custom notification icon: `@mipmap/ic_launcher`
- Vibration & sound enabled

### iOS (already configured)
- Alert, badge, and sound permissions
- Background modes enabled

## Troubleshooting

### Token is null
```dart
// Force refresh token
await FirebaseMessaging.instance.deleteToken();
await NotificationService.instance.initialize();
```

### Notifications not showing
1. Check permissions are granted
2. Verify FCM token exists
3. Check Firebase Console logs
4. Ensure notification payload is correct

### Navigation not working
1. Verify `data` payload contains correct fields
2. Update `_navigateBasedOnData` method
3. Check route names match your app routes

## Best Practices

1. **Subscribe to topics based on user role**
   ```dart
   if (user.isStaff) {
     await NotificationService.instance.subscribeToTopic('staff_updates');
   }
   ```

2. **Clear notifications when user views content**
   ```dart
   await NotificationService.instance.cancelAllNotifications();
   ```

3. **Update token on user login/logout**
   ```dart
   // On login
   await NotificationService.instance.initialize();

   // On logout
   await NotificationService.instance.cancelAllNotifications();
   ```

4. **Handle expired tokens**
   ```dart
   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
     // Send to backend
   });
   ```

## Example: Complete Flow

```dart
// 1. User logs in
await NotificationService.instance.initialize();
final token = NotificationService.instance.fcmToken;
// Send token to backend

// 2. Subscribe to relevant topics
await NotificationService.instance.subscribeToTopic('flight_${userAirport}');

// 3. Backend sends notification
// { "type": "chat", "flight_id": "123" }

// 4. User taps notification
// App opens → navigates to chat screen with flight_id=123

// 5. User logs out
await NotificationService.instance.cancelAllNotifications();
await NotificationService.instance.unsubscribeFromTopic('flight_${userAirport}');
```

## Support

For issues or questions, check:
- [Firebase Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
