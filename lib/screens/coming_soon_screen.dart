import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  final String featureName;
  const ComingSoonScreen({super.key, required this.featureName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(featureName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              '$featureName Feature',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            // --- THIS IS THE FIX ---
            Text(
              'This feature is currently under development.',
              style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }
}
