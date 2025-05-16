import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelinePage extends StatelessWidget {
  final Map<String, dynamic> resultData;
  const TimelinePage({super.key, required this.resultData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: TravelPlannerScreen(resultData: resultData),
    );
  }
}

class TravelPlannerScreen extends StatefulWidget {
  final Map<String, dynamic> resultData;
  const TravelPlannerScreen({
    super.key,
    required this.resultData,
  });

  @override
  State<TravelPlannerScreen> createState() => _TravelPlannerScreenState();
}

class _TravelPlannerScreenState extends State<TravelPlannerScreen> {
  int _selectedDayIndex = 0;
  late List<TripDay> _tripDays;
  String _tripName = '';

  @override
  void initState() {
    super.initState();
    // parse the JSON you already have:
    _tripName = widget.resultData['tripName'] as String? ?? '';
    _tripDays = (widget.resultData['days'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((dayMap) {
      final date = DateTime.parse(dayMap['date'] as String);
      final budget = Budget.fromJson(dayMap['budget'] as Map<String, dynamic>);
      final activities = (dayMap['activities'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Activity.fromJson)
          .toList();
      return TripDay(date: date, activities: activities, budget: budget);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          SizedBox(height: kToolbarHeight), 
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {},
            ),
            title: Text(
              '${_tripName}Trip Plan',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          Expanded(
            child: Column(
              children: [
                _buildDaySelection(),
                _buildBudgetSection(),
                Expanded(child: _buildTimeline()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelection() {
    return Container(
      height: 80,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tripDays.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedDayIndex;
          final day = _tripDays[index];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                ),
                boxShadow: isSelected 
                    ? [BoxShadow(
                        color: Colors.black.withAlpha((0.05*255).toInt()),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Day ${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM').format(day.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudgetSection() {
    final selectedDay = _tripDays[_selectedDayIndex];
    final budget = selectedDay.budget;
    
    // Format currency
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedTotal = formatter.format(budget.amount);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Budget / Person',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${budget.currency} ${formattedTotal}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE67E22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildBudgetCategoryCard(
                  'Accommodation',
                  budget.categories['accommodation'] ?? 0,
                  budget.currency,
                  Icons.hotel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBudgetCategoryCard(
                  'Food',
                  budget.categories['food'] ?? 0,
                  budget.currency,
                  Icons.restaurant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildBudgetCategoryCard(
                  'Transport',
                  budget.categories['transportation'] ?? 0,
                  budget.currency,
                  Icons.directions_car,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBudgetCategoryCard(
                  'Activities',
                  budget.categories['activities'] ?? 0,
                  budget.currency,
                  Icons.hiking,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCategoryCard(String title, int amount, String currency, IconData icon) {
    // Format currency
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedAmount = formatter.format(amount);
    
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xFFE67E22).withAlpha((0.1*255).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: Color(0xFFE67E22),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${currency} ${formattedAmount}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final selectedDay = _tripDays[_selectedDayIndex];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: selectedDay.activities.length,
      itemBuilder: (context, index) {
        final activity = selectedDay.activities[index];
        final isFirst = index == 0;
        final isLast = index == selectedDay.activities.length - 1;
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Timeline column ────────────────────────────────
              SizedBox(
                width: 30,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Top line
                    if (!isFirst)
                      SizedBox(
                        width: 2,
                        child: CustomPaint(
                          painter: DashedLinePainter(
                            color: Color(0xFFE67E22),
                            dashLength: 3,
                            dashGap: 3,
                          ),
                        ),
                      ),
                    
                    // Dot
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFE67E22),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    
                    // Bottom line grows to fill rest of the row
                    if (!isLast)
                      Expanded(
                        child: SizedBox(
                          width: 2,
                          child: CustomPaint(
                            painter: DashedLinePainter(
                              color: Color(0xFFE67E22),
                              dashLength: 3,
                              dashGap: 3,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // ─── Activity card ────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                  child: _buildActivityCard(activity),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'FLIGHT':
        return Color(0xFFE67E22); // Changed to orange to match the image
      case 'HOTEL':
        return Color(0xFFE67E22);
      case 'ACTIVITY':
        return Color(0xFFE67E22);
      case 'EXCURSION':
        return Color(0xFFE67E22);
      case 'BREAKFAST':
      case 'LUNCH':
      case 'DINNER':
        return Color(0xFFE67E22);
      default:
        return Color(0xFFE67E22);
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'FLIGHT':
        return Icons.flight;
      case 'HOTEL':
        return Icons.hotel;
      case 'ACTIVITY':
        return Icons.directions_walk;
      case 'EXCURSION':
        return Icons.terrain;
      case 'BREAKFAST':
      case 'LUNCH':
      case 'DINNER':
        return Icons.restaurant;
      default:
        return Icons.event;
    }
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05*255).toInt()),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getActivityColor(activity.type).withAlpha((0.1*255).toInt()),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getActivityIcon(activity.type),
                    color: _getActivityColor(activity.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildActivityDetails(activity),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  activity.time,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityDetails(Activity activity) {
    final details = activity.details;
    
    switch (activity.type) {
      case 'FLIGHT':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${details['from']}'),
            Text('To: ${details['to']}'),
          ],
        );
      case 'HOTEL':
      case 'ACTIVITY':
      case 'EXCURSION':
        return Text(details['action'] ?? '');
      case 'BREAKFAST':
      case 'LUNCH':
      case 'DINNER':
        return Text(details['location'] ?? '');
      default:
        return Container();
    }
  }
}

// Custom painter to draw a dashed line
class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashLength;
  final double dashGap;

  DashedLinePainter({
    required this.color,
    required this.dashLength,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      // Draw a dash
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashLength),
        paint,
      );
      // Move to next dash position
      startY += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TripDay {
  final DateTime date;
  final List<Activity> activities;
  final Budget budget;
  
  TripDay({
    required this.date, 
    required this.activities,
    required this.budget,
  });
}

class Budget {
  final int amount;
  final String currency;
  final Map<String, int> categories;
  
  Budget({
    required this.amount,
    required this.currency,
    required this.categories,
  });
  
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      amount: json['amount'],
      currency: json['currency'],
      categories: Map<String, int>.from(json['categories']),
    );
  }
}

class Activity {
  final String type;
  final String title;
  final String time;
  final Map<String, dynamic> details;
  
  Activity({
    required this.type,
    required this.title,
    required this.time,
    required this.details,
  });
  
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      type: json['type'],
      title: json['title'],
      time: json['time'],
      details: json['details'],
    );
  }
}