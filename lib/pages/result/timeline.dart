import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const TravelPlannerScreen(),
    );
  }
}

class TravelPlannerScreen extends StatefulWidget {
  const TravelPlannerScreen({super.key});

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
    // This would be replaced with actual API call to fetch data
    _loadTripData();
  }
  
  void _loadTripData() {
    // Mock data - this would come from your JSON backend
    final mockData = {
      "tripName": " Jakarta ",
      "days": [
        {
          "date": "2025-03-30",
          "activities": [
            {
              "type": "FLIGHT",
              "title": "Flight",
              "time": "8:30 AM",
              "details": {
                "from": "Los Angeles",
                "to": "Vancouver"
              }
            },
            {
              "type": "HOTEL",
              "title": "Hotel",
              "time": "11:00 AM",
              "details": {
                "action": "Rest"
              }
            },
            {
              "type": "ACTIVITY",
              "title": "Douglas Park",
              "time": "4:00 PM",
              "details": {
                "action": "Walk"
              }
            },
            {
              "type": "EXCURSION",
              "title": "Lynn Canyon",
              "time": "6:00 PM",
              "details": {
                "action": "Jeep Excursion"
              }
            },
            {
              "type": "LUNCH",
              "title": "Lunch",
              "time": "6:00 PM",
              "details": {
                "location": "Granville Island"
              }
            }
          ]
        },
        {
          "date": "2025-03-31",
          "activities": [
            {
              "type": "BREAKFAST",
              "title": "Breakfast",
              "time": "8:00 AM",
              "details": {
                "location": "Hotel Restaurant"
              }
            },
            {
              "type": "ACTIVITY",
              "title": "Stanley Park",
              "time": "10:00 AM",
              "details": {
                "action": "Biking"
              }
            },
            {
              "type": "LUNCH",
              "title": "Lunch",
              "time": "1:00 PM",
              "details": {
                "location": "Granville Island"
              }
            }
          ]
        },
        {
          "date": "2025-04-01",
          "activities": [
            {
              "type": "ACTIVITY",
              "title": "Grouse Mountain",
              "time": "9:00 AM",
              "details": {
                "action": "Hiking"
              }
            },
            {
              "type": "LUNCH",
              "title": "Lunch",
              "time": "12:30 PM",
              "details": {
                "location": "Mountain View Restaurant"
              }
            },
            {
              "type": "LUNCH",
              "title": "Lunch",
              "time": "12:30 PM",
              "details": {
                "location": "Mountain View Restaurant"
              }
            }
          ]
        }
      ]
    };
    
    _parseTripData(mockData);
  }
  
  void _parseTripData(Map<String, dynamic> data) {
    _tripName = data['tripName'] as String;
    _tripDays = (data['days'] as List).map((dayData) {
      final date = DateTime.parse(dayData['date']);
      final activities = (dayData['activities'] as List).map((activityData) {
        return Activity.fromJson(activityData);
      }).toList();
      
      return TripDay(date: date, activities: activities);
    }).toList();
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          '${_tripName}Trip Plan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDaySelection(),
          Expanded(
            child: _buildTimeline(),
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

  Widget _buildTimeline() {
  final selectedDay = _tripDays[_selectedDayIndex];
  
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: selectedDay.activities.length,
    itemBuilder: (context, index) {
      final activity = selectedDay.activities[index];
      final isFirst = index == 0;
      final isLast = index == selectedDay.activities.length - 1;
      
      return IntrinsicHeight(                                      // ①
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,         // ②
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
                    Expanded(                                       // ③
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
  
  TripDay({required this.date, required this.activities});
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

// To connect with a real backend, you would use something like:
class TripService {
  static Future<Map<String, dynamic>> fetchTripData(String tripId) async {
    // Using your preferred HTTP client (http, dio, etc.)
    // final response = await http.post(Uri.parse('https://your-api.com/trips/$tripId'));
    // return jsonDecode(response.body);
    
    // Mock implementation for example
    await Future.delayed(const Duration(seconds: 1));
    return {
      "tripName": "Canada trip plan",
      "days": [
        // Your data here...
      ]
    };
  }
}