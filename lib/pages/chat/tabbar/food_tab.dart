// lib/pages/chat/food_tab.dart

import 'package:flutter/material.dart';
import 'trending_tab.dart';

class FoodTab extends StatelessWidget {
  const FoodTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.only(bottom: 100), children: [
      const SizedBox(height: 24),
      CategorySection(
        title: '🍽️ Culinary Destinations',
        description: 'Cities known for exceptional cuisine',
        children: [
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?tokyofood',
            title: 'Tokyo, Japan',
            location: 'Culinary Capital',
            rating: 4.9,
            tags: ['Sushi', 'Ramen', 'Street Food'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?lyonfood',
            title: 'Lyon, France',
            location: 'Gastronomy Hub',
            rating: 4.8,
            tags: ['Fine Dining', 'Wine', 'Tradition'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?bangkokfood',
            title: 'Bangkok, Thailand',
            location: 'Street Food Paradise',
            rating: 4.7,
            tags: ['Spicy', 'Markets', 'Variety'],
          ),
        ],
      ),
      const SizedBox(height: 24),
      CategorySection(
        title: '🍷 Wine Regions',
        description: 'Perfect regions for wine lovers',
        children: [
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?bordeauxwine',
            title: 'Bordeaux, France',
            location: 'Wine Country',
            rating: 4.9,
            tags: ['Vineyards', 'Tasting', 'Tours'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?napa',
            title: 'Napa Valley, USA',
            location: 'California Wine',
            rating: 4.8,
            tags: ['Wineries', 'Gourmet', 'Views'],
          ),
          DestinationCard(
            imageUrl: 'https://source.unsplash.com/random/300x200/?tuscany',
            title: 'Tuscany, Italy',
            location: 'Italian Wine',
            rating: 4.7,
            tags: ['Chianti', 'Countryside', 'Cuisine'],
          ),
        ],
      ),
    ]);
  }
}
