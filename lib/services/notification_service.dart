import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // 1. Inisialisasi Notifikasi (Minta Izin & Ambil Token)
  Future<void> initNotifications() async {
    // Minta izin (Wajib untuk iOS dan Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Izin notifikasi diberikan: ${settings.authorizationStatus}');
      
      // Ambil FCM Token (Ini seperti "Alamat Rumah" HP kamu di dunia maya)
      // Token ini yang nanti kamu copy-paste ke Firebase Console untuk tes kirim.
      final fcmToken = await _firebaseMessaging.getToken();
      debugPrint('=======================================');
      debugPrint('FCM TOKEN (COPY INI): $fcmToken');
      debugPrint('=======================================');
    } else {
      debugPrint('Izin notifikasi ditolak');
    }

    // Listener saat aplikasi dibuka (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Pesan diterima saat app dibuka: ${message.notification?.title}');
      // Di sini kita bisa memunculkan Dialog atau Snackbar nanti di UI
    });
  }
}