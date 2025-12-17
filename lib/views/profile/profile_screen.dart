/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../favorites/favorites_screen.dart';
import '../events/my_events_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF8B0000),
                      child: Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Utilisateur',
                      style: TextStyle(
                        fontSize: 24,
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
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8B0000),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _showEditProfileDialog(context, user);
                      },
                      child: Text('Modifier le profil'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Quick Actions Card
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

                  // My Events option
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

                  // Change Password option
                  ListTile(
                    leading: Icon(Icons.lock, color: Color(0xFF8B0000)),
                    title: Text('Changer le mot de passe'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showChangePasswordDialog(context);
                    },
                  ),
                  Divider(height: 1),

                  // Change Email option
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF8B0000)),
                    title: Text('Changer l\'email'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showChangeEmailDialog(context, user);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                },
                child: Text('Se déconnecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserModel? user) {
    final _nameController = TextEditingController(text: user?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom complet',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Email actuel: ${user?.email ?? ''}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close this dialog
                _showChangeEmailDialog(context, user);
              },
              child: Text('Changer l\'email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              if (_nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Le nom ne peut pas être vide'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                // Use AuthService to update profile
                final success = await authService.updateProfile(
                  _nameController.text,
                );

                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profil mis à jour'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la mise à jour du profil'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context, UserModel? user) {
    final _newEmailController = TextEditingController(text: user?.email ?? '');
    final _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Changer l\'email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Email actuel: ${user?.email ?? ''}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newEmailController,
              decoration: InputDecoration(
                labelText: 'Nouvel email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel (pour confirmation)',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 8),
            Text(
              'Un email de vérification sera envoyé à votre nouvelle adresse.',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              // Validation
              if (_newEmailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Veuillez remplir tous les champs'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_newEmailController.text == user?.email) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Le nouvel email est identique à l\'ancien'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Email format validation
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(_newEmailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Format d\'email invalide'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                // First, re-authenticate the user
                final reauthenticated = await authService.reauthenticate(
                  _passwordController.text,
                );

                if (!reauthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mot de passe incorrect'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Then update the email
                final success = await authService.updateEmail(
                  _newEmailController.text,
                );

                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Email changé avec succès. Vérifiez votre nouvelle boîte mail.',
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors du changement d\'email'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Changer l\'email'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final _currentPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmer le nouveau mot de passe',
                prefixIcon: Icon(Icons.lock_reset),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 8),
            Text(
              'Le mot de passe doit contenir au moins 6 caractères.',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              // Validation
              if (_currentPasswordController.text.isEmpty ||
                  _newPasswordController.text.isEmpty ||
                  _confirmPasswordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Veuillez remplir tous les champs'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_newPasswordController.text !=
                  _confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Les nouveaux mots de passe ne correspondent pas',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Le mot de passe doit contenir au moins 6 caractères',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                // First, re-authenticate with current password
                final reauthenticated = await authService.reauthenticate(
                  _currentPasswordController.text,
                );

                if (!reauthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mot de passe actuel incorrect'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Then change the password
                final success = await authService.changePassword(
                  _newPasswordController.text,
                );

                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mot de passe changé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erreur lors du changement de mot de passe',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Changer'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../favorites/favorites_screen.dart';
import '../events/my_events_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      body: SafeArea(
        // Add SafeArea for better display
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF8B0000),
                          child: Text(
                            user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          user?.name ?? 'Utilisateur',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
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
                        SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B0000),
                            foregroundColor: Colors.white,
                            minimumSize: Size(
                              double.infinity,
                              48,
                            ), // Fixed height
                          ),
                          onPressed: () {
                            _showEditProfileDialog(context, user);
                          },
                          child: Text('Modifier le profil'),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Quick Actions Card
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

                      // My Events option
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

                      // Change Password option
                      ListTile(
                        leading: Icon(Icons.lock, color: Color(0xFF8B0000)),
                        title: Text('Changer le mot de passe'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showChangePasswordDialog(context);
                        },
                      ),
                      Divider(height: 1),

                      // Change Email option
                      ListTile(
                        leading: Icon(Icons.email, color: Color(0xFF8B0000)),
                        title: Text('Changer l\'email'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showChangeEmailDialog(context, user);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 52), // Fixed height
                    ),
                    onPressed: () {
                      Provider.of<AuthService>(context, listen: false).logout();
                    },
                    child: Text('Se déconnecter'),
                  ),
                ),

                SizedBox(height: 16), // Extra space at bottom for safety
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Rest of your methods remain exactly the same...
  void _showEditProfileDialog(BuildContext context, UserModel? user) {
    final _nameController = TextEditingController(text: user?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le profil'),
        content: SingleChildScrollView(
          // Add scroll to dialog too
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Email actuel: ${user?.email ?? ''}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close this dialog
                  _showChangeEmailDialog(context, user);
                },
                child: Text('Changer l\'email'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              if (_nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Le nom ne peut pas être vide'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                final success = await authService.updateProfile(
                  _nameController.text,
                );

                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profil mis à jour'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la mise à jour du profil'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context, UserModel? user) {
    final _newEmailController = TextEditingController(text: user?.email ?? '');
    final _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Changer l\'email'),
        content: SingleChildScrollView(
          // Add scroll to dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Email actuel: ${user?.email ?? ''}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _newEmailController,
                decoration: InputDecoration(
                  labelText: 'Nouvel email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe actuel (pour confirmation)',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 8),
              Text(
                'Un email de vérification sera envoyé à votre nouvelle adresse.',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              if (_newEmailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Veuillez remplir tous les champs'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_newEmailController.text == user?.email) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Le nouvel email est identique à l\'ancien'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(_newEmailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Format d\'email invalide'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                final reauthenticated = await authService.reauthenticate(
                  _passwordController.text,
                );

                if (!reauthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mot de passe incorrect'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final success = await authService.updateEmail(
                  _newEmailController.text,
                );

                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Email changé avec succès. Vérifiez votre nouvelle boîte mail.',
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors du changement d\'email'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Changer l\'email'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final _currentPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Changer le mot de passe'),
        content: SingleChildScrollView(
          // Add scroll to dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe actuel',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmer le nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock_reset),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 8),
              Text(
                'Le mot de passe doit contenir au moins 6 caractères.',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B0000)),
            onPressed: () async {
              if (_currentPasswordController.text.isEmpty ||
                  _newPasswordController.text.isEmpty ||
                  _confirmPasswordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Veuillez remplir tous les champs'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_newPasswordController.text !=
                  _confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Les nouveaux mots de passe ne correspondent pas',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Le mot de passe doit contenir au moins 6 caractères',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                final reauthenticated = await authService.reauthenticate(
                  _currentPasswordController.text,
                );

                if (!reauthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mot de passe actuel incorrect'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final success = await authService.changePassword(
                  _newPasswordController.text,
                );

                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mot de passe changé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erreur lors du changement de mot de passe',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Changer'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }
}
