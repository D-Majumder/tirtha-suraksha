import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temple Services"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.book_online),
            title: const Text("Book a Puja"),
            subtitle: const Text("Coming Soon"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text("Order Bhoga / Prasad"),
            subtitle: const Text("Coming Soon"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: const Text("Make a Donation"),
            subtitle: const Text("Coming Soon"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}