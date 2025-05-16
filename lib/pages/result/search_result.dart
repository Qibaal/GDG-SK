import 'package:flutter/material.dart';

// KEEP IMPORTS AND CLASS SIGNATURE
class SearchResultPage extends StatefulWidget {
  final Map<String, dynamic> resultData;

  const SearchResultPage({
    super.key,
    required this.resultData,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            _buildAppBar(), // KEEP THIS METHOD
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildAnswerBox(), // UPDATED TO USE resultData
                  _buildDestinationDetails(), // UPDATED TO USE resultData
                ],
              ),
            ),
            SliverFillRemaining(
              child: _buildTabView(), // KEEP THIS METHOD
            ),
          ],
        ),
      ),
    );
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
    final firstResp = widget.resultData['firstResponse'] as String;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF1A73E8),
            child: Icon(Icons.travel_explore, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              firstResp,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationDetails() {
    final dest = widget.resultData['destination'] as Map<String, dynamic>;
    final details = widget.resultData['details'] as Map<String, dynamic>;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
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
              CircleAvatar(
                backgroundImage: NetworkImage(dest['image']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dest['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dest['province'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Budget',
                  value: details['budget']['value'],
                  subtitle: 'Required: ${details['budget']['required']}',
                  icon: Icons.account_balance_wallet,
                  valueColor: details['budget']['value'] == details['budget']['required']
                      ? Colors.black87
                      : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  title: 'Duration',
                  value: '${details['duration']['days']} Days',
                  subtitle:
                      'Recommended: ${details['duration']['recommended']} Days',
                  icon: Icons.calendar_today,
                  valueColor: details['duration']['days'] < details['duration']['recommended']
                      ? Colors.orange
                      : Colors.black87,
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
                  value: details['weather']['temperature'],
                  subtitle: details['weather']['condition'],
                  icon: Icons.wb_sunny,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  title: 'Crime Index',
                  value: details['crimeIndex']['Cindex'],
                  subtitle: details['crimeIndex']['status'],
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
                child: _buildInfoCard(
                  title: 'Visa',
                  value: details['Visa']['status'],
                  subtitle: details['Visa']['req'],
                  icon: Icons.credit_card,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  title: 'Language',
                  value: details['language']['name'],
                  subtitle: details['language']['detail'],
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
                  title: 'Transport',
                  value: details['transport'],
                  subtitle: '',
                  icon: Icons.directions_transit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  title: 'Events',
                  value: details['events'][0]['name'],
                  subtitle: details['events'][0]['details'],
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
        color: Colors.grey.withAlpha((0.05 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              if (isPremium) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star, size: 12, color: Color(0xFFFFD700)),
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
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
    // KEEP THIS UI SECTION UNCHANGED
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: featureList.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(feature, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                      label: const Text('Map'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
