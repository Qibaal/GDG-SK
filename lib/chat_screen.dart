import 'package:gemexplora/chat_history.dart'; 
import 'package:gemexplora/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemexplora/providers/auth_provider.dart';

var logger = Logger();
class GemExploraApp extends StatelessWidget {
  const GemExploraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GemExplora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF48CAE4),
          secondary: const Color(0xFF90E0EF),
          tertiary: const Color(0xFFADE8F4),
          background: const Color(0xFFF1FAFE),
          surface: const Color(0xFFE0F7FA),
          onBackground: Colors.black,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1FAFE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFADE8F4),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF90E0EF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF48CAE4), width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFADE8F4).withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF48CAE4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF48CAE4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF48CAE4), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: TextStyle(color: const Color(0xFF90E0EF).withOpacity(0.7)),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: const Color(0xFF858C95),
          unselectedLabelColor: const Color(0xFF48CAE4),
          
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF48CAE4), Color(0xFF90E0EF)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          dividerColor: Colors.transparent,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Color(0xFF48CAE4)),
        ),
      ),
      home: const ChatScreen(),
    );
  }
}

// Future<void> saveToHistory(String query) async {
//   if (kIsWeb) {
//     // Log or simulate saving
//     print("Simulated saving query on web: $query");
//     return;
//   }

//   // Mobile or desktop platforms
//   final dir = await getApplicationDocumentsDirectory();
//   final file = File('${dir.path}/history_dummy.json');

//   if (!await file.exists()) {
//     await file.writeAsString(json.encode({'history': []}));
//   }

//   final jsonStr = await file.readAsString();
//   final data = json.decode(jsonStr);
//   final history = List<Map<String, dynamic>>.from(data['history']);

//   history.insert(0, {
//     "id": "h${DateTime.now().millisecondsSinceEpoch}",
//     "type": "query",
//     "refId": "custom",
//     "query": query,
//     "timestamp": DateTime.now().toIso8601String(),
//   });

//   await file.writeAsString(json.encode({"history": history}));
// }

Future<void> saveToHistory(String query, String userId, String token) async {
  final url = Uri.parse('http://localhost:8080/save-query');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'userId': userId,
      'query': query,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to save query history');
  }
}

// Home Screen Widget
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      logger.i('TOKEN in ChatScreen: ${authProvider.token}');
      logger.i('USER in ChatScreen: ${authProvider.user?.toJson()}');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF48CAE4), Color(0xFFADE8F4)],
                  ),
                ),
              ),
            ),
            NestedScrollView(
              floatHeaderSlivers: false,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: const Color(0xFF48CAE4),
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    forceElevated: innerBoxIsScrolled,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(300),
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome back, Traveler',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Where would you like to explore today?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF858C95),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSearchBar(),
                                  const SizedBox(height: 16),
                                  _buildChatHistoryPreview(),
                                ],
                              ),
                            ),
                            _buildTabBar(),
                          ],
                        ),
                      ),
                    
                  ),
                ];
              },
              body: ClipRect(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTrendingTab(),
                    _buildFoodTab(),
                    _buildStaysTab(),
                    _buildEventsTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Stack(
      children: [
        TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search destinations, experiences...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF858C95)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onSubmitted: (value) async {
            final query = value.trim();
            if (query.isEmpty) return;

            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final token = authProvider.token;

            if (token == null) {
              logger.e('No token found. User must log in.');
              return;
            }

            try {
              final uri = Uri.parse('http://localhost:8080/search-handler');
              final response = await http.post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({
                  'origin': 'Indonesia',
                  'prompt': query,
                }),
              );

              if (response.statusCode == 200) {
                final responseData = jsonDecode(response.body);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchResultPage(travelQuery: query, resultData: responseData),
                  ),
                );
              } else {
                logger.e('Request failed: ${response.body}');
              }
            } catch (e) {
              logger.e('Error sending query: $e');
            }
          }
        ),
        Positioned(
          right: 4,
          top: 4,
          bottom: 4,
          child: ElevatedButton(
            onPressed: () async {
              final query = _searchController.text.trim();
              if (query.isNotEmpty) {
                try {
                  final token = Provider.of<AuthProvider>(context, listen: false).token;
                  final url = Uri.parse('${dotenv.env['API_BASE_URL']}/query-response?query=$query');

                  final response = await http.get(
                    url,
                    headers: {'Authorization': 'Bearer $token'},
                  );

                  if (response.statusCode == 200) {
                    final result = jsonDecode(response.body);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultPage(
                          travelQuery: query,
                          resultData: result,
                        ),
                      ),
                    );
                  } else {
                    logger.e('API failed: ${response.statusCode} - ${response.body}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to load results')),
                    );
                  }
                } catch (e) {
                  logger.e('Error during fetch: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('An error occurred')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: const Color(0xFF48CAE4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 16, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  'Discover',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatHistoryPreview() {
    final recentPlaces = ['Bali, Indonesia', 'Tokyo, Japan', 'Paris, France', 'Bangkok, Thailand', 'Rome, Italy'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🕘 Recent Conversations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: recentPlaces.map((place) {
            return ElevatedButton(
              onPressed: () {
                // Navigate to detailed chat history (for now link to dummy page)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatHistoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: const Color(0xFFADE8F4),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(place),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // ✅ Remove default vertical padding
            minimumSize: Size.zero,   // ✅ Optional: prevent expansion
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatHistoryPage()),
            );
          },
          child: const Text('See more →'),
        )
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF858C95).withOpacity(0.3),
          border: Border.all(color: const Color(0xFF858C95)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: double.infinity, // ✅ ensures no wrap overflow
          child: TabBar(
            labelColor: Colors.black,              
            unselectedLabelColor: const Color.fromARGB(221, 2, 30, 100),
            controller: _tabController,
            isScrollable: false, // ✅ or true if you want scrollable tabs
            tabs: const [
              Tab(icon: Icon(Icons.trending_up), text: 'Trending'),
              Tab(icon: Icon(Icons.restaurant), text: 'Food'),
              Tab(icon: Icon(Icons.hotel), text: 'Stays'),
              Tab(icon: Icon(Icons.event), text: 'Events'),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF48CAE4), Color(0xFFADE8F4)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 24),
          _buildCategorySection(
            '✨ Trending Now',
            'Popular destinations travelers are loving',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?bali',
                'Bali, Indonesia',
                'Island Paradise',
                4.8,
                ['Beach', 'Culture', 'Relaxation'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?kyoto',
                'Kyoto, Japan',
                'Historic City',
                4.9,
                ['Temples', 'Gardens', 'Tradition'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?santorini',
                'Santorini, Greece',
                'Aegean Sea',
                4.7,
                ['Views', 'Romance', 'Cuisine'],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            '👨‍👩‍👧‍👦 Family Adventures',
            'Perfect for kids and parents',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?orlando',
                'Orlando, USA',
                'Theme Park Capital',
                4.6,
                ['Parks', 'Entertainment', 'Fun'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?tokyo',
                'Tokyo, Japan',
                'Modern Metropolis',
                4.7,
                ['Disney', 'Technology', 'Culture'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?london',
                'London, UK',
                'Historic Capital',
                4.5,
                ['Museums', 'Parks', 'History'],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            '💰 Budget-Friendly Gems',
            'Amazing experiences that won\'t break the bank',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?chiangmai',
                'Chiang Mai, Thailand',
                'Northern Thailand',
                4.6,
                ['Affordable', 'Culture', 'Food'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?lisbon',
                'Lisbon, Portugal',
                'Coastal Capital',
                4.7,
                ['Value', 'History', 'Cuisine'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?mexicocity',
                'Mexico City, Mexico',
                'Historic Metropolis',
                4.5,
                ['Affordable', 'Culture', 'Food'],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            '💎 Hidden Treasures',
            'Off-the-beaten-path destinations',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?faroeislands',
                'Faroe Islands',
                'North Atlantic',
                4.9,
                ['Nature', 'Secluded', 'Scenic'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?ljubljana',
                'Ljubljana, Slovenia',
                'Central Europe',
                4.7,
                ['Charming', 'Green', 'Compact'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?luangprabang',
                'Luang Prabang, Laos',
                'Southeast Asia',
                4.8,
                ['Temples', 'Peaceful', 'Nature'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF48CAE4), Color(0xFFADE8F4)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 24),
          _buildCategorySection(
            '🍽️ Culinary Destinations',
            'Cities known for exceptional cuisine',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?tokyofood',
                'Tokyo, Japan',
                'Culinary Capital',
                4.9,
                ['Sushi', 'Ramen', 'Street Food'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?lyonfood',
                'Lyon, France',
                'Gastronomic Center',
                4.8,
                ['Fine Dining', 'Wine', 'Tradition'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?bangkokfood',
                'Bangkok, Thailand',
                'Street Food Paradise',
                4.7,
                ['Spicy', 'Markets', 'Variety'],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            '🍷 Wine Regions',
            'Destinations for wine enthusiasts',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?bordeaux',
                'Bordeaux, France',
                'Wine Country',
                4.9,
                ['Wine Tours', 'Vineyards', 'Tasting'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?tuscany',
                'Tuscany, Italy',
                'Italian Wine Region',
                4.8,
                ['Chianti', 'Countryside', 'Cuisine'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?napavalley',
                'Napa Valley, USA',
                'California Wine Country',
                4.7,
                ['Wineries', 'Tours', 'Gourmet'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaysTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF48CAE4), Color(0xFFADE8F4)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 24),
          _buildCategorySection(
            '🏨 Unique Accommodations',
            'One-of-a-kind places to stay',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?treehouse',
                'Treehouse Lodge',
                'Amazon, Peru',
                4.8,
                ['Unique', 'Nature', 'Adventure'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?icehotel',
                'Ice Hotel',
                'Jukkasjärvi, Sweden',
                4.7,
                ['Winter', 'Unique', 'Experience'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?underwater',
                'Underwater Suite',
                'Maldives',
                4.9,
                ['Luxury', 'Marine', 'Exclusive'],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            '🏝️ Overwater Bungalows',
            'Luxurious stays above crystal waters',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?borabora',
                'Bora Bora',
                'French Polynesia',
                4.9,
                ['Luxury', 'Romance', 'Views'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?maldives',
                'Maldives',
                'Indian Ocean',
                4.8,
                ['Private', 'Beaches', 'Snorkeling'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?fiji',
                'Fiji',
                'South Pacific',
                4.7,
                ['Island', 'Culture', 'Relaxation'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF48CAE4), Color(0xFFADE8F4)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 24),
          _buildCategorySection(
            '🎭 Cultural Festivals',
            'Celebrations around the world',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?carnival',
                'Carnival',
                'Rio de Janeiro, Brazil',
                4.9,
                ['Festival', 'Music', 'Dance'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?diwali',
                'Diwali',
                'India',
                4.8,
                ['Lights', 'Celebration', 'Culture'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?oktoberfest',
                'Oktoberfest',
                'Munich, Germany',
                4.7,
                ['Beer', 'Food', 'Tradition'],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            '🎵 Music Festivals',
            'Unforgettable musical experiences',
            [
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?coachella',
                'Coachella',
                'California, USA',
                4.7,
                ['Music', 'Art', 'Fashion'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?glastonbury',
                'Glastonbury',
                'Somerset, UK',
                4.8,
                ['Music', 'Camping', 'Culture'],
              ),
              _buildDestinationCard(
                'https://source.unsplash.com/random/300x200/?tomorrowland',
                'Tomorrowland',
                'Boom, Belgium',
                4.9,
                ['EDM', 'Production', 'International'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build a category section
  Widget _buildCategorySection(String title, String description, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF858C95),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a destination card
  Widget _buildDestinationCard(
    String imageUrl,
    String title,
    String location,
    double rating,
    List<String> tags,
  ) {
    return Container(
  width: 280,
  margin: const EdgeInsets.only(right: 16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF858C95).withOpacity(0.7),
        const Color(0xFF90E0EF).withOpacity(0.7),
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.black), // MODIFIED: border changed to black
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF48CAE4).withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF858C95),
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Color(0xFF858C95)),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFF858C95),
                    child: const Center(
                      child: CircularProgressIndicator(color: Color(0xFF858C95)),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.black, // already black, keep
                    ),
                    const SizedBox(width: 2),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // already black, keep
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: Color(0xFF666666), // MODIFIED: darker grey icon
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666), // MODIFIED: darker grey text
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.transparent, // MODIFIED: no fill
                      border: Border.all(color: Colors.grey), // MODIFIED: grey border
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54, // MODIFIED: lighter black text
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

  }
}

// Firebase Service
class FirebaseService {
  // This would normally connect to Firebase
  // For this example, we're just providing the structure
  
  static Future<void> initialize() async {
    // Initialize Firebase
    logger.i('Firebase initialized');
  }

  static Future<Map<String, dynamic>?> signInWithEmail(String email, String password) async {
    // Simulate authentication
    await Future.delayed(const Duration(seconds: 1));
    return {
      'uid': 'user123',
      'email': email,
      'displayName': 'Traveler',
    };
  }

  static Future<void> signOut() async {
    // Simulate sign out
    await Future.delayed(const Duration(milliseconds: 500));
    logger.i('User signed out');
  }

  static Future<List<Map<String, dynamic>>> getDestinations() async {
    // Simulate fetching destinations from Firestore
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': 'dest1',
        'title': 'Bali, Indonesia',
        'location': 'Island Paradise',
        'rating': 4.8,
        'tags': ['Beach', 'Culture', 'Relaxation'],
        'imageUrl': 'https://source.unsplash.com/random/300x200/?bali',
      },
      {
        'id': 'dest2',
        'title': 'Kyoto, Japan',
        'location': 'Historic City',
        'rating': 4.9,
        'tags': ['Temples', 'Gardens', 'Tradition'],
        'imageUrl': 'https://source.unsplash.com/random/300x200/?kyoto',
      },
      // More destinations would be here
    ];
  }

  static Future<Map<String, dynamic>?> getDestinationDetails(String destinationId) async {
    // Simulate fetching destination details
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': destinationId,
      'title': 'Bali, Indonesia',
      'location': 'Island Paradise',
      'description': 'Bali is a living postcard, an Indonesian paradise that feels like a fantasy.',
      'rating': 4.8,
      'tags': ['Beach', 'Culture', 'Relaxation'],
      'imageUrl': 'https://source.unsplash.com/random/600x400/?bali',
      'attractions': [
        'Ubud Monkey Forest',
        'Tanah Lot Temple',
        'Tegallalang Rice Terraces',
      ],
      'hotels': [
        {
          'name': 'Four Seasons Resort Bali',
          'rating': 5.0,
          'priceRange': '\$\$\$\$',
        },
        {
          'name': 'Padma Resort Ubud',
          'rating': 4.7,
          'priceRange': '\$\$\$',
        },
      ],
      'restaurants': [
        {
          'name': 'Locavore',
          'cuisine': 'Contemporary',
          'rating': 4.8,
        },
        {
          'name': 'Warung Babi Guling Ibu Oka',
          'cuisine': 'Balinese',
          'rating': 4.6,
        },
      ],
    };
  }

  static Future<void> saveUserPreferences(String userId, Map<String, dynamic> preferences) async {
    // Simulate saving user preferences
    await Future.delayed(const Duration(milliseconds: 500));
    logger.i('Saved preferences for user $userId: $preferences');
  }
}

// Gemini AI Service
class GeminiService {
  final String apiKey;
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  final String model = 'gemini-pro';

  GeminiService({required this.apiKey});

  Future<String> generateResponse(String prompt) async {
    try {
      // In a real app, this would make an actual API call to Google's Gemini API
      // For this example, we're simulating the response
      
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate different responses based on prompt keywords
      if (prompt.toLowerCase().contains('bali')) {
        return 'Bali is a beautiful Indonesian island known for its lush landscapes, vibrant culture, and stunning beaches. The best time to visit is during the dry season (April to October). Don\'t miss the sacred Monkey Forest, Tanah Lot temple, and the rice terraces of Tegallalang.';
      } else if (prompt.toLowerCase().contains('food') || prompt.toLowerCase().contains('cuisine')) {
        return 'For amazing culinary experiences, I recommend Tokyo (Japan), Bangkok (Thailand), and Lyon (France). Each offers unique flavors and dining traditions. In Tokyo, try sushi at Tsukiji Market. Bangkok street food scene is unmatched - visit Chinatown for the best experience. Lyon is considered France gastronomic capital with traditional bouchons serving local specialties.';
      } else if (prompt.toLowerCase().contains('budget') || prompt.toLowerCase().contains('cheap')) {
        return 'For budget-friendly travel, consider Southeast Asia (Thailand, Vietnam, Indonesia), Eastern Europe (Hungary, Poland, Romania), or Latin America (Mexico, Colombia, Peru). These destinations offer great value with affordable accommodations, food, and activities while providing rich cultural experiences.';
      } else {
        return 'I\'d be happy to help you plan your perfect trip! I can provide recommendations for destinations, accommodations, activities, and local cuisine based on your preferences. Just let me know what you\'re interested in exploring!';
      }
    } catch (e) {
      logger.i('Exception: $e');
      return 'Sorry, I encountered an error. Please try again later.';
    }
  }

  Future<List<Map<String, dynamic>>> getDestinationRecommendations(
      String userPreferences, int limit) async {
    try {
      // Simulate AI-generated recommendations
      await Future.delayed(const Duration(seconds: 1));
      
      // This would normally call the Gemini API and parse the response
      return [
        {
          "title": "Kyoto, Japan",
          "location": "Kansai Region, Japan",
          "description": "Ancient capital with over 1,600 Buddhist temples and 400 Shinto shrines",
          "rating": 4.9,
          "tags": ["Culture", "History", "Temples"],
          "highlights": ["Fushimi Inari Shrine", "Arashiyama Bamboo Grove", "Kinkaku-ji"]
        },
        {
          "title": "Porto, Portugal",
          "location": "Northern Portugal",
          "description": "Coastal city known for port wine, stunning bridges and colorful historic center",
          "rating": 4.7,
          "tags": ["Wine", "Architecture", "Affordable"],
          "highlights": ["Ribeira District", "Port Wine Cellars", "Dom Luís I Bridge"]
        },
        {
          "title": "Chiang Mai, Thailand",
          "location": "Northern Thailand",
          "description": "Cultural hub with ancient temples, night markets and mountain scenery",
          "rating": 4.8,
          "tags": ["Budget", "Culture", "Food"],
          "highlights": ["Sunday Night Market", "Doi Suthep", "Elephant Sanctuaries"]
        }
      ];
    } catch (e) {
      logger.i('Exception in getDestinationRecommendations: $e');
      return [];
    }
  }
}
