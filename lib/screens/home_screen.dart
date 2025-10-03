import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tirtha_suraksha/screens/monastery_detail_screen.dart';
import 'package:tirtha_suraksha/screens/sos_screen.dart';
import 'package:tirtha_suraksha/screens/coming_soon_screen.dart';
import 'package:tirtha_suraksha/screens/services_screen.dart';

class HomeScreen extends StatefulWidget {
  // It now accepts the user's name
  final String userName;
  const HomeScreen({super.key, required this.userName});

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
    final headlineColor = Theme.of(context).textTheme.headlineLarge?.color;
    final subheadlineColor =
        Theme.of(context).textTheme.headlineMedium?.color?.withOpacity(0.7);

    return Scaffold(
      // The new drawer for the hamburger menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Tirtha Suraksha',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // The leading icon now opens the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            // The avatar now uses the new illustration
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/avatars/boy_avatar.png'),
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
            Text('Hello,', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: subheadlineColor)),
            // The name is now dynamic from the login screen
            Text(widget.userName, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: headlineColor)),
            const SizedBox(height: 24),
            Text('Where shall we guide you today?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: headlineColor)),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search temples, rituals, places...',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
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
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildExploreCard(
                          title: 'Live 360° Darshan',
                          imagePath: 'assets/images/phodong_monastery.jpg',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MonasteryDetailScreen()));
                          },
                        ),
                        _buildExploreCard(
                          title: 'Temple History',
                          color: Colors.orange[300],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingSoonScreen(featureName: 'Temple History')));
                          },
                        ),
                        _buildExploreCard(
                          title: 'Festival Schedule',
                          color: Colors.grey[300],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingSoonScreen(featureName: 'Festival Schedule')));
                          },
                        ),
                        _buildExploreCard(
                          title: 'Book Services',
                          color: Colors.green[200],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ServicesScreen()));
                          },
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
                context, MaterialPageRoute(builder: (context) => const SosScreen()));
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

  Widget _buildExploreCard(
      {required String title,
      String? imagePath,
      Color? color,
      VoidCallback? onTap}) {
    final textColor = (imagePath != null)
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

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
                    image: AssetImage(imagePath), fit: BoxFit.cover)
                : null,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
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
  MapType _currentMapType = MapType.normal;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(23.4247, 88.3892),
    zoom: 15.0,
  );

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('iskconMayapur'),
      position: LatLng(23.4247, 88.3892),
      infoWindow: InfoWindow(
        title: 'ISKCON Mayapur (TOVP)',
        snippet: 'Temple of the Vedic Planetarium',
      ),
    ),
  };

  void _toggleMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                markers: _markers,
                mapType: _currentMapType,
                gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer())
                }),
            Positioned(
              top: 10,
              right: 10,
              child: FloatingActionButton.small(
                onPressed: _toggleMapType,
                child: const Icon(Icons.map),
              ),
            ),
          ],
        ),
      ),
    );
  }
}