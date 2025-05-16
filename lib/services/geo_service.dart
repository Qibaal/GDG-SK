import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GeoService {
  static Future<String> resolveOrigin() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return 'Location services disabled';

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return 'Location permission denied';
    }
    if (permission == LocationPermission.deniedForever) return 'Location permission permanently denied';

    try {
      final pos = await Geolocator.getCurrentPosition();
      List<Placemark>? placemarks;
      try {
        placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      } catch (geoErr) {
        placemarks = null;
      }

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
    } catch (e) {
      return 'Unknown Location';
    }
  }
}
