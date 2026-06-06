import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<CoursePage> {
  late Future<Activity> _futureActivity;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    _futureActivity = fetchActivity();
  }

  // API Fetch Function
  Future<Activity> fetchActivity() async {
    final response = await http.get(
      Uri.parse('https://bored-api.appbrewery.com/random'),
    );

    if (response.statusCode == 200) {
      return Activity.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load activity (Status: ${response.statusCode})',
      );
    }
  }

  // Refresh helper
  void _refreshActivity() {
    setState(() {
      _futureActivity = fetchActivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Activity Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFirst = !isFirst;
              });
            },
            icon: const Icon(Icons.switch_access_shortcut),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Activity>(
            future: _futureActivity,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                );
              } else if (snapshot.hasData) {
                final activity = snapshot.data!;
                // Correzione: Passiamo la variabile isFirst al widget figlio
                return ActivityCard(activity: activity, isFirst: isFirst);
              }
              return const Text('No data found.');
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshActivity,
        tooltip: 'Get New Activity',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// Separate UI Widget for presentation
class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isFirst; // Correzione: Dichiarata la variabile nel widget figlio

  // Correzione: Aggiunto 'required this.isFirst' al costruttore
  const ActivityCard({
    super.key,
    required this.activity,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedCrossFade(
          firstChild: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.activity,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Divider(height: 24),
              _buildInfoRow(Icons.category, 'Type', activity.type),
              _buildInfoRow(
                Icons.people,
                'Participants',
                activity.participants.toString(),
              ),
              _buildInfoRow(
                Icons.attach_money,
                'Price Factor',
                activity.price.toString(),
              ),
              _buildInfoRow(
                Icons.accessibility,
                'Accessibility',
                activity.accessibility,
              ),
              _buildInfoRow(
                Icons.child_care,
                'Kid Friendly',
                activity.kidFriendly ? 'Yes' : 'No',
              ),
              if (activity.link.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Link: ${activity.link}',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ],
          ),
          secondChild: Center(child: Image.asset('assets/images/cat.png')),
          crossFadeState: isFirst
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// --- The Activity Class ---
class Activity {
  final String activity;
  final double availability;
  final String type;
  final int participants;
  final double price;
  final String accessibility;
  final String duration;
  final bool kidFriendly;
  final String link;
  final String key;

  const Activity({
    required this.activity,
    required this.availability,
    required this.type,
    required this.participants,
    required this.price,
    required this.accessibility,
    required this.duration,
    required this.kidFriendly,
    required this.link,
    required this.key,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'activity': String activity,
        'availability': num availability,
        'type': String type,
        'participants': int participants,
        'price': num price,
        'accessibility': String accessibility,
        'duration': String duration,
        'kidFriendly': bool kidFriendly,
        'link': String link,
        'key': String key,
      } =>
        Activity(
          activity: activity,
          availability: availability.toDouble(),
          type: type,
          participants: participants,
          price: price.toDouble(),
          accessibility: accessibility,
          duration: duration,
          kidFriendly: kidFriendly,
          link: link,
          key: key,
        ),
      _ => throw const FormatException('Failed to load activity.'),
    };
  }
}
