import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

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
                    leading: Icon(Icons.history, color: Color(0xFF8B0000)),
                    title: Text('Historique des emprunts'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to borrowing history
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Color(0xFF8B0000)),
                    title: Text('Mes favoris'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to favorites
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.settings, color: Color(0xFF8B0000)),
                    title: Text('Paramètres'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to settings
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
