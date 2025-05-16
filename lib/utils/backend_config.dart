// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/foundation.dart';

// /// A utility class to provide backend URL configurations based on the platform and environment
// class BackendConfig {
//   /// Returns the appropriate backend base URL based on the current platform and device
//   static Future<String> getBackendBaseUrl() async {
//     // For web platform
//     if (kIsWeb) {
//       return 'http://localhost:8081';
//     }

//     // For Android platform
//     if (Platform.isAndroid) {
//       final deviceInfo = DeviceInfoPlugin();
//       final androidInfo = await deviceInfo.androidInfo;

//       // Different URL for emulator vs physical device
//       if (!androidInfo.isPhysicalDevice) {
//         return 'http://10.0.2.2:8081'; // Android emulator uses 10.0.2.2 to access host machine
//       } else {
//         return 'http://192.168.1.10:8081'; // Physical device needs actual IP address
//       }
//     }

//     // For iOS and other platforms
//     return 'http://localhost:8081';
//   }

//   /// Builds a complete URL by appending the endpoint to the base URL
//   static Future<Uri> buildUrl(String endpoint) async {
//     final baseUrl = await getBackendBaseUrl();
//     return Uri.parse('$baseUrl$endpoint');
//   }
// }