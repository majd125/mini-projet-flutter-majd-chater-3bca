/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/catalog_service.dart';
import '../../models/media_model.dart';
import '../../services/borrowing_service.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogue'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MediaSearchDelegate());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tous', 'all'),
                  _buildFilterChip('Livres', 'book'),
                  _buildFilterChip('Magazines', 'magazine'),
                  _buildFilterChip('Films', 'film'),
                ],
              ),
            ),
          ),
          Expanded(child: _buildMediaList()),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == value,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildMediaList() {
    return StreamBuilder<List<Media>>(
      stream: _selectedFilter == 'all'
          ? Provider.of<CatalogService>(context).getMedia()
          : Provider.of<CatalogService>(
              context,
            ).getMediaByType(_selectedFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun média trouvé'));
        }

        final mediaList = snapshot.data!;

        return ListView.builder(
          itemCount: mediaList.length,
          itemBuilder: (context, index) {
            final media = mediaList[index];
            return _buildMediaItem(media);
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ FIXED VERSION OF _buildMediaItem (Availability Works Perfectly)
  // ---------------------------------------------------------------------------
  Widget _buildMediaItem(Media media) {
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
          child: media.imageUrl.isNotEmpty
              ? Image.network(media.imageUrl, fit: BoxFit.cover)
              : Icon(Icons.library_books, color: Colors.grey[600]),
        ),
        title: Text(media.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(media.author),
            Text(media.type.toUpperCase()),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: media.available ? Colors.green : Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  media.available ? 'Disponible' : 'Emprunté',
                  style: TextStyle(
                    color: media.available ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showMediaDetails(media);
        },
      ),
    );
  }

  void _showMediaDetails(Media media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MediaDetailsSheet(media: media);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// DETAILS SHEET (UNCHANGED EXCEPT FOR USING media.available CORRECTLY)
// ---------------------------------------------------------------------------

class MediaDetailsSheet extends StatelessWidget {
  final Media media;

  const MediaDetailsSheet({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borrowingService = Provider.of<BorrowingService>(
      context,
      listen: false,
    );

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
              child: media.imageUrl.isNotEmpty
                  ? Image.network(media.imageUrl, fit: BoxFit.cover)
                  : Icon(
                      Icons.library_books,
                      size: 40,
                      color: Colors.grey[600],
                    ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            media.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Par ${media.author}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Chip(
            label: Text(media.type.toUpperCase()),
            backgroundColor: Color(0xFF8B0000),
            labelStyle: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(media.description),
          SizedBox(height: 16),
          if (media.pages != null) Text('Pages: ${media.pages}'),
          if (media.duration != null) Text('Durée: ${media.duration} min'),
          SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: media.available
                    ? Color(0xFF8B0000)
                    : Colors.grey,
              ),
              onPressed: media.available
                  ? () async {
                      try {
                        await borrowingService.borrowMedia(
                          media.id,
                          media.title,
                        );
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '"${media.title}" emprunté avec succès!',
                            ),
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
                media.available ? 'Emprunter' : 'Indisponible',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SEARCH DELEGATE (UNCHANGED)
// ---------------------------------------------------------------------------

class MediaSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return StreamBuilder<List<Media>>(
      stream: Provider.of<CatalogService>(context).searchMedia(query),
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return Center(child: Text('Tapez quelque chose pour rechercher'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun résultat pour "$query"'));
        }

        final results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final media = results[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: media.imageUrl.isNotEmpty
                    ? Image.network(media.imageUrl, fit: BoxFit.cover)
                    : Icon(Icons.library_books, size: 20),
              ),
              title: Text(media.title),
              subtitle: Text(media.author),
              onTap: () {
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/catalog_service.dart';
import '../../services/favorite_service.dart';
import '../../models/media_model.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogue'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MediaSearchDelegate());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tous', 'all'),
                  _buildFilterChip('Livres', 'book'),
                  _buildFilterChip('Magazines', 'magazine'),
                  _buildFilterChip('Films', 'film'),
                ],
              ),
            ),
          ),
          // Media list
          Expanded(child: _buildMediaList()),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == value,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildMediaList() {
    return StreamBuilder<List<Media>>(
      stream: _selectedFilter == 'all'
          ? Provider.of<CatalogService>(context).getMedia()
          : Provider.of<CatalogService>(
              context,
            ).getMediaByType(_selectedFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun média trouvé'));
        }

        final mediaList = snapshot.data!;

        return ListView.builder(
          itemCount: mediaList.length,
          itemBuilder: (context, index) {
            final media = mediaList[index];
            return _buildMediaItem(context, media);
          },
        );
      },
    );
  }

  Widget _buildMediaItem(BuildContext context, Media media) {
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
          child: media.imageUrl.isNotEmpty
              ? Image.network(media.imageUrl, fit: BoxFit.cover)
              : Icon(Icons.library_books, color: Colors.grey[600]),
        ),
        title: Text(media.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(media.author),
            Text(media.type.toUpperCase()),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: media.available ? Colors.green : Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  media.available ? 'Disponible' : 'Emprunté',
                  style: TextStyle(
                    color: media.available ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Favorite button
            _buildFavoriteButton(context, media),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          _showMediaDetails(context, media);
        },
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, Media media) {
    return StreamBuilder<bool>(
      stream: Provider.of<FavoriteService>(
        context,
        listen: false,
      ).isMediaInFavorites(media.id),
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? false;

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
            size: 20,
          ),
          onPressed: () async {
            try {
              if (isFavorite) {
                await Provider.of<FavoriteService>(
                  context,
                  listen: false,
                ).removeFromFavoritesByMediaId(media.id);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Retiré des favoris')));
              } else {
                await Provider.of<FavoriteService>(
                  context,
                  listen: false,
                ).addToFavorites(
                  mediaId: media.id,
                  mediaTitle: media.title,
                  mediaType: media.type,
                  mediaAuthor: media.author,
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Ajouté aux favoris!')));
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: ${e.toString()}')),
              );
            }
          },
        );
      },
    );
  }

  void _showMediaDetails(BuildContext context, Media media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MediaDetailsSheet(media: media);
      },
    );
  }
}

class MediaDetailsSheet extends StatelessWidget {
  final Media media;

  const MediaDetailsSheet({Key? key, required this.media}) : super(key: key);

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
              child: media.imageUrl.isNotEmpty
                  ? Image.network(media.imageUrl, fit: BoxFit.cover)
                  : Icon(
                      Icons.library_books,
                      size: 40,
                      color: Colors.grey[600],
                    ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            media.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Par ${media.author}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Chip(
            label: Text(media.type.toUpperCase()),
            backgroundColor: Color(0xFF8B0000),
            labelStyle: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(media.description),
          SizedBox(height: 16),
          if (media.pages != null) Text('Pages: ${media.pages}'),
          if (media.duration != null) Text('Durée: ${media.duration} min'),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: media.available
                    ? Color(0xFF8B0000)
                    : Colors.grey,
              ),
              onPressed: media.available
                  ? () {
                      // TODO: Implement borrowing from details
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Utilisez le bouton emprunter dans la liste',
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(
                media.available ? 'Emprunter' : 'Indisponible',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MediaSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return StreamBuilder<List<Media>>(
      stream: Provider.of<CatalogService>(context).searchMedia(query),
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return Center(child: Text('Tapez quelque chose pour rechercher'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun résultat pour "$query"'));
        }

        final results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final media = results[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: media.imageUrl.isNotEmpty
                    ? Image.network(media.imageUrl, fit: BoxFit.cover)
                    : Icon(Icons.library_books, size: 20),
              ),
              title: Text(media.title),
              subtitle: Text(media.author),
              onTap: () {
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/catalog_service.dart';
import '../../services/favorite_service.dart';
import '../../services/borrowing_service.dart'; // << Added
import '../../models/media_model.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogue'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MediaSearchDelegate());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tous', 'all'),
                  _buildFilterChip('Livres', 'book'),
                  _buildFilterChip('Magazines', 'magazine'),
                  _buildFilterChip('Films', 'film'),
                ],
              ),
            ),
          ),
          Expanded(child: _buildMediaList()),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == value,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildMediaList() {
    return StreamBuilder<List<Media>>(
      stream: _selectedFilter == 'all'
          ? Provider.of<CatalogService>(context).getMedia()
          : Provider.of<CatalogService>(
              context,
            ).getMediaByType(_selectedFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun média trouvé'));
        }

        final mediaList = snapshot.data!;

        return ListView.builder(
          itemCount: mediaList.length,
          itemBuilder: (context, index) {
            final media = mediaList[index];
            return _buildMediaItem(context, media);
          },
        );
      },
    );
  }

  Widget _buildMediaItem(BuildContext context, Media media) {
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
          child: media.imageUrl.isNotEmpty
              ? Image.network(media.imageUrl, fit: BoxFit.cover)
              : Icon(Icons.library_books, color: Colors.grey[600]),
        ),
        title: Text(media.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(media.author),
            Text(media.type.toUpperCase()),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: media.available ? Colors.green : Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  media.available ? 'Disponible' : 'Emprunté',
                  style: TextStyle(
                    color: media.available ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFavoriteButton(context, media),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          _showMediaDetails(context, media);
        },
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, Media media) {
    return StreamBuilder<bool>(
      stream: Provider.of<FavoriteService>(
        context,
        listen: false,
      ).isMediaInFavorites(media.id),
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? false;

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
            size: 20,
          ),
          onPressed: () async {
            try {
              if (isFavorite) {
                await Provider.of<FavoriteService>(
                  context,
                  listen: false,
                ).removeFromFavoritesByMediaId(media.id);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Retiré des favoris')));
              } else {
                await Provider.of<FavoriteService>(
                  context,
                  listen: false,
                ).addToFavorites(
                  mediaId: media.id,
                  mediaTitle: media.title,
                  mediaType: media.type,
                  mediaAuthor: media.author,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Ajouté aux favoris!')));
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: ${e.toString()}')),
              );
            }
          },
        );
      },
    );
  }

  void _showMediaDetails(BuildContext context, Media media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MediaDetailsSheet(media: media);
      },
    );
  }
}

class MediaDetailsSheet extends StatelessWidget {
  final Media media;

  const MediaDetailsSheet({Key? key, required this.media}) : super(key: key);

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
              child: media.imageUrl.isNotEmpty
                  ? Image.network(media.imageUrl, fit: BoxFit.cover)
                  : Icon(
                      Icons.library_books,
                      size: 40,
                      color: Colors.grey[600],
                    ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            media.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Par ${media.author}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Chip(
            label: Text(media.type.toUpperCase()),
            backgroundColor: Color(0xFF8B0000),
            labelStyle: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(media.description),
          SizedBox(height: 16),
          if (media.pages != null) Text('Pages: ${media.pages}'),
          if (media.duration != null) Text('Durée: ${media.duration} min'),
          SizedBox(height: 16),

          // ✅ FIXED BUTTON (exactly as you asked)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: media.available
                    ? Color(0xFF8B0000)
                    : Colors.grey,
              ),
              onPressed: media.available
                  ? () async {
                      try {
                        await Provider.of<BorrowingService>(
                          context,
                          listen: false,
                        ).borrowMedia(media.id, media.title);

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '"${media.title}" emprunté avec succès!',
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
                    }
                  : null,
              child: Text(
                media.available ? 'Emprunter' : 'Indisponible',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MediaSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return StreamBuilder<List<Media>>(
      stream: Provider.of<CatalogService>(context).searchMedia(query),
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return Center(child: Text('Tapez quelque chose pour rechercher'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun résultat pour "$query"'));
        }

        final results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final media = results[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: media.imageUrl.isNotEmpty
                    ? Image.network(media.imageUrl, fit: BoxFit.cover)
                    : Icon(Icons.library_books, size: 20),
              ),
              title: Text(media.title),
              subtitle: Text(media.author),
              onTap: () {
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}
