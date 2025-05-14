import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:gemexplora/providers/auth_provider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//     );
    
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Travel Search Results',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'Poppins',
//         scaffoldBackgroundColor: Colors.black,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.black,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       home: const SearchResultPage(),
//     );
//   }
// }

class SearchResultPage extends StatefulWidget {
  final String travelQuery;
  final Map<String, dynamic> resultData;

  const SearchResultPage({
    super.key,
    required this.travelQuery,
    required this.resultData,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _geminiResult;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() async {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final token = auth.token;

      if (token != null) {
        await loadGeminiResponse(widget.travelQuery, token);
      } else {
        setState(() {
          _error = "No token found";
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildAnswerBox(),
                  _buildDestinationDetails(),
                ],
              ),
            ),
            SliverFillRemaining(
              child: _buildTabView(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadGeminiResponse(String query, String token) async {
    final url = Uri.parse('http://localhost:8080/query-response?query=$query');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _geminiResult = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch Gemini response';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      title: const Text('Travel Search'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildAnswerBox() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08*255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF1A73E8),
                child: Icon(Icons.travel_explore, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Travel Query',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _geminiResult?['firstResponse'] ??
                          'Loading travel insights...',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Based on your location (Jakarta) and preferences, here are our recommendations for your trip to West Papua:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha((0.05*255).toInt()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.withAlpha((0.2*255).toInt()),
              ),
            ),
            child: const Text(
              'Raja Ampat is known for its stunning marine biodiversity, crystal clear waters, and pristine beaches. It\'s perfect for diving and snorkeling enthusiasts but requires careful planning due to its remote location.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationDetails() {
    
    bool isBudgetLow = true; // Budget is less than required
    bool isTimeConstraint = true; // Duration is tight

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08*255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200/200?random=1'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Raja Ampat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Papua, Southwest Papua',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Show budget suggestions
                  },
                  child: _buildInfoCard(
                    title: 'Budget',
                    value: '50M IDR',
                    subtitle: 'Required: 75M IDR',
                    icon: Icons.account_balance_wallet,
                    valueColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Show duration suggestions
                  },
                  child: _buildInfoCard(
                    title: 'Duration',
                    value: '3 Days',
                    subtitle: 'Recommended: 5+ Days',
                    icon: Icons.calendar_today,
                    valueColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Weather',
                  value: '27°C',
                  subtitle: 'Partly Cloudy',
                  icon: Icons.wb_sunny,
                  isPremium: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  title: 'Crime Index',
                  value: 'Low',
                  subtitle: 'Safe for tourists',
                  icon: Icons.security,
                  valueColor: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Navigate to visa information
                  },
                  child: _buildInfoCard(
                    title: 'Visa',
                    value: 'Required',
                    subtitle: 'For most countries',
                    icon: Icons.credit_card,
                    valueColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  title: 'Language',
                  value: 'Bahasa',
                  subtitle: 'English less common',
                  icon: Icons.translate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Health',
                  value: 'Vaccines',
                  subtitle: 'Malaria prevention advised',
                  icon: Icons.health_and_safety,
                  valueColor: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  title: 'Events',
                  value: 'Festival',
                  subtitle: 'Raja Ampat Sea Festival',
                  icon: Icons.event_available,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    Color? valueColor,
    bool isPremium = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha((0.05*255).toInt()),
        borderRadius: BorderRadius.circular(12),
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (isPremium) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.star,
                  size: 12,
                  color: Color(0xFFFFD700),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  

  Widget _buildTabView() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2.5,
              color: Theme.of(context).colorScheme.primary,
            ),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
          indicatorSize: TabBarIndicatorSize.tab, 
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Hotels'),
            Tab(text: 'Food'),
            Tab(text: 'Attractions'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildHotelList(),
              _buildFoodList(),
              _buildAttractionsList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHotelList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildRecommendationCard(
          imageUrl: 'https://picsum.photos/300/200?random=${10 + index}',
          title: 'Papua Paradise Eco Resort',
          rating: 4.8,
          price: 'IDR 3,500,000/night',
          tagLine: 'Luxury | Beachfront | Free Breakfast',
          featureList: const [
            'Private beach access',
            'Diving center',
            'Infinity pool'
          ],
        );
      },
    );
  }

  Widget _buildFoodList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        List<String> restaurants = [
          'Coco Beach Restaurant',
          'Kali Seafood',
          'Warung Papua',
          'Blue Paradise',
          'Sago Delights',
        ];
        
        List<String> cuisines = [
          'Seafood | Local',
          'Fresh Fish | BBQ',
          'Traditional | Budget-friendly',
          'International | Fusion',
          'Desserts | Coffee',
        ];
        
        List<List<String>> features = [
          ['Beachfront dining', 'Fresh catch daily', 'Sunset views'],
          ['Local recipes', 'Family-owned', 'Authentic dishes'],
          ['Budget meals', 'Home cooking', 'Local specialties'],
          ['Fusion cuisine', 'Cocktail bar', 'Live music'],
          ['Traditional sweets', 'Artisan coffee', 'Vegan options'],
        ];
        
        return _buildRecommendationCard(
          imageUrl: 'https://picsum.photos/300/200?random=${20 + index}',
          title: restaurants[index],
          rating: 4.5 - (index * 0.1),
          price: '${index + 1}\$\$ • 15-30 mins',
          tagLine: cuisines[index],
          featureList: features[index],
        );
      },
    );
  }

  Widget _buildAttractionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        List<String> attractions = [
          'Piaynemo Viewpoint',
          'Kabui Bay',
          'Misool Island',
          'Wayag Island',
          'Blue River',
        ];
        
        List<String> types = [
          'Natural Landmark | Photography',
          'Hidden Bay | Boat Tour',
          'Marine Reserve | Diving',
          'Island Tour | Hiking',
          'Eco Tour | Swimming',
        ];
        
        List<List<String>> features = [
          ['Iconic viewpoint', 'Island hopping', 'Sunset spot'],
          ['Limestone cliffs', 'Clear waters', 'Cave exploration'],
          ['Marine diversity', 'Coral reefs', 'Beach camping'],
          ['Pristine beaches', 'Lagoons', 'Rock islands'],
          ['Natural pools', 'Jungle trek', 'Bird watching'],
        ];
        
        return _buildRecommendationCard(
          imageUrl: 'https://picsum.photos/300/200?random=${30 + index}',
          title: attractions[index],
          rating: 4.9 - (index * 0.1),
          price: index == 0 ? 'Premium Entry' : 'IDR ${(index + 1) * 50},000',
          tagLine: types[index],
          featureList: features[index],
        );
      },
    );
  }

  Widget _buildRecommendationCard({
    required String imageUrl,
    required String title,
    required double rating,
    required String price,
    required String tagLine,
    required List<String> featureList,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05*255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFD700),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A73E8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tagLine,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: featureList.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha((0.1*255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_location_alt_outlined,
                        size: 18,
                      ),
                      label: const Text('Map'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}