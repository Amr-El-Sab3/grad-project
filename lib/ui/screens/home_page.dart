import 'package:emotion_detection/ui/screens/camera_screen.dart';
import 'package:emotion_detection/ui/screens/collections_screen.dart';
import 'package:emotion_detection/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 1;

  final List<Widget> _pages = [
    const MyDrawer(),
    const CameraScreen(),
    const CollectionsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    Theme.of(context);

    return Scaffold(
      body: _pages[selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          child: GNav(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              color: Colors.white,
              activeColor: Theme.of(context).colorScheme.tertiary,
              tabBackgroundColor: Colors.black12,
              padding: const EdgeInsets.all(16),
              selectedIndex: 1,
              gap: 8,
              onTabChange: _onItemTapped,
              tabs: const [
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
                GButton(
                  icon: Icons.camera_alt_outlined,
                  text: "Camera",
                ),
                GButton(
                  icon: Icons.folder_copy,
                  text: "Collections",
                ),
              ]),
        ),
      ),
    );
  }
}
