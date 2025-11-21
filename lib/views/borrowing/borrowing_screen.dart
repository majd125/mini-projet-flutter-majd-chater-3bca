/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/borrowing_service.dart';
import '../../models/borrowing_model.dart';

class BorrowingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mes Emprunts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'En cours'),
              Tab(text: 'Historique'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Active borrowings tab
            _buildActiveBorrowings(context),
            // Borrowing history tab
            _buildBorrowingHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBorrowings(BuildContext context) {
    return StreamBuilder<List<Borrowing>>(
      stream: Provider.of<BorrowingService>(context).getUserBorrowings(),
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
                Icon(Icons.library_books, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Aucun emprunt en cours'),
                Text(
                  'Rendez-vous au catalogue pour emprunter',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final borrowings = snapshot.data!;

        return ListView.builder(
          itemCount: borrowings.length,
          itemBuilder: (context, index) {
            final borrowing = borrowings[index];
            return _buildBorrowingCard(context, borrowing, true);
          },
        );
      },
    );
  }

  Widget _buildBorrowingHistory(BuildContext context) {
    return StreamBuilder<List<Borrowing>>(
      stream: Provider.of<BorrowingService>(context).getUserBorrowingHistory(),
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
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Aucun historique d\'emprunt'),
              ],
            ),
          );
        }

        final borrowings = snapshot.data!
          ..sort((a, b) => b.borrowDate.compareTo(a.borrowDate));

        return ListView.builder(
          itemCount: borrowings.length,
          itemBuilder: (context, index) {
            final borrowing = borrowings[index];
            return _buildBorrowingCard(context, borrowing, false);
          },
        );
      },
    );
  }

  Widget _buildBorrowingCard(
    BuildContext context,
    Borrowing borrowing,
    bool isActive,
  ) {
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
          child: Icon(Icons.library_books, color: Colors.grey[600]),
        ),
        title: Text(borrowing.mediaTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emprunté le ${_formatDate(borrowing.borrowDate)}'),
            if (isActive) ...[
              Text('À rendre le ${_formatDate(borrowing.dueDate)}'),
              SizedBox(height: 4),
              _buildStatusChip(borrowing),
            ] else ...[
              Text('Retourné le ${_formatDate(borrowing.returnDate!)}'),
              Chip(
                label: Text('Retourné', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
                labelPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ],
          ],
        ),
        trailing: isActive
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B0000),
                ),
                onPressed: () {
                  _showReturnDialog(context, borrowing);
                },
                child: Text('Retourner', style: TextStyle(color: Colors.white)),
              )
            : null,
      ),
    );
  }

  Widget _buildStatusChip(Borrowing borrowing) {
    if (borrowing.isOverdue) {
      return Chip(
        label: Text('En retard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
      );
    } else if (borrowing.daysUntilDue <= 3) {
      return Chip(
        label: Text('Bientôt dû', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
      );
    } else {
      return Chip(
        label: Text('En cours', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
      );
    }
  }

  void _showReturnDialog(BuildContext context, Borrowing borrowing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Retourner le média'),
        content: Text('Voulez-vous retourner "${borrowing.mediaTitle}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              try {
                await Provider.of<BorrowingService>(
                  context,
                  listen: false,
                ).returnMedia(borrowing.id, borrowing.mediaId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '"${borrowing.mediaTitle}" retourné avec succès!',
                    ),
                    backgroundColor: Colors.green,
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
            child: Text('Confirmer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/borrowing_service.dart';
import '../../models/borrowing_model.dart';

class BorrowingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mes Emprunts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'En cours'),
              Tab(text: 'Historique'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildActiveBorrowings(context),
            _buildBorrowingHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBorrowings(BuildContext context) {
    return StreamBuilder<List<Borrowing>>(
      stream: Provider.of<BorrowingService>(context).getUserBorrowings(),
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
                Icon(Icons.library_books, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Aucun emprunt en cours'),
                Text(
                  'Rendez-vous au catalogue pour emprunter',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final borrowings = snapshot.data!;

        return ListView.builder(
          itemCount: borrowings.length,
          itemBuilder: (context, index) {
            final borrowing = borrowings[index];
            return _buildBorrowingCard(context, borrowing, true);
          },
        );
      },
    );
  }

  Widget _buildBorrowingHistory(BuildContext context) {
    return StreamBuilder<List<Borrowing>>(
      stream: Provider.of<BorrowingService>(context).getUserBorrowingHistory(),
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
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Aucun historique d\'emprunt'),
              ],
            ),
          );
        }

        final borrowings = snapshot.data!
          ..sort((a, b) => b.borrowDate.compareTo(a.borrowDate));

        return ListView.builder(
          itemCount: borrowings.length,
          itemBuilder: (context, index) {
            final borrowing = borrowings[index];
            return _buildBorrowingCard(context, borrowing, false);
          },
        );
      },
    );
  }

  Widget _buildBorrowingCard(
    BuildContext context,
    Borrowing borrowing,
    bool isActive,
  ) {
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
          child: Icon(Icons.library_books, color: Colors.grey[600]),
        ),
        title: Text(borrowing.mediaTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emprunté le ${_formatDate(borrowing.borrowDate)}'),
            if (isActive) ...[
              Text('À rendre le ${_formatDate(borrowing.dueDate)}'),
              SizedBox(height: 4),
              _buildStatusChip(borrowing),
            ] else ...[
              // FIX APPLIED: Protect against null returnDate
              if (borrowing.returnDate != null)
                Text('Retourné le ${_formatDate(borrowing.returnDate!)}'),
              Chip(
                label: Text('Retourné', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
                labelPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ],
          ],
        ),
        trailing: isActive
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B0000),
                ),
                onPressed: () {
                  _showReturnDialog(context, borrowing);
                },
                child: Text('Retourner', style: TextStyle(color: Colors.white)),
              )
            : null,
      ),
    );
  }

  Widget _buildStatusChip(Borrowing borrowing) {
    if (borrowing.isOverdue) {
      return Chip(
        label: Text('En retard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
      );
    } else if (borrowing.daysUntilDue <= 3) {
      return Chip(
        label: Text('Bientôt dû', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
      );
    } else {
      return Chip(
        label: Text('En cours', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
      );
    }
  }

  void _showReturnDialog(BuildContext context, Borrowing borrowing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Retourner le média'),
        content: Text('Voulez-vous retourner "${borrowing.mediaTitle}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              try {
                await Provider.of<BorrowingService>(
                  context,
                  listen: false,
                ).returnMedia(borrowing.id, borrowing.mediaId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '"${borrowing.mediaTitle}" retourné avec succès!',
                    ),
                    backgroundColor: Colors.green,
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
            child: Text('Confirmer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
