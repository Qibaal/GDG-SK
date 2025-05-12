import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const GemExploraApp());
}
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
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF14B8A6),
          secondary: const Color(0xFF10B981),
          tertiary: const Color(0xFFF59E0B),
          background: const Color(0xFF042F2E),
          surface: const Color(0xFF134E4A),
          onBackground: Colors.white,
          onSurface: Colors.white,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF042F2E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF042F2E),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF115E59),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF0F766E), width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF115E59).withAlpha((0.5*255).toInt()),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF0F766E)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF0F766E)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: TextStyle(color: const Color(0xFF5EEAD4).withAlpha((0.7*255).toInt())),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: const Color(0xFF042F2E),
          unselectedLabelColor: const Color(0xFF5EEAD4),
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF14B8A6), Color(0xFF10B981)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          dividerColor: Colors.transparent,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFF5EEAD4)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Home Screen Widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF042F2E),
                    const Color(0xFF022C22),
                  ],
                ),
              ),
            ),
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: const Color(0xFF042F2E).withAlpha((0.8*255).toInt()),
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    title: Row(
                      children: [
                        _buildLogo(),
                        const SizedBox(width: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF5EEAD4), Color(0xFF6EE7B7), Color(0xFFFCD34D)],
                          ).createShader(bounds),
                          child: const Text(
                            'GemExplora',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.explore, color: Color(0xFF5EEAD4)),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF0D9488),
                        radius: 18,
                        child: const Text(
                          'FV',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(220),
                      child: Column(
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
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Where would you like to explore today?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF5EEAD4),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildSearchBar(),
                                const SizedBox(height: 16),
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
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildTrendingTab(),
                  _buildFoodTab(),
                  _buildStaysTab(),
                  _buildEventsTab(),
                ],
              ),
            ),
            const Positioned(
              bottom: 24,
              right: 24,
              child: AiAssistantButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 8,
            child: Transform.rotate(
              angle: 0.8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFF14B8A6),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 4,
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Stack(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search destinations, experiences...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF5EEAD4)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          bottom: 4,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: const Color(0xFF042F2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 16),
                SizedBox(width: 4),
                Text(
                  'Discover',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF115E59).withAlpha((0.3*255).toInt()),
        border: Border.all(color: const Color(0xFF115E59)),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, size: 16),
                SizedBox(width: 4),
                Text('Trending'),
              ],
            ),
          ),
          Tab(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.restaurant, size: 16),
                SizedBox(width: 4),
                Text('Food'),
              ],
            ),
          ),
          Tab(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hotel, size: 16),
                SizedBox(width: 4),
                Text('Stays'),
              ],
            ),
          ),
          Tab(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event, size: 16),
                SizedBox(width: 4),
                Text('Events'),
              ],
            ),
          ),
        ],
        padding: const EdgeInsets.all(4),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildTrendingTab() {
    return ListView(
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
    );
  }

  Widget _buildFoodTab() {
    return ListView(
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
    );
  }

  Widget _buildStaysTab() {
    return ListView(
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
    );
  }

  Widget _buildEventsTab() {
    return ListView(
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
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5EEAD4),
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
            const Color(0xFF115E59).withAlpha((0.7*255).toInt()),
            const Color(0xFF065F46).withAlpha((0.7*255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0F766E)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14B8A6).withAlpha((0.1*255).toInt()),
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
                        color: const Color(0xFF115E59),
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Color(0xFF5EEAD4)),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFF115E59),
                        child: const Center(
                          child: CircularProgressIndicator(color: Color(0xFF5EEAD4)),
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
                          color: Color(0xFF042F2E),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF042F2E),
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Color(0xFF5EEAD4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5EEAD4),
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
                          color: const Color(0xFF115E59).withAlpha((0.5*255).toInt()),
                          border: Border.all(color: const Color(0xFF0F766E)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5EEAD4),
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

// AI Assistant Button and Sheet
class AiAssistantButton extends StatelessWidget {
  const AiAssistantButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AiAssistantSheet(),
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF14B8A6), Color(0xFF10B981)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF042F2E).withAlpha((0.3*255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.auto_awesome,
            color: Color(0xFF042F2E),
            size: 24,
          ),
        ),
      ),
    );
  }
}

class AiAssistantSheet extends StatefulWidget {
  const AiAssistantSheet({super.key});

  @override
  State<AiAssistantSheet> createState() => _AiAssistantSheetState();
}

class _AiAssistantSheetState extends State<AiAssistantSheet> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi there! I'm your GemExplora AI assistant powered by Google Gemini. Ask me about destinations, travel tips, or recommendations!",
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text,
        isUser: true,
      ));
    });

    final userMessage = _messageController.text;
    _messageController.clear();

    // Simulate AI response (in a real app, this would call the Gemini API)
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: "I'd be happy to help you explore more about \"$userMessage\". Here's what I found.",
            isUser: false,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF042F2E), Color(0xFF022C22)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: const Color(0xFF0F766E)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF0F766E)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF14B8A6), Color(0xFF10B981)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF042F2E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Gemini Travel Assistant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF5EEAD4)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      reverse: false,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return Align(
          alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: message.isUser
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF115E59).withAlpha((0.5*255).toInt()),
              borderRadius: BorderRadius.circular(16),
              border: message.isUser
                  ? null
                  : Border.all(color: const Color(0xFF0F766E)),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? const Color(0xFF042F2E) : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF0F766E)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask about destinations, food, or activities...',
                hintStyle: TextStyle(color: const Color(0xFF5EEAD4).withAlpha((0.7*255).toInt())),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFF0F766E)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF042F2E)),
              onPressed: _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
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
