import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:gemexplora/services/geo_service.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'search_bar.dart';
import 'chat_history_preview.dart';
import 'tabbar/trending_tab.dart';

class AppColors {
  static const lightPastelBlue = Color(0xFFE6F3FF);
  static const pastelBlueAccent = Color(0xFFBFE1FF);
  static const headerText = Color(0xFF2D3748);
  static const subtitleText = Color.fromARGB(92, 113, 128, 150);
  static const accentBlue = Color(0xFF63B3ED);
}

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

    // _fetchOrigin();
    _origin = 'Jakarta';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      debugPrint('TOKEN in ChatScreen: ${auth.token}');
      debugPrint('Origin in ChatScreen: $_origin');
    });
  }

  void _fetchOrigin() async {
    final result = await GeoService.resolveOrigin();
    if (!mounted) return;
    setState(() => _origin = result);
  }
  
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    final email = user?.email ?? 'Unknown';
    
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          // Background with soft pastel blue
          Container(
            decoration: const BoxDecoration(
              color: AppColors.lightPastelBlue,
            ),
          ),
          
          // Main content with sliver header and tabs
          NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                backgroundColor: innerBoxIsScrolled 
                    ? AppColors.lightPastelBlue
                    : Colors.transparent,
                elevation: innerBoxIsScrolled ? 2 : 0,
                expandedHeight: 370,
                
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.pastelBlueAccent,
                          AppColors.lightPastelBlue,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: kToolbarHeight),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Icon(
                                  Icons.explore_outlined,
                                  color: AppColors.accentBlue,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Welcome back, Traveler',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.headerText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              'Where would you like to explore today?',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(207, 13, 67, 148),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          SearchBar(origin: _origin!),
                          SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              'Recent Chats',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.headerText,
                              ),
                            ),
                          ),
                          ChatHistoryPreview(email: email),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Column( // 👈 ubah jadi Column
                  children: [
                    const Expanded(child: TrendingTab()),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final auth = context.read<AuthProvider>();
                          await auth.logout(); // Trigger AuthGate rebuild
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}