import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isRegistering = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Veuillez remplir tous les champs');
      return;
    }

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!success) {
      _showError('Email ou mot de passe incorrect');
    }
  }

  Future<void> _register() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      _showError('Veuillez remplir tous les champs');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showError('Le mot de passe doit contenir au moins 6 caractères');
      return;
    }

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.register(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
    );

    setState(() => _isLoading = false);

    if (!success) {
      _showError(
        'Erreur lors de l\'inscription. L\'email est peut-être déjà utilisé.',
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _toggleMode() {
    setState(() {
      _isRegistering = !_isRegistering;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8B0000),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.library_books,
                      size: 64,
                      color: Color(0xFF8B0000),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Mediacité',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _isRegistering
                          ? 'Créez votre compte'
                          : 'Votre médiathèque numérique',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 32),

                    if (_isRegistering) ...[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nom complet',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],

                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 24),

                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B0000),
                          ),
                          onPressed: _isRegistering ? _register : _login,
                          child: Text(
                            _isRegistering ? 'S\'inscrire' : 'Se connecter',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: _toggleMode,
                      child: Text(
                        _isRegistering
                            ? 'Déjà un compte ? Se connecter'
                            : 'Pas de compte ? S\'inscrire',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
