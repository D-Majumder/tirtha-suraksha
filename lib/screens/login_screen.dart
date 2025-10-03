import 'package:flutter/material.dart';
import 'package:tirtha_suraksha/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();

  void _login() {
    // If no name is entered, default to "Pilgrim"
    final name = _nameController.text.isNotEmpty ? _nameController.text : "Pilgrim";
    // Navigate to the home screen, replacing the login screen in the stack
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(userName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a SafeArea to avoid system UI elements like the notch
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // We use a Column to structure the layout vertically
          child: Column(
            children: [
              // This Spacer pushes the main content to the center
              const Spacer(),

              // --- This is the main, centered content ---
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Using your logo now instead of the placeholder
                  Image.asset(
                    'assets/images/logo_for_splash.png', // Make sure this path is correct
                    height: 120,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Welcome to Tirtha Suraksha",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Please enter your name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _login(), // Allows login on pressing enter
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
              // --- End of main content ---

              // This Spacer pushes the footer to the bottom
              const Spacer(),

              // --- This is the new footer ---
              const Text(
                'Made by Team Gautama',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

