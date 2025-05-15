// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:logger/logger.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ),
//   );
//   runApp(const GemExploraApp());
// }

// var logger = Logger();

// class GemExploraApp extends StatelessWidget {
//   const GemExploraApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'GemExplora',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.light(
//           primary: const Color(0xFF3B82F6),       // Vibrant Blue
//           secondary: const Color(0xFF60A5FA),     // Light Blue
//           tertiary: const Color(0xFFDDEDFF),      // Very Light Blue
//           background: Colors.white,
//           surface: const Color(0xFFF8FAFC),
//           onBackground: const Color(0xFF1E293B),
//           onSurface: const Color(0xFF334155),
//           brightness: Brightness.light,
//         ),
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           iconTheme: const IconThemeData(color: Color(0xFF3B82F6)),
//           titleTextStyle: GoogleFonts.poppins(
//             color: const Color(0xFF3B82F6),
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         cardTheme: CardTheme(
//           color: Colors.white,
//           elevation: 2,
//           shadowColor: Colors.black.withOpacity(0.04),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: const Color(0xFFF8FAFC),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
//         ),
//         tabBarTheme: TabBarTheme(
//           labelColor: Colors.white,
//           unselectedLabelColor: const Color(0xFF3B82F6),
//           indicator: BoxDecoration(
//             color: const Color(0xFF3B82F6),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           dividerColor: Colors.transparent,
//         ),
//         textTheme: TextTheme(
//           headlineLarge: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF1E293B),
//             fontSize: 24,
//           ),
//           headlineMedium: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF1E293B),
//             fontSize: 20,
//           ),
//           titleLarge: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF1E293B),
//             fontSize: 18,
//           ),
//           titleMedium: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF1E293B),
//           ),
//           bodyLarge: GoogleFonts.inter(color: const Color(0xFF334155)),
//           bodyMedium: GoogleFonts.inter(color: const Color(0xFF64748B)),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF3B82F6),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             textStyle: GoogleFonts.inter(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// // Home Screen Widget
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   bool _showElevation = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.offset > 10 && !_showElevation) {
//       setState(() {
//         _showElevation = true;
//       });
//     } else if (_scrollController.offset <= 10 && _showElevation) {
//       setState(() {
//         _showElevation = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             NestedScrollView(
//               controller: _scrollController,
//               headerSliverBuilder: (context, innerBoxIsScrolled) {
//                 return [
//                   SliverAppBar(
//                     pinned: true,
//                     floating: false,
//                     backgroundColor: Colors.white,
//                     elevation: _showElevation ? 4 : 0,
//                     shadowColor: Colors.black.withOpacity(0.05),
//                     title: Row(
//                       children: [
//                         _buildLogo(),
//                         const SizedBox(width: 10),
//                         Text(
//                           'GemExplora',
//                           style: GoogleFonts.poppins(
//                             color: const Color(0xFF3B82F6),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       IconButton(
//                         icon: const Icon(Icons.explore_outlined, size: 24),
//                         color: const Color(0xFF3B82F6),
//                         onPressed: () {},
//                       ),
//                       const SizedBox(width: 4),
//                       Container(
//                         margin: const EdgeInsets.only(right: 16),
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF3B82F6).withOpacity(0.2),
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: const CircleAvatar(
//                           radius: 18,
//                           backgroundColor: Colors.transparent,
//                           child: Text(
//                             'FV',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     bottom: PreferredSize(
//                       preferredSize: const Size.fromHeight(180),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Welcome back, Traveler',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xFF1E293B),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Where would you like to explore today?',
//                                   style: GoogleFonts.inter(
//                                     fontSize: 14,
//                                     color: const Color(0xFF64748B),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 _buildSearchBar(),
//                                 const SizedBox(height: 16),
//                               ],
//                             ),
//                           ),
//                           _buildTabBar(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ];
//               },
//               body: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildTrendingTab(),
//                   _buildFoodTab(),
//                   _buildStaysTab(),
//                   _buildEventsTab(),
//                 ],
//               ),
//             ),
//             const Positioned(
//               bottom: 24,
//               right: 24,
//               child: AiAssistantButton(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo() {
//     return Container(
//       width: 36,
//       height: 36,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF3B82F6).withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Icon(
//           Icons.diamond_outlined,
//           color: Colors.white,
//           size: 20,
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'Search destinations, experiences...',
//           prefixIcon: const Icon(Icons.search, color: Color(0xFF3B82F6), size: 20),
//           suffixIcon: Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFDDEDFF),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.tune, color: Color(0xFF3B82F6), size: 18),
//               onPressed: () {
//                 if (_searchController.text.trim().isNotEmpty) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SearchResultsScreen(
//                         searchQuery: _searchController.text.trim(),
//                       ),
//                     ),
//                   );
//                 }
//               },
//               constraints: const BoxConstraints(
//                 minWidth: 36,
//                 minHeight: 36,
//               ),
//               padding: EdgeInsets.zero,
//             ),
//           ),
//           hintStyle: GoogleFonts.inter(
//             color: const Color(0xFF94A3B8),
//             fontSize: 14,
//           ),
//         ),
//         style: GoogleFonts.inter(
//           color: const Color(0xFF334155),
//           fontSize: 14,
//         ),
//       ),
//     );
//   }

//   Widget _buildTabBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         tabs: const [
//           Tab(
//             icon: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.trending_up, size: 16),
//                 SizedBox(width: 4),
//                 Text('Trending'),
//               ],
//             ),
//           ),
//           Tab(
//             icon: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.restaurant, size: 16),
//                 SizedBox(width: 4),
//                 Text('Food'),
//               ],
//             ),
//           ),
//           Tab(
//             icon: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.hotel, size: 16),
//                 SizedBox(width: 4),
//                 Text('Stays'),
//               ],
//             ),
//           ),
//           Tab(
//             icon: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.event, size: 16),
//                 SizedBox(width: 4),
//                 Text('Events'),
//               ],
//             ),
//           ),
//         ],
//         padding: const EdgeInsets.all(4),
//         indicatorSize: TabBarIndicatorSize.tab,
//         dividerColor: Colors.transparent,
//         labelStyle: GoogleFonts.inter(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//         unselectedLabelStyle: GoogleFonts.inter(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildTrendingTab() {
//     return ListView(
//       padding: const EdgeInsets.only(bottom: 100),
//       children: [
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '✨ Trending Now',
//           'Popular destinations travelers are loving',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?bali',
//               'Bali, Indonesia',
//               'Island Paradise',
//               4.8,
//               ['Beach', 'Culture', 'Relaxation'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?kyoto',
//               'Kyoto, Japan',
//               'Historic City',
//               4.9,
//               ['Temples', 'Gardens', 'Tradition'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?santorini',
//               'Santorini, Greece',
//               'Aegean Sea',
//               4.7,
//               ['Views', 'Romance', 'Cuisine'],
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '👨‍👩‍👧‍👦 Family Adventures',
//           'Perfect for kids and parents',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?orlando',
//               'Orlando, USA',
//               'Theme Park Capital',
//               4.6,
//               ['Parks', 'Entertainment', 'Fun'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?tokyo',
//               'Tokyo, Japan',
//               'Modern Metropolis',
//               4.7,
//               ['Disney', 'Technology', 'Culture'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?london',
//               'London, UK',
//               'Historic Capital',
//               4.5,
//               ['Museums', 'Parks', 'History'],
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '💰 Budget-Friendly Gems',
//           'Amazing experiences that won\'t break the bank',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?chiangmai',
//               'Chiang Mai, Thailand',
//               'Northern Thailand',
//               4.6,
//               ['Affordable', 'Culture', 'Food'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?lisbon',
//               'Lisbon, Portugal',
//               'Coastal Capital',
//               4.7,
//               ['Value', 'History', 'Cuisine'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?mexicocity',
//               'Mexico City, Mexico',
//               'Historic Metropolis',
//               4.5,
//               ['Affordable', 'Culture', 'Food'],
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '💎 Hidden Treasures',
//           'Off-the-beaten-path destinations',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?faroeislands',
//               'Faroe Islands',
//               'North Atlantic',
//               4.9,
//               ['Nature', 'Secluded', 'Scenic'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?ljubljana',
//               'Ljubljana, Slovenia',
//               'Central Europe',
//               4.7,
//               ['Charming', 'Green', 'Compact'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?luangprabang',
//               'Luang Prabang, Laos',
//               'Southeast Asia',
//               4.8,
//               ['Temples', 'Peaceful', 'Nature'],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildFoodTab() {
//     return ListView(
//       padding: const EdgeInsets.only(bottom: 100),
//       children: [
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '🍽️ Culinary Destinations',
//           'Cities known for exceptional cuisine',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?tokyofood',
//               'Tokyo, Japan',
//               'Culinary Capital',
//               4.9,
//               ['Sushi', 'Ramen', 'Street Food'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?lyonfood',
//               'Lyon, France',
//               'Gastronomic Center',
//               4.8,
//               ['Fine Dining', 'Wine', 'Tradition'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?bangkokfood',
//               'Bangkok, Thailand',
//               'Street Food Paradise',
//               4.7,
//               ['Spicy', 'Markets', 'Variety'],
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '🍷 Wine Regions',
//           'Destinations for wine enthusiasts',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?bordeaux',
//               'Bordeaux, France',
//               'Wine Country',
//               4.9,
//               ['Wine Tours', 'Vineyards', 'Tasting'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?tuscany',
//               'Tuscany, Italy',
//               'Italian Wine Region',
//               4.8,
//               ['Chianti', 'Countryside', 'Cuisine'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?napavalley',
//               'Napa Valley, USA',
//               'California Wine Country',
//               4.7,
//               ['Wineries', 'Tours', 'Gourmet'],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStaysTab() {
//     return ListView(
//       padding: const EdgeInsets.only(bottom: 100),
//       children: [
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '🏨 Unique Accommodations',
//           'One-of-a-kind places to stay',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?treehouse',
//               'Treehouse Lodge',
//               'Amazon, Peru',
//               4.8,
//               ['Unique', 'Nature', 'Adventure'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?icehotel',
//               'Ice Hotel',
//               'Jukkasjärvi, Sweden',
//               4.7,
//               ['Winter', 'Unique', 'Experience'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?underwater',
//               'Underwater Suite',
//               'Maldives',
//               4.9,
//               ['Luxury', 'Marine', 'Exclusive'],
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '🏝️ Overwater Bungalows',
//           'Luxurious stays above crystal waters',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?borabora',
//               'Bora Bora',
//               'French Polynesia',
//               4.9,
//               ['Luxury', 'Romance', 'Views'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?maldives',
//               'Maldives',
//               'Indian Ocean',
//               4.8,
//               ['Private', 'Beaches', 'Snorkeling'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?fiji',
//               'Fiji',
//               'South Pacific',
//               4.7,
//               ['Island', 'Culture', 'Relaxation'],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildEventsTab() {
//     return ListView(
//       padding: const EdgeInsets.only(bottom: 100),
//       children: [
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '🎭 Cultural Festivals',
//           'Celebrations around the world',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?carnival',
//               'Carnival',
//               'Rio de Janeiro, Brazil',
//               4.9,
//               ['Festival', 'Music', 'Dance'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?diwali',
//               'Diwali',
//               'India',
//               4.8,
//               ['Lights', 'Celebration', 'Culture'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?oktoberfest',
//               'Oktoberfest',
//               'Munich, Germany',
//               4.7,
//               ['Beer', 'Food', 'Tradition'],
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         _buildCategorySection(
//           '🎵 Music Festivals',
//           'Unforgettable musical experiences',
//           [
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?coachella',
//               'Coachella',
//               'California, USA',
//               4.7,
//               ['Music', 'Art', 'Fashion'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?glastonbury',
//               'Glastonbury',
//               'Somerset, UK',
//               4.8,
//               ['Music', 'Camping', 'Culture'],
//             ),
//             _buildDestinationCard(
//               'https://source.unsplash.com/random/300x200/?tomorrowland',
//               'Tomorrowland',
//               'Boom, Belgium',
//               4.9,
//               ['EDM', 'Production', 'International'],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Helper method to build a category section
//   Widget _buildCategorySection(String title, String description, List<Widget> children) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 4,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3B82F6),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 12),
//             child: Text(
//               description,
//               style: GoogleFonts.inter(
//                 fontSize: 13,
//                 color: const Color(0xFF64748B),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 290,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: children,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to build a destination card
//   Widget _buildDestinationCard(
//     String imageUrl,
//     String title,
//     String location,
//     double rating,
//     List<String> tags,
//   ) {
//     return Container(
//       width: 260,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: 160,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFDDEDFF),
//                   ),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Center(
//                         child: Icon(Icons.image, size: 50, color: const Color(0xFF3B82F6)),
//                       );
//                     },
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: const Color(0xFF3B82F6),
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.3),
//                         ],
//                         stops: const [0.7, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.star,
//                           size: 14,
//                           color: Color(0xFFF59E0B),
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           rating.toString(),
//                           style: GoogleFonts.inter(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF1E293B),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 12,
//                   right: 12,
//                   child: Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(18),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.favorite_border,
//                       size: 18,
//                       color: Color(0xFF3B82F6),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF1E293B),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 14,
//                         color: Color(0xFF3B82F6),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         location,
//                         style: GoogleFonts.inter(
//                           fontSize: 13,
//                           color: const Color(0xFF64748B),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 6,
//                     children: tags.map((tag) {
//                       return Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFDDEDFF),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           tag,
//                           style: GoogleFonts.inter(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500,
//                             color: const Color(0xFF3B82F6),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // AI Assistant Button and Sheet
// class AiAssistantButton extends StatelessWidget {
//   const AiAssistantButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder: (context) => const AiAssistantSheet(),
//         );
//       },
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(28),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF3B82F6).withOpacity(0.25),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: const Center(
//           child: Icon(
//             Icons.auto_awesome,
//             color: Colors.white,
//             size: 24,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AiAssistantSheet extends StatefulWidget {
//   const AiAssistantSheet({super.key});

//   @override
//   State<AiAssistantSheet> createState() => _AiAssistantSheetState();
// }

// class _AiAssistantSheetState extends State<AiAssistantSheet> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<ChatMessage> _messages = [
//     ChatMessage(
//       text: "Hi there! I'm your GemExplora AI assistant powered by Google Gemini. Ask me about destinations, travel tips, or recommendations!",
//       isUser: false,
//     ),
//   ];
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _handleSend() {
//     if (_messageController.text.trim().isEmpty) return;

//     setState(() {
//       _messages.add(ChatMessage(
//         text: _messageController.text,
//         isUser: true,
//       ));
//     });

//     final userMessage = _messageController.text;
//     _messageController.clear();

//     // Scroll to bottom
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });

//     // Simulate AI response (in a real app, this would call the Gemini API)
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted) {
//         setState(() {
//           _messages.add(ChatMessage(
//             text: "I'd be happy to help you explore more about \"$userMessage\". Here's what I found.",
//             isUser: false,
//           ));
//         });
        
//         // Scroll to bottom again after new message
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.8,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: _buildMessageList(),
//           ),
//           _buildInputArea(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF3B82F6).withOpacity(0.2),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.auto_awesome,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             'Gemini Travel Assistant',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF1E293B),
//             ),
//           ),
//           const Spacer(),
//           IconButton(
//             icon: const Icon(Icons.close, color: Color(0xFF64748B)),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageList() {
//     return ListView.builder(
//       controller: _scrollController,
//       padding: const EdgeInsets.all(16),
//       itemCount: _messages.length,
//       reverse: false,
//       itemBuilder: (context, index) {
//         final message = _messages[index];
//         return Align(
//           alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.8,
//             ),
//             decoration: BoxDecoration(
//               gradient: message.isUser
//                   ? const LinearGradient(
//                       colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     )
//                   : null,
//               color: message.isUser ? null : const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(16).copyWith(
//                 bottomRight: message.isUser ? const Radius.circular(0) : null,
//                 bottomLeft: !message.isUser ? const Radius.circular(0) : null,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               message.text,
//               style: GoogleFonts.inter(
//                 color: message.isUser ? Colors.white : const Color(0xFF334155),
//                 fontSize: 14,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF1F5F9),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.02),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: _messageController,
//                 decoration: InputDecoration(
//                   hintText: 'Ask about destinations, food, or activities...',
//                   hintStyle: GoogleFonts.inter(
//                     color: const Color(0xFF94A3B8),
//                     fontSize: 14,
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//                 style: GoogleFonts.inter(
//                   color: const Color(0xFF334155),
//                   fontSize: 14,
//                 ),
//                 onSubmitted: (_) => _handleSend(),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF3B82F6).withOpacity(0.2),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.send, color: Colors.white, size: 20),
//               onPressed: _handleSend,
//               constraints: const BoxConstraints(
//                 minWidth: 48,
//                 minHeight: 48,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final bool isUser;

//   ChatMessage({required this.text, required this.isUser});
// }

// // Firebase Service
// class FirebaseService {
//   // This would normally connect to Firebase
//   // For this example, we're just providing the structure
  
//   static Future<void> initialize() async {
//     // Initialize Firebase
//     logger.i('Firebase initialized');
//   }

//   static Future<Map<String, dynamic>?> signInWithEmail(String email, String password) async {
//     // Simulate authentication
//     await Future.delayed(const Duration(seconds: 1));
//     return {
//       'uid': 'user123',
//       'email': email,
//       'displayName': 'Traveler',
//     };
//   }

//   static Future<void> signOut() async {
//     // Simulate sign out
//     await Future.delayed(const Duration(milliseconds: 500));
//     logger.i('User signed out');
//   }

//   static Future<List<Map<String, dynamic>>> getDestinations() async {
//     // Simulate fetching destinations from Firestore
//     await Future.delayed(const Duration(seconds: 1));
//     return [
//       {
//         'id': 'dest1',
//         'title': 'Bali, Indonesia',
//         'location': 'Island Paradise',
//         'rating': 4.8,
//         'tags': ['Beach', 'Culture', 'Relaxation'],
//         'imageUrl': 'https://source.unsplash.com/random/300x200/?bali',
//       },
//       {
//         'id': 'dest2',
//         'title': 'Kyoto, Japan',
//         'location': 'Historic City',
//         'rating': 4.9,
//         'tags': ['Temples', 'Gardens', 'Tradition'],
//         'imageUrl': 'https://source.unsplash.com/random/300x200/?kyoto',
//       },
//       // More destinations would be here
//     ];
//   }

//   static Future<Map<String, dynamic>?> getDestinationDetails(String destinationId) async {
//     // Simulate fetching destination details
//     await Future.delayed(const Duration(seconds: 1));
//     return {
//       'id': destinationId,
//       'title': 'Bali, Indonesia',
//       'location': 'Island Paradise',
//       'description': 'Bali is a living postcard, an Indonesian paradise that feels like a fantasy.',
//       'rating': 4.8,
//       'tags': ['Beach', 'Culture', 'Relaxation'],
//       'imageUrl': 'https://source.unsplash.com/random/600x400/?bali',
//       'attractions': [
//         'Ubud Monkey Forest',
//         'Tanah Lot Temple',
//         'Tegallalang Rice Terraces',
//       ],
//       'hotels': [
//         {
//           'name': 'Four Seasons Resort Bali',
//           'rating': 5.0,
//           'priceRange': '\$\$\$\$',
//         },
//         {
//           'name': 'Padma Resort Ubud',
//           'rating': 4.7,
//           'priceRange': '\$\$\$',
//         },
//       ],
//       'restaurants': [
//         {
//           'name': 'Locavore',
//           'cuisine': 'Contemporary',
//           'rating': 4.8,
//         },
//         {
//           'name': 'Warung Babi Guling Ibu Oka',
//           'cuisine': 'Balinese',
//           'rating': 4.6,
//         },
//       ],
//     };
//   }

//   static Future<void> saveUserPreferences(String userId, Map<String, dynamic> preferences) async {
//     // Simulate saving user preferences
//     await Future.delayed(const Duration(milliseconds: 500));
//     logger.i('Saved preferences for user $userId: $preferences');
//   }
// }

// // Gemini AI Service
// class GeminiService {
//   final String apiKey;
//   final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
//   final String model = 'gemini-pro';

//   GeminiService({required this.apiKey});

//   Future<String> generateResponse(String prompt) async {
//     try {
//       // In a real app, this would make an actual API call to Google's Gemini API
//       // For this example, we're simulating the response
      
//       await Future.delayed(const Duration(seconds: 1));
      
//       // Simulate different responses based on prompt keywords
//       if (prompt.toLowerCase().contains('bali')) {
//         return 'Bali is a beautiful Indonesian island known for its lush landscapes, vibrant culture, and stunning beaches. The best time to visit is during the dry season (April to October). Don\'t miss the sacred Monkey Forest, Tanah Lot temple, and the rice terraces of Tegallalang.';
//       } else if (prompt.toLowerCase().contains('food') || prompt.toLowerCase().contains('cuisine')) {
//         return 'For amazing culinary experiences, I recommend Tokyo (Japan), Bangkok (Thailand), and Lyon (France). Each offers unique flavors and dining traditions. In Tokyo, try sushi at Tsukiji Market. Bangkok street food scene is unmatched - visit Chinatown for the best experience. Lyon is considered France gastronomic capital with traditional bouchons serving local specialties.';
//       } else if (prompt.toLowerCase().contains('budget') || prompt.toLowerCase().contains('cheap')) {
//         return 'For budget-friendly travel, consider Southeast Asia (Thailand, Vietnam, Indonesia), Eastern Europe (Hungary, Poland, Romania), or Latin America (Mexico, Colombia, Peru). These destinations offer great value with affordable accommodations, food, and activities while providing rich cultural experiences.';
//       } else {
//         return 'I\'d be happy to help you plan your perfect trip! I can provide recommendations for destinations, accommodations, activities, and local cuisine based on your preferences. Just let me know what you\'re interested in exploring!';
//       }
//     } catch (e) {
//       logger.i('Exception: $e');
//       return 'Sorry, I encountered an error. Please try again later.';
//     }
//   }

//   Future<List<Map<String, dynamic>>> getDestinationRecommendations(
//       String userPreferences, int limit) async {
//     try {
//       // Simulate AI-generated recommendations
//       await Future.delayed(const Duration(seconds: 1));
      
//       // This would normally call the Gemini API and parse the response
//       return [
//         {
//           "title": "Kyoto, Japan",
//           "location": "Kansai Region, Japan",
//           "description": "Ancient capital with over 1,600 Buddhist temples and 400 Shinto shrines",
//           "rating": 4.9,
//           "tags": ["Culture", "History", "Temples"],
//           "highlights": ["Fushimi Inari Shrine", "Arashiyama Bamboo Grove", "Kinkaku-ji"]
//         },
//         {
//           "title": "Porto, Portugal",
//           "location": "Northern Portugal",
//           "description": "Coastal city known for port wine, stunning bridges and colorful historic center",
//           "rating": 4.7,
//           "tags": ["Wine", "Architecture", "Affordable"],
//           "highlights": ["Ribeira District", "Port Wine Cellars", "Dom Luís I Bridge"]
//         },
//         {
//           "title": "Chiang Mai, Thailand",
//           "location": "Northern Thailand",
//           "description": "Cultural hub with ancient temples, night markets and mountain scenery",
//           "rating": 4.8,
//           "tags": ["Budget", "Culture", "Food"],
//           "highlights": ["Sunday Night Market", "Doi Suthep", "Elephant Sanctuaries"]
//         }
//       ];
//     } catch (e) {
//       logger.i('Exception in getDestinationRecommendations: $e');
//       return [];
//     }
//   }
// }

// class SearchResultsScreen extends StatefulWidget {
//   final String searchQuery;

//   const SearchResultsScreen({super.key, required this.searchQuery});

//   @override
//   State<SearchResultsScreen> createState() => _SearchResultsScreenState();
// }

// class _SearchResultsScreenState extends State<SearchResultsScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _aiResponse = '';
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.text = widget.searchQuery;
//     _performSearch();
//   }

//   void _performSearch() async {
//     setState(() {
//       _isLoading = true;
//     });

//     // Simulate AI response generation (replace with actual Gemini API call)
//     final geminiService = GeminiService(apiKey: 'your_api_key');
//     final response = await geminiService.generateResponse(widget.searchQuery);

//     setState(() {
//       _aiResponse = response;
//       _isLoading = false;
//     });
//   }

//   void _handleSearch() {
//     if (_searchController.text.trim().isNotEmpty) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchResultsScreen(
//             searchQuery: _searchController.text.trim(),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.03),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFDDEDFF),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Color(0xFF3B82F6), size: 20),
//                       onPressed: () => Navigator.of(context).pop(),
//                       constraints: const BoxConstraints(
//                         minWidth: 40,
//                         minHeight: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF1F5F9),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.02),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Search destinations, experiences...',
//                           hintStyle: GoogleFonts.inter(
//                             color: const Color(0xFF94A3B8),
//                             fontSize: 14,
//                           ),
//                           prefixIcon: const Icon(Icons.search, color: Color(0xFF3B82F6), size: 20),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         style: GoogleFonts.inter(
//                           color: const Color(0xFF334155),
//                           fontSize: 14,
//                         ),
//                         onSubmitted: (_) => _handleSearch(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _isLoading
//                   ? Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const CircularProgressIndicator(
//                             color: Color(0xFF3B82F6),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Finding the best matches...',
//                             style: GoogleFonts.inter(
//                               color: const Color(0xFF64748B),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Results for "${widget.searchQuery}"',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFF1E293B),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.04),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                                 border: Border.all(
//                                   color: const Color(0xFFDDEDFF),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           gradient: const LinearGradient(
//                                             colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           ),
//                                           borderRadius: BorderRadius.circular(12),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: const Color(0xFF3B82F6).withOpacity(0.2),
//                                               blurRadius: 8,
//                                               offset: const Offset(0, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: const Icon(
//                                           Icons.auto_awesome,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Text(
//                                         'AI Insights',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: const Color(0xFF1E293B),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Text(
//                                     _aiResponse,
//                                     style: GoogleFonts.inter(
//                                       fontSize: 14,
//                                       color: const Color(0xFF334155),
//                                       height: 1.6,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       ElevatedButton.icon(
//                                         onPressed: () {},
//                                         icon: const Icon(Icons.bookmark_border, size: 18),
//                                         label: const Text('Save'),
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: const Color(0xFFDDEDFF),
//                                           foregroundColor: const Color(0xFF3B82F6),
//                                           elevation: 0,
//                                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       ElevatedButton.icon(
//                                         onPressed: () {},
//                                         icon: const Icon(Icons.share, size: 18),
//                                         label: const Text('Share'),
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: const Color(0xFF3B82F6),
//                                           foregroundColor: Colors.white,
//                                           elevation: 0,
//                                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//                             Text(
//                               'Recommended Destinations',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFF1E293B),
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             SizedBox(
//                               height: 290,
//                               child: ListView(
//                                 scrollDirection: Axis.horizontal,
//                                 children: [
//                                   _buildDestinationCard(
//                                     'https://source.unsplash.com/random/300x200/?${widget.searchQuery}',
//                                     'Explore ${widget.searchQuery}',
//                                     'Popular Destination',
//                                     4.8,
//                                     ['Recommended', 'Popular', 'Trending'],
//                                   ),
//                                   _buildDestinationCard(
//                                     'https://source.unsplash.com/random/300x200/?travel',
//                                     'Similar Destinations',
//                                     'Based on your search',
//                                     4.7,
//                                     ['Similar', 'Curated', 'For You'],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Reusing the destination card from the home screen
//   Widget _buildDestinationCard(
//     String imageUrl,
//     String title,
//     String location,
//     double rating,
//     List<String> tags,
//   ) {
//     return Container(
//       width: 260,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: 160,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFDDEDFF),
//                   ),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Center(
//                         child: Icon(Icons.image, size: 50, color: const Color(0xFF3B82F6)),
//                       );
//                     },
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: const Color(0xFF3B82F6),
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.3),
//                         ],
//                         stops: const [0.7, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.star,
//                           size: 14,
//                           color: Color(0xFFF59E0B),
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           rating.toString(),
//                           style: GoogleFonts.inter(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF1E293B),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 12,
//                   right: 12,
//                   child: Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(18),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.favorite_border,
//                       size: 18,
//                       color: Color(0xFF3B82F6),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF1E293B),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 14,
//                         color: Color(0xFF3B82F6),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         location,
//                         style: GoogleFonts.inter(
//                           fontSize: 13,
//                           color: const Color(0xFF64748B),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 6,
//                     children: tags.map((tag) {
//                       return Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFDDEDFF),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           tag,
//                           style: GoogleFonts.inter(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500,
//                             color: const Color(0xFF3B82F6),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }