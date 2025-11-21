/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home/home_screen.dart';
import 'catalog/catalog_screen.dart';
import 'borrowing/borrowing_screen.dart'; // Add this import
import 'profile/profile_screen.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CatalogScreen(),
    BorrowingScreen(), // Replace EventsScreen with BorrowingScreen
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mediacité'),
        backgroundColor: Color(0xFF8B0000),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Catalogue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history), // Changed icon
            label: 'Mes Emprunts', // Changed label
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home/home_screen.dart';
import 'catalog/catalog_screen.dart';
import 'borrowing/borrowing_screen.dart'; // Add this import
import 'profile/profile_screen.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CatalogScreen(),
    BorrowingScreen(), // Replace EventsScreen with BorrowingScreen
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mediacité'),
        backgroundColor: Color(0xFF8B0000),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Catalogue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history), // Changed icon
            label: 'Mes Emprunts', // Changed label
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
