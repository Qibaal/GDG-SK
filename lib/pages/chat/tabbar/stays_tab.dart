// lib/pages/chat/stays_tab.dart

import 'package:flutter/material.dart';
import 'trending_tab.dart';

class StaysTab extends StatelessWidget {
  const StaysTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.only(bottom: 100), children: [
      const SizedBox(height: 24),
      CategorySection(
        title: '🏨 Unique Accommodations',
        description: 'One-of-a-kind places to stay',
        children: [
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?treehouse',
            title: 'Treehouse Lodge',
            location: 'Amazon, Peru',
            rating: 4.8,
            tags: ['Nature', 'Adventure', 'Unique'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?icehotel',
            title: 'Ice Hotel',
            location: 'Jukkasjärvi, Sweden',
            rating: 4.7,
            tags: ['Winter', 'Design', 'Experience'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?underwaterhotel',
            title: 'Underwater Suite',
            location: 'Maldives',
            rating: 4.9,
            tags: ['Luxury', 'Marine', 'Exclusive'],
          ),
        ],
      ),
      const SizedBox(height: 24),
      CategorySection(
        title: '🏝️ Overwater Bungalows',
        description: 'Stay above crystal-clear waters',
        children: [
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?borabora',
            title: 'Bora Bora',
            location: 'French Polynesia',
            rating: 4.9,
            tags: ['Romance', 'Views', 'Luxury'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?maldives',
            title: 'Maldives',
            location: 'Indian Ocean',
            rating: 4.8,
            tags: ['Private', 'Beaches', 'Snorkeling'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?fiji',
            title: 'Fiji',
            location: 'South Pacific',
            rating: 4.7,
            tags: ['Culture', 'Relaxation', 'Island'],
          ),
        ],
      ),
    ]);
  }
}
