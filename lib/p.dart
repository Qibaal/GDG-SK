import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemexplora/providers/auth_provider.dart';

class SearchResultPage extends StatefulWidget {
  final String travelQuery;
  final Map<String, dynamic> resultData;

  const SearchResultPage({
    Key? key,
    required this.travelQuery,
    required this.resultData,
  }) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> with SingleTickerProviderStateMixin {
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.resultData;
    final destination = Map<String, dynamic>.from(data['destination']);
    final details = Map<String, dynamic>.from(data['details']);
    final hotels = List<Map<String, dynamic>>.from(data['hotels']);
    final foods = List<Map<String, dynamic>>.from(data['foods']);
    final attractions = List<Map<String, dynamic>>.from(data['attractions']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAnswerBox(data['firstResponse'] as String),
          _buildDestinationSummary(destination),
          _buildDetailsOverview(details),
          Expanded(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [Tab(text: 'Hotels'), Tab(text: 'Food'), Tab(text: 'Attractions')],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRecommendationList(hotels),
                      _buildRecommendationList(foods),
                      _buildRecommendationList(attractions),
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

  Widget _buildAnswerBox(String firstResponse) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        firstResponse,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildDestinationSummary(Map<String, dynamic> dest) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(dest['image'] as String),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dest['name'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  dest['province'] as String,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsOverview(Map<String, dynamic> details) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildInfoCard(
            title: 'Budget',
            value: '${details['budget']['value']} ${details['budget']['currency']}',
            subtitle: 'Required: ${details['budget']['required']}',
            icon: Icons.account_balance_wallet,
          ),
          _buildInfoCard(
            title: 'Duration',
            value: '${details['duration']['days']} Days',
            subtitle: 'Recommended: ${details['duration']['recommended']} Days',
            icon: Icons.calendar_today,
          ),
          _buildInfoCard(
            title: 'Weather',
            value: details['weather']['temperature'] as String,
            subtitle: details['weather']['condition'] as String,
            icon: Icons.wb_sunny,
          ),
          _buildInfoCard(
            title: 'Crime Index',
            value: details['crimeIndex']['Cindex'] as String,
            subtitle: details['crimeIndex']['status'] as String,
            icon: Icons.security,
          ),
          _buildInfoCard(
            title: 'Visa',
            value: details['Visa']['status'] as String,
            subtitle: details['Visa']['req'] as String,
            icon: Icons.credit_card,
          ),
          _buildInfoCard(
            title: 'Language',
            value: details['language']['name'] as String,
            subtitle: details['language']['detail'] as String,
            icon: Icons.translate,
          ),
          _buildInfoCard(
            title: 'Transport',
            value: details['transport'] as String,
            subtitle: '',
            icon: Icons.local_taxi,
          ),
          _buildInfoCard(
            title: 'Events',
            value: (details['events'] as List).isNotEmpty
                ? (details['events'][0]['name'] as String)
                : '-',
            subtitle: (details['events'] as List).isNotEmpty
                ? (details['events'][0]['details'] as String)
                : '',
            icon: Icons.event,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildRecommendationCard(
          imageUrl: item['image'] as String,
          title: item['title'] as String,
          rating: (item['rating'] as num).toDouble(),
          price: item['price'] as String,
          tagLine: item['tagLine'] as String,
          featureList: List<String>.from(item['features'] as List),
          mapUrl: item['mapUrl'] as String,
          detailsUrl: item['detailsUrl'] as String,
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({
    required String imageUrl,
    required String title,
    required double rating,
    required String price,
    required String tagLine,
    required List<String> featureList,
    required String mapUrl,
    required String detailsUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(imageUrl, height: 160, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                    Row(children: [const Icon(Icons.star, size: 16, color: Colors.amber), Text(rating.toString(), style: const TextStyle(fontSize: 14))]),
                  ],
                ),
                const SizedBox(height: 4),
                Text(tagLine, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: featureList.map((f) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                        child: Text(f, style: const TextStyle(fontSize: 11)),
                      )).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.location_on_outlined),
                          onPressed: () => _launchUrl(mapUrl),
                        ),
                        ElevatedButton(
                          onPressed: () => _launchUrl(detailsUrl),
                          child: const Text('View Details'),
                        ),
                      ],
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
