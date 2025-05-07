import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Smart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;
  final String _userName = "Sarah"; // Mock user name
  final String _userLocation = "Jakarta"; // Mock user location
  
  // Mock recent searches
  final List<Map<String, dynamic>> _recentSearches = [
    {
      'destination': 'Bali',
      'duration': '5 days',
      'budget': '35M IDR',
      'image': 'assets/bali.jpg',
    },
    {
      'destination': 'Lombok',
      'duration': '4 days',
      'budget': '28M IDR',
      'image': 'assets/lombok.jpg',
    },
    {
      'destination': 'Yogyakarta',
      'duration': '3 days',
      'budget': '15M IDR',
      'image': 'assets/yogyakarta.jpg',
    },
  ];

  final formatter = NumberFormat('#,###');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(),
            Expanded(
              child: _hasSearched ? _buildResultsSection() : _buildInitialContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_hasSearched) ...[
            const SizedBox(height: 12),
            Text(
              'Hello, $_userName!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Where to next? $_userLocation → ?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Where do you want to go? For how long? What's your budget?",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _hasSearched = true;
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  color: Colors.blue[700],
                  onPressed: () {
                    // Voice input functionality would go here
                  },
                ),
              ],
            ),
          ),
          if (_hasSearched) ...[
            const SizedBox(height: 16),
            _buildTransportModeToggles(),
            const SizedBox(height: 12),
            _buildFilterChips(),
          ]
        ],
      ),
    );
  }

  Widget _buildTransportModeToggles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _transportToggle(Icons.flight, 'Air', true),
        _transportToggle(Icons.directions_boat, 'Sea', false),
        _transportToggle(Icons.directions_car, 'Land', false),
      ],
    );
  }

  Widget _transportToggle(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.blue[700] : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue[700] : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip('Budget: 50M IDR', true),
          _filterChip('3 days', true),
          _filterChip('Leisure', true),
          _filterChip('Adventure', false),
          _filterChip('Business', false),
          _filterChip('Spiritual', false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue[700] : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 4),
            Icon(Icons.close, size: 14, color: Colors.blue[700]),
          ],
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final search = _recentSearches[index];
              return _buildRecentSearchCard(search);
            },
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recommended for You',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildRecommendationCard(
                'Raja Ampat',
                '75M IDR',
                '5 days',
                '4.9',
                'assets/raja_ampat.jpg',
                isTrending: true,
              ),
              _buildRecommendationCard(
                'Komodo Island',
                '45M IDR',
                '4 days',
                '4.7',
                'assets/komodo.jpg',
              ),
              _buildRecommendationCard(
                'Mount Bromo',
                '25M IDR',
                '3 days',
                '4.6',
                'assets/bromo.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchCard(Map<String, dynamic> search) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.05 * 255).roundToDouble()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.blueGrey,
              height: 140, // Mock background for image
              child: Center(
                child: Text(
                  search['destination'][0], // First letter as placeholder
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: (0.7 * 255).roundToDouble()),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    search['destination'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        search['duration'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        search['budget'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    String destination,
    String budget,
    String duration,
    String rating,
    String imagePath, {
    bool isTrending = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.05 * 255).roundToDouble()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.blueGrey.shade200, // Mock image background
                  child: Center(
                    child: Text(
                      destination[0], // First letter as placeholder
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (isTrending)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Trending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: (0.6 * 255).roundToDouble()),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
                  destination,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.account_balance_wallet, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      budget,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Explore',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border, color: Colors.grey[700]),
                      ),
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

  Widget _buildResultsSection() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildDestinationOverview(),
        _buildSmartInsightsPanel(),
        _buildSectionHeader("Hotels", "8 options available"),
        _buildHotelsSection(),
        _buildSectionHeader("Culinary", "12 options available"),
        _buildCulinarySection(),
        _buildSectionHeader("Activities", "15 options available"),
        _buildActivitiesSection(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDestinationOverview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.05 * 255).roundToDouble()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.blueGrey.shade300,
              child: const Center(
                child: Text(
                  "R",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Raja Ampat",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "4.9",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          " (2.4k)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "West Papua, Indonesia",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.flight_takeoff, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "6h from Jakarta",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Raja Ampat is known for its rich marine biodiversity, pristine beaches, and stunning landscapes, making it a perfect destination for diving enthusiasts and nature lovers.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildAlternateDestinationOption(
                        "Misool Island",
                        "Similar experience, 40M IDR",
                        Colors.green.shade50,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAlternateDestinationOption(
                        "Wakatobi",
                        "Similar experience, 45M IDR",
                        Colors.blue.shade50,
                        Colors.blue,
                      ),
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

  Widget _buildAlternateDestinationOption(
    String name,
    String description,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withValues(alpha: (0.3 * 255).roundToDouble())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withValues(alpha: (0.8 * 255).roundToDouble()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartInsightsPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.05 * 255).roundToDouble()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Insights",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInsightItem(
                  "Budget Match",
                  "50M IDR (Needs 75M)",
                  Colors.red,
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightItem(
                  "Duration Fit",
                  "3 Days (Barely fits)",
                  Colors.orange,
                  Icons.timer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInsightItem(
                  "Weather Forecast",
                  "Rain next 3 days",
                  Colors.blue,
                  Icons.wb_cloudy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightItem(
                  "Crime Index",
                  "2.1/5",
                  Colors.green,
                  Icons.security,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInsightItem(
                  "Visa Requirement",
                  "Allowed (Green)",
                  Colors.teal,
                  Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightItem(
                  "Health & Vaccines",
                  "Hep A, Malaria Shot",
                  Colors.purple,
                  Icons.medical_services_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber[800],
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart Recommendation",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[800],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Add 2 more days for a better experience & visit during dry season (Oct-Apr)",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber[900],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: (0.1* 255).roundToDouble()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: (0.3 * 255).roundToDouble())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: (0.8 * 255).roundToDouble()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelsSection() {
    return SizedBox(
      height: 220,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _buildHotelCard(
            'Papua Paradise Eco Resort',
            '★★★★',
            '4.8',
            '560',
            '12.5M IDR/night',
            specialTag: '🏆 Best Value',
          ),
          _buildHotelCard(
            'Misool Eco Resort',
            '★★★★★',
            '4.9',
            '320',
            '25M IDR/night',
            specialTag: '✨ Luxury',
          ),
          _buildHotelCard(
            'Raja Ampat Dive Lodge',
            '★★★',
            '4.6',
            '210',
            '8.2M IDR/night',
            specialTag: '💸 Budget Friendly',
          ),
          _buildHotelCard(
            'Meridian Adventure Dive Resort',
            '★★★★',
            '4.7',
            '180',
            '15M IDR/night',
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(
    String name,
    String stars,
    String rating,
    String reviews,
    String price, {
    String? specialTag,
  }) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.05 * 255).roundToDouble()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.blueGrey.shade100,
                  child: Center(
                    child: Icon(
                      Icons.hotel,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              if (specialTag != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      specialTag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      stars,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber[700],
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, size: 12, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "($reviews)",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCulinarySection() {
    return SizedBox(
      height: 180,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _buildCulinaryCard(
            "Papeda",
            "Traditional Papuan sago porridge",
            "25k IDR",
            "4.5",
            "120",
            specialTag: "💸 Aqua here = 10k!",
          ),
          _buildCulinaryCard(
            "Ikan Bakar Raja Ampat",
            "Grilled fish with special spices",
            "85k IDR",
            "4.7",
            "240",
            specialTag: "👨‍🍳 Must Try!",
          ),
          _buildCulinaryCard(
            "Ulat Sagu",
            "Traditional sago worm dish",
            "50k IDR",
            "4.2",
            "85",
            specialTag: "🏆 Authentic",
          ),
          _buildCulinaryCard(
            "Ikan Kuah Kuning",
            "Fish in yellow broth",
            "65k IDR",
            "4.6",
            "195",
          ),
        ],
      ),
    );
  }

  Widget _buildCulinaryCard(
    String name,
    String description,
    String price,
    String rating,
    String reviews, {
    String? specialTag,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.05 * 255).roundToDouble()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.orange.shade100,
                  child: Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 36,
                      color: Colors.orange[300],
                    ),
                  ),
                ),
              ),
              if (specialTag != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade500,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      specialTag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.amber[700]),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection() {
    return SizedBox(
      height: 220,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _buildActivityCard(
            "Diving in Blue Water",
            "Experience world-class diving",
            "1.8M IDR",
            "4.9",
            "380",
            specialTag: "🏆 Best Experience",
            iconData: Icons.scuba_diving,
            color: Colors.blue,
          ),
          _buildActivityCard(
            "Island Hopping Tour",
            "Visit multiple stunning islands",
            "1.2M IDR",
            "4.7",
            "260",
            iconData: Icons.sailing,
            color: Colors.teal,
          ),
          _buildActivityCard(
            "Wayag Viewpoint Trek",
            "Hike to the iconic viewpoint",
            "800k IDR",
            "4.8",
            "210",
            specialTag: "🏞️ Instagram Favorite",
            iconData: Icons.landscape,
            color: Colors.green,
          ),
          _buildActivityCard(
            "Local Culture Tour",
            "Learn about Papuan traditions",
            "650k IDR",
            "4.6",
            "120",
            iconData: Icons.people,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String name,
    String description,
    String price,
    String rating,
    String reviews, {
    String? specialTag,
    required IconData iconData,
    required Color color,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.05 * 255).roundToDouble()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: color.withValues(alpha: (0.1 * 255).roundToDouble()),
                  child: Center(
                    child: Icon(
                      iconData,
                      size: 40,
                      color: color.withValues(alpha: (0.5 * 255).roundToDouble()),
                    ),
                  ),
                ),
              ),
              if (specialTag != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      specialTag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.amber[700]),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color.withValues(alpha: (0.8 * 255).roundToDouble()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: (0.1 * 255).roundToDouble()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
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