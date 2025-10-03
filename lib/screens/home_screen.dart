import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bodhicompasssihtest/screens/monastery_detail_screen.dart';
import 'package:bodhicompasssihtest/screens/sos_screen.dart';
import 'package:bodhicompasssihtest/screens/coming_soon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text('D', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Hello,', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.black54)),
            Text('Dhruv', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
            const SizedBox(height: 24),
            const Text('Where shall we guide you today?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search monasteries, rituals, places...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: 'Explore'),
                Tab(text: 'Guides'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildExploreCard(
                            title: 'Monasteries',
                            imagePath: 'assets/images/phodong_monastery.jpg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MonasteryDetailScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 8,
                                child: _buildExploreCard(
                                  title: 'Murals',
                                  color: Colors.orange[300],
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingSoonScreen(featureName: 'Murals')));
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                flex: 5,
                                child: _buildExploreCard(
                                  title: 'Cultural Calendar',
                                  color: Colors.grey[300],
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingSoonScreen(featureName: 'Cultural Calendar')));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MapWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) {
          if (index < 2) {
            _tabController.animateTo(index);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SosScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Guides'),
          BottomNavigationBarItem(icon: Icon(Icons.sos, color: Colors.red), label: 'SOS'),
        ],
      ),
    );
  }

  Widget _buildExploreCard({
    required String title,
    String? imagePath,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: color,
            image: imagePath != null
                ? DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(
                  color: imagePath != null ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: imagePath != null
                      ? [const Shadow(blurRadius: 10.0, color: Colors.black54)]
                      : [],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(27.3389, 88.6065),
    zoom: 11.5,
  );

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('rumtekMonastery'),
      position: LatLng(27.2897, 88.5683),
      infoWindow: InfoWindow(
        title: 'Rumtek Monastery',
        snippet: 'A famous monastery in Sikkim',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: _markers,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          }
        ),
      ),
    );
  }
}