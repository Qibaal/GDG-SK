// lib/pages/chat/tab_navigation.dart

import 'package:flutter/material.dart';

class TabNavigation extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  const TabNavigation({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF858C95).withOpacity(0.3),
        border: Border.all(color: const Color(0xFF858C95)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: Colors.black,
        unselectedLabelColor: const Color.fromARGB(221, 2, 30, 100),
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF48CAE4), Color(0xFF90E0EF)]),
          borderRadius: BorderRadius.circular(8),
        ),
        tabs: const [
          Tab(icon: Icon(Icons.trending_up), text: 'Trending'),
          Tab(icon: Icon(Icons.restaurant), text: 'Food'),
          Tab(icon: Icon(Icons.hotel), text: 'Stays'),
          Tab(icon: Icon(Icons.event), text: 'Events'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
