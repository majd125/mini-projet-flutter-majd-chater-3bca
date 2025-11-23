import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../events/events_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChange;

  const HomeScreen({Key? key, required this.onTabChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, ${user?.name ?? ''}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Que souhaitez-vous faire aujourd\'hui ?',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),

            // Quick Actions Cards
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.library_books,
                        color: Color(0xFF8B0000),
                      ),
                      title: Text('Explorer le catalogue'),
                      subtitle: Text(
                        'Découvrez tous nos livres, magazines et films',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to catalog tab
                        onTabChange(1); // Catalogue is at index 1
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.event, color: Color(0xFF8B0000)),
                      title: Text('Événements à venir'),
                      subtitle: Text('Découvrez les activités culturelles'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Events opens as separate page
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventsScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.history, color: Color(0xFF8B0000)),
                      title: Text('Mes emprunts'),
                      subtitle: Text('Consultez votre historique'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to borrowing tab
                        onTabChange(2); // Mes Emprunts is at index 2
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Stats Section
            Text(
              'Votre activité',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Emprunts actifs',
                    value: '0',
                    color: Color(0xFF8B0000),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Réservations',
                    value: '0',
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
