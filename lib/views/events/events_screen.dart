import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Événements'),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: Column(
        children: [
          // Category filter
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Tous', 'all'),
                  _buildCategoryChip('Culture', 'Cultural'),
                  _buildCategoryChip('Atelier', 'Workshop'),
                  _buildCategoryChip('Conférence', 'Conference'),
                  _buildCategoryChip('Jeunesse', 'Youth'),
                ],
              ),
            ),
          ),
          // Events list
          Expanded(child: _buildEventsList()),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String category) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedCategory == category,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildEventsList() {
    return StreamBuilder<List<Event>>(
      stream: _selectedCategory == 'all'
          ? Provider.of<EventService>(context).getUpcomingEvents()
          : Provider.of<EventService>(
              context,
            ).getEventsByCategory(_selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Aucun événement à venir'),
                Text(
                  'Revenez plus tard pour découvrir nos activités',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final events = snapshot.data!;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventItem(context, event);
          },
        );
      },
    );
  }

  Widget _buildEventItem(BuildContext context, Event event) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
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
            _buildParticipantsInfo(event),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showEventDetails(context, event);
        },
      ),
    );
  }

  Widget _buildParticipantsInfo(Event event) {
    return Row(
      children: [
        Icon(Icons.people, size: 12, color: Colors.grey),
        SizedBox(width: 4),
        Text(
          '${event.currentParticipants}/${event.maxParticipants}',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(width: 8),
        if (event.isFull)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'COMPLET',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return EventDetailsSheet(event: event);
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }
}

class EventDetailsSheet extends StatelessWidget {
  final Event event;

  const EventDetailsSheet({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: event.imageUrl.isNotEmpty
                  ? Image.network(event.imageUrl, fit: BoxFit.cover)
                  : Icon(Icons.event, size: 40, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 16),
          Text(
            event.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Chip(
            label: Text(event.category.toUpperCase()),
            backgroundColor: Color(0xFF8B0000),
            labelStyle: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 8),
              Text(_formatDate(event.date)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16),
              SizedBox(width: 8),
              Text(event.location),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Participants: ${event.currentParticipants}/${event.maxParticipants}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(event.description),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: StreamBuilder<bool>(
              stream: Provider.of<EventService>(
                context,
              ).isUserRegistered(event.id),
              builder: (context, snapshot) {
                final isRegistered = snapshot.data ?? false;

                if (isRegistered) {
                  // Show cancel button if registered
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erreur: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Annuler l\'inscription',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  // Show register button if not registered
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: event.canRegister
                          ? Color(0xFF8B0000)
                          : Colors.grey,
                    ),
                    onPressed: event.canRegister
                        ? () async {
                            try {
                              await Provider.of<EventService>(
                                context,
                                listen: false,
                              ).registerForEvent(event.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Inscription confirmée!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erreur: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text(
                      event.isFull
                          ? 'Complet'
                          : !event.canRegister
                          ? 'Inscriptions closes'
                          : 'S\'inscrire',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }
}
