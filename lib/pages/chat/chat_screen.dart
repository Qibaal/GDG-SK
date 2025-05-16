import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'search_bar.dart';
import 'chat_history_preview.dart';
import 'tabbar/trending_tab.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
  with SingleTickerProviderStateMixin {
  String? _origin;

  @override
  void initState() {
    super.initState();
    _initOrigin();

    // Log token & origin once at startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      debugPrint('TOKEN in ChatScreen: ${auth.token}');
      debugPrint('Origin in ChatScreen: $_origin');
    });
  }

  Future<void> _initOrigin() async {
    // 1️⃣ Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint('🌐 Location service enabled: $serviceEnabled');
    if (!serviceEnabled) {
      debugPrint('⚠️ Location services are OFF');
      setState(() => _origin = 'Location services disabled');
      return;
    }

    // 2️⃣ Check & request permissions
    var permission = await Geolocator.checkPermission();
    debugPrint('🔑 Initial permission status: $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      debugPrint('🔑 After request permission status: $permission');
      if (permission == LocationPermission.denied) {
        debugPrint('⛔ Permission denied by user');
        setState(() => _origin = 'Location permission denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint('⛔ Permission permanently denied (deniedForever)');
      setState(() => _origin = 'Location permission permanently denied');
      return;
    }

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
      String resolved;
      if (placemarks != null && placemarks.isNotEmpty) {
        final p = placemarks.first;
        debugPrint('➡️ Placemark fields: '
          'locality=${p.locality}, '
          'subLocality=${p.subLocality}, '
          'adminArea=${p.administrativeArea}, '
          'name=${p.name}'
        );

        resolved = p.locality
            ?? p.subLocality
            ?? p.administrativeArea
            ?? p.name
            ?? 'Unknown Location';
      } else {
        // fallback to coords if no placemark
        resolved = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
        debugPrint('⚠️ No placemark — using coords fallback: $resolved');
      }

      // 6️⃣ Update state
      setState(() => _origin = resolved);
      debugPrint('✅ Origin resolved: $_origin');
    } catch (e, stack) {
      debugPrint('❌ Unexpected error in _initOrigin(): $e');
      debugPrint('🔍 Stack:\n$stack');
      setState(() => _origin = 'Unknown Location');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    final email = user?.email ?? 'Unknown';
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF48CAE4), Color(0xFFADE8F4)],
              ),
            ),
          ),

          // Main content with sliver header and tabs
          NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 320,

                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: kToolbarHeight),
                        Text(
                          'Welcome back, Traveler',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Where would you like to explore today?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF858C95),
                          ),
                        ),
                        SizedBox(height: 16),
                        SearchBar(origin: _origin!),
                        SizedBox(height: 16),
                        ChatHistoryPreview(email: email),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: const TrendingTab(),
          ),
        ]),
      ),
    );
  }
}
