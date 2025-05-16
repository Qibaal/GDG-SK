import 'package:flutter/material.dart';

class TrendingTab extends StatelessWidget {
  const TrendingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.only(bottom: 100), children: [
      const SizedBox(height: 24),
      CategorySection(
        title: '✨ Trending Now',
        description: 'Popular destinations travelers are loving',
        children: [
          DestinationCard(
            imageUrl: 'assets/bali.jpg',
            title: 'Bali, Indonesia',
            location: 'Island Paradise',
            rating: 4.8,
            tags: ['Beach', 'Culture', 'Relaxation'],
          ),
          DestinationCard(
            imageUrl: 'assets/kyoto.jpg',
            title: 'Kyoto, Japan',
            location: 'Historic City',
            rating: 4.9,
            tags: ['Temples', 'Gardens', 'Tradition'],
          ),
          DestinationCard(
            imageUrl: 'assets/santorini.jpg',
            title: 'Santorini, Greece',
            location: 'Aegean Sea',
            rating: 4.7,
            tags: ['Views', 'Romance', 'Cuisine'],
          ),
        ],
      ),
      const SizedBox(height: 24),
      CategorySection(
        title: '👨‍👩‍👧‍👦 Unforgettable Family Escapes',
        description: 'Perfect destinations packed with fun for all ages',
        children: [
          DestinationCard(
            imageUrl: 'assets/orlando.jpg',
            title: 'Orlando, USA',
            location: 'Theme Park Capital',
            rating: 4.8,
            tags: ['Kids', 'Theme Parks', 'Adventure'],
          ),
          DestinationCard(
            imageUrl: 'assets/kyoto.jpg',
            title: 'Kyoto, Japan',
            location: 'Cultural Wonderland',
            rating: 4.7,
            tags: ['Culture', 'Nature', 'Family'],
          ),
          DestinationCard(
            imageUrl: 'assets/goldcoast.jpg',
            title: 'Gold Coast, Australia',
            location: 'Sun & Surf Haven',
            rating: 4.6,
            tags: ['Beaches', 'Wildlife', 'Family Fun'],
          ),
        ],
      ),
    ]);
  }
}

class CategorySection extends StatelessWidget {
  final String title, description;
  final List<Widget> children;
  const CategorySection({
    Key? key,
    required this.title,
    required this.description,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(fontSize: 14, color: Color(0xFF858C95))),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView(scrollDirection: Axis.horizontal, children: children),
        ),
      ]),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String imageUrl, title, location;
  final double rating;
  final List<String> tags;

  const DestinationCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext c) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF858C95),
            const Color(0xFF90E0EF),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF48CAE4), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on, size: 14, color: Color(0xFF666666)),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
              ]),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: tags
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(t, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ))
                    .toList(),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
