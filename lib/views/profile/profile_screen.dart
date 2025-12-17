/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../favorites/favorites_screen.dart'; // Corrected import path

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF8B0000),
                      child: Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Utilisateur',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(user?.email ?? ''),
                    SizedBox(height: 8),
                    Chip(
                      label: Text(
                        user?.role?.toUpperCase() ?? 'USER',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: Color(0xFF8B0000),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Membre depuis ${_formatDate(user?.membershipDate)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Profile Options
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.favorite, color: Color(0xFF8B0000)),
                    title: Text('Mes Favoris'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.history, color: Color(0xFF8B0000)),
                    title: Text('Historique des emprunts'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Utilisez l\'onglet "Mes Emprunts"'),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.settings, color: Color(0xFF8B0000)),
                    title: Text('Paramètres'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Paramètres à venir')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.day}/${date.month}/${date.year}';
  }
}
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../favorites/favorites_screen.dart';
import '../events/my_events_screen.dart'; // ADD THIS IMPORT

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF8B0000),
                      child: Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Utilisateur',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(user?.email ?? ''),
                    SizedBox(height: 8),
                    Chip(
                      label: Text(
                        user?.role?.toUpperCase() ?? 'USER',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: Color(0xFF8B0000),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Membre depuis ${_formatDate(user?.membershipDate)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Profile Options
            Card(
              elevation: 4,
              child: Column(
                children: [
                  // Favorites option
                  ListTile(
                    leading: Icon(Icons.favorite, color: Color(0xFF8B0000)),
                    title: Text('Mes Favoris'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),

                  // My Events option - NEW ADDITION
                  ListTile(
                    leading: Icon(
                      Icons.event_available,
                      color: Color(0xFF8B0000),
                    ),
                    title: Text('Mes Événements'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyEventsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),

                  // Borrowing history option
                  ListTile(
                    leading: Icon(Icons.history, color: Color(0xFF8B0000)),
                    title: Text('Historique des emprunts'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Utilisez l\'onglet "Mes Emprunts"'),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),

                  // Settings option
                  ListTile(
                    leading: Icon(Icons.settings, color: Color(0xFF8B0000)),
                    title: Text('Paramètres'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Paramètres à venir')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.day}/${date.month}/${date.year}';
  }
}
