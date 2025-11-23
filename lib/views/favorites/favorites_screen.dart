import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/favorite_service.dart';
import '../../services/borrowing_service.dart';
import '../../models/favorite_model.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Favoris'),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: _buildFavoritesList(context),
    );
  }

  Widget _buildFavoritesList(BuildContext context) {
    return StreamBuilder<List<Favorite>>(
      stream: Provider.of<FavoriteService>(context).getUserFavorites(),
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
                    setState(() {});
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
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Aucun favori'),
                Text(
                  'Ajoutez des médias à vos favoris depuis le catalogue',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final favorites = snapshot.data!;

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final favorite = favorites[index];
            return _buildFavoriteItem(context, favorite);
          },
        );
      },
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Favorite favorite) {
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
          child: _getMediaIcon(favorite.mediaType),
        ),
        title: Text(favorite.mediaTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(favorite.mediaAuthor),
            Chip(
              label: Text(
                favorite.mediaType.toUpperCase(),
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: Color(0xFF8B0000),
            ),
            Text(
              'Ajouté le ${_formatDate(favorite.addedDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick borrow button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B0000),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () {
                _quickBorrow(context, favorite);
              },
              child: Text(
                'Emprunter',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
            // Remove favorite button
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removeFavorite(context, favorite);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMediaIcon(String mediaType) {
    switch (mediaType) {
      case 'book':
        return Icon(Icons.menu_book, color: Colors.grey[600]);
      case 'film':
        return Icon(Icons.movie, color: Colors.grey[600]);
      case 'magazine':
        return Icon(Icons.article, color: Colors.grey[600]);
      default:
        return Icon(Icons.library_books, color: Colors.grey[600]);
    }
  }

  void _quickBorrow(BuildContext context, Favorite favorite) async {
    try {
      await Provider.of<BorrowingService>(
        context,
        listen: false,
      ).borrowMedia(favorite.mediaId, favorite.mediaTitle);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${favorite.mediaTitle}" emprunté avec succès!'),
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

  void _removeFavorite(BuildContext context, Favorite favorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Retirer des favoris'),
        content: Text(
          'Voulez-vous retirer "${favorite.mediaTitle}" de vos favoris ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await Provider.of<FavoriteService>(
                  context,
                  listen: false,
                ).removeFromFavorites(favorite.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Retiré des favoris'),
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
            child: Text('Retirer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
