// lib/pages/chat/events_tab.dart

import 'package:flutter/material.dart';
import 'trending_tab.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.only(bottom: 100), children: [
      const SizedBox(height: 24),
      CategorySection(
        title: '🎭 Cultural Festivals',
        description: 'Celebrations around the world',
        children: [
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?carnival',
            title: 'Rio Carnival',
            location: 'Rio de Janeiro, Brazil',
            rating: 4.9,
            tags: ['Dance', 'Parade', 'Music'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?diwali',
            title: 'Diwali',
            location: 'India',
            rating: 4.8,
            tags: ['Lights', 'Culture', 'Tradition'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?oktoberfest',
            title: 'Oktoberfest',
            location: 'Munich, Germany',
            rating: 4.7,
            tags: ['Beer', 'Food', 'Music'],
          ),
        ],
      ),
      const SizedBox(height: 24),
      CategorySection(
        title: '🎵 Music Festivals',
        description: 'Unforgettable musical experiences',
        children: [
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?coachella',
            title: 'Coachella',
            location: 'California, USA',
            rating: 4.7,
            tags: ['Music', 'Art', 'Camping'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?glastonbury',
            title: 'Glastonbury',
            location: 'Somerset, UK',
            rating: 4.8,
            tags: ['Music', 'Culture', 'Camping'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?tomorrowland',
            title: 'Tomorrowland',
            location: 'Boom, Belgium',
            rating: 4.9,
            tags: ['EDM', 'Production', 'International'],
          ),
        ],
      ),
    ]);
  }
}
