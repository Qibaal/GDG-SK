import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class GeoService {
  static Future<String> resolveOrigin() async {
    // 1️⃣ Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint('🌐 Location service enabled: $serviceEnabled');
    if (!serviceEnabled) return 'Location services disabled';

    // 2️⃣ Check & request permissions
    var permission = await Geolocator.checkPermission();
    debugPrint('🔑 Initial permission status: $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      debugPrint('🔑 After request permission status: $permission');
      if (permission == LocationPermission.denied) return 'Location permission denied';
    }
    if (permission == LocationPermission.deniedForever) return 'Location permission permanently denied';

    try {
      // 3️⃣ Get GPS coordinates
      final pos = await Geolocator.getCurrentPosition();
      debugPrint('📍 Got position: ${pos.latitude}, ${pos.longitude}');

      // 4️⃣ Reverse geocode with its own try/catch
      List<Placemark>? placemarks;
      try {
        placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        debugPrint('🔄 Reverse-geocode returned ${placemarks.length} placemark(s)');
      } catch (geoErr, geoStack) {
        debugPrint('⚠️ Geocoding error: $geoErr');
        debugPrint('🔍 Geocoding stack:\n$geoStack');
        placemarks = null;
      }

      // 5️⃣ Decide on final origin string
      if (placemarks != null && placemarks.isNotEmpty) {
        final p = placemarks.first;
        return p.locality ??
            p.subLocality ??
            p.administrativeArea ??
            p.name ??
            'Unknown Location';
      } else {
        return '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      }
    } catch (e, stack) {
      debugPrint('❌ Unexpected error in resolveOrigin(): $e');
      debugPrint('🔍 Stack:\n$stack');
      return 'Unknown Location';
    }
  }
}
