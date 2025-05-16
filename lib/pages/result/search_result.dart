import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:gemexplora/services/image_service.dart';
import 'package:gemexplora/pages/result/timeline.dart';

class SearchResultPage extends StatefulWidget {
  
  final Map<String, dynamic> resultData;

  const SearchResultPage({
    super.key,
    required this.resultData,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> with SingleTickerProviderStateMixin {
  Map<String, dynamic> get data {
    return widget.resultData.containsKey('Response')
      ? data['Response'] as Map<String, dynamic>
      : widget.resultData;
  }

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
    final isTimeline = (data['isTimeLine'] as bool?) ?? false;
    if (isTimeline) {
      return TimelinePage(resultData: data);
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: kToolbarHeight),
            ),
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      title: const Text('Travel Search'),
      centerTitle: true,
    );
  }

  Widget _buildAnswerBox() {
    final firstResp = data['firstResponse'] as String;
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
  bool isLiked = false;
  Widget _buildDestinationDetails() {
    final dest = data['destination'] as Map<String, dynamic>;
    final details = data['details'] as Map<String, dynamic>;
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
                backgroundImage: AssetImage('assets/city.jpg'),
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
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
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
    final hotels = List<Map<String,dynamic>>.from(data['hotels']);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hotels.length,
      itemBuilder: (context, i) {
        final h = hotels[i];
        return _buildRecommendationCard(
          imageUrl:   h['image'],
          title:      h['title'],
          rating:     (h['rating'] as num).toDouble(),
          price:      h['price'],
          tagLine:    h['tagLine'],
          featureList: List<String>.from(h['features']),
        );
      },
    );
  }

  Widget _buildFoodList() {
    final foods = List<Map<String,dynamic>>.from(data['foods']);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: foods.length,
      itemBuilder: (context, i) {
        final f = foods[i];
        return _buildRecommendationCard(
          imageUrl:   f['image'],
          title:      f['title'],
          rating:     (f['rating'] as num).toDouble(),
          price:      f['price'],
          tagLine:    f['tagLine'],
          featureList: List<String>.from(f['features']),
        );
      },
    );
  }

  Widget _buildAttractionsList() {
    final attractions = List<Map<String,dynamic>>.from(data['attractions']);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: attractions.length,
      itemBuilder: (context, i) {
        final a = attractions[i];
        return _buildRecommendationCard(
          imageUrl:   a['image'],
          title:      a['title'],
          rating:     (a['rating'] as num).toDouble(),
          price:      a['price'],
          tagLine:    a['tagLine'],
          featureList: List<String>.from(a['features']),
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
                child: Image.asset(
                  getImageAssetByTitle(title),
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
