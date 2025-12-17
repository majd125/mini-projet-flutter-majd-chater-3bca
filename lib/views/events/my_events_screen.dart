/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';

class MyEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Événements'),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: _buildMyEventsList(context), // PASS CONTEXT HERE
    );
  }

  Widget _buildMyEventsList(BuildContext context) {
    // ADD CONTEXT PARAMETER
    return StreamBuilder<List<EventRegistration>>(
      stream: Provider.of<EventService>(context).getUserRegistrations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Erreur de chargement'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // The stream will automatically refresh
                  },
                  child: Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Aucune inscription'),
                Text(
                  'Inscrivez-vous à des événements depuis le calendrier',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final registrations = snapshot.data!;

        return ListView.builder(
          itemCount: registrations.length,
          itemBuilder: (context, index) {
            final registration = registrations[index];
            return _buildEventRegistrationItem(context, registration);
          },
        );
      },
    );
  }

  Widget _buildEventRegistrationItem(
    BuildContext context,
    EventRegistration registration,
  ) {
    final event = registration.event;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: event.imageUrl.isNotEmpty
              ? Image.network(event.imageUrl, fit: BoxFit.cover)
              : Icon(Icons.event, color: Colors.grey[600]),
        ),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_formatDate(event.date)} - ${event.location}'),
            Text(event.category),
            SizedBox(height: 4),
            Text(
              'Inscrit le ${_formatDate(registration.registrationDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            _buildEventStatus(event),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            _showCancelDialog(context, event);
          },
        ),
      ),
    );
  }

  Widget _buildEventStatus(Event event) {
    if (event.date.isBefore(DateTime.now())) {
      return Chip(
        label: Text('Terminé', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
      );
    } else if (event.isFull) {
      return Chip(
        label: Text('Complet', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      );
    } else {
      return Chip(
        label: Text('À venir', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      );
    }
  }

  void _showCancelDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler l\'inscription'),
        content: Text(
          'Voulez-vous annuler votre inscription à "${event.title}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Non'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await Provider.of<EventService>(
                  context,
                  listen: false,
                ).cancelEventRegistration(event.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Inscription annulée'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Oui, annuler', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';

class MyEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Événements'),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: _buildMyEventsList(context),
    );
  }

  Widget _buildMyEventsList(BuildContext context) {
    return StreamBuilder<List<EventRegistration>>(
      stream: Provider.of<EventService>(context).getUserRegistrations(),
      builder: (context, snapshot) {
        print('📱 [UI] StreamBuilder state: ${snapshot.connectionState}');
        print('📱 [UI] Has data: ${snapshot.hasData}');
        print('📱 [UI] Has error: ${snapshot.hasError}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF8B0000)),
                SizedBox(height: 20),
                Text(
                  'Chargement des événements...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          print('📱 [UI] Error: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B0000),
                  ),
                  onPressed: () {
                    // Try loading again
                    // The stream will automatically refresh
                  },
                  child: Text(
                    'Réessayer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('📱 [UI] No data or empty list');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 100, color: Colors.grey[400]),
                SizedBox(height: 20),
                Text(
                  'Aucun événement inscrit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Inscrivez-vous à des événements depuis la page "Événements" pour les voir ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B0000),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Découvrir les événements',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final registrations = snapshot.data!;
        print('📱 [UI] Displaying ${registrations.length} events');

        return RefreshIndicator(
          onRefresh: () async {
            // The stream will automatically refresh
            return;
          },
          child: ListView.builder(
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final registration = registrations[index];
              return _buildEventRegistrationItem(context, registration);
            },
          ),
        );
      },
    );
  }

  Widget _buildEventRegistrationItem(
    BuildContext context,
    EventRegistration registration,
  ) {
    final event = registration.event;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            image: event.imageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(event.imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: event.imageUrl.isEmpty
              ? Icon(Icons.event, color: Colors.grey[500], size: 30)
              : null,
        ),
        title: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(_formatDate(event.date), style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(event.location, style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 6),
            _buildEventStatus(event),
            SizedBox(height: 4),
            Text(
              'Inscrit le ${_formatDate(registration.registrationDate)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: Colors.red),
          tooltip: 'Annuler l\'inscription',
          onPressed: () {
            _showCancelDialog(context, event);
          },
        ),
        onTap: () {
          // Optionally show event details
        },
      ),
    );
  }

  Widget _buildEventStatus(Event event) {
    final now = DateTime.now();

    if (event.date.isBefore(now)) {
      return Chip(
        label: Text(
          'Terminé',
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
        backgroundColor: Colors.grey[600],
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
    } else if (event.isFull) {
      return Chip(
        label: Text(
          'Complet',
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
    } else {
      return Chip(
        label: Text(
          'À venir',
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
        backgroundColor: Colors.green[500],
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
    }
  }

  void _showCancelDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler l\'inscription'),
        content: Text(
          'Voulez-vous annuler votre inscription à "${event.title}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Non'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await Provider.of<EventService>(
                  context,
                  listen: false,
                ).cancelEventRegistration(event.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Inscription annulée'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Text('Oui, annuler', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à ${hour}h$minute';
  }
}
