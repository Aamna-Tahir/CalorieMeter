import 'package:flutter/material.dart';
import 'package:calorieMeter/comunityscreen.dart';
import 'package:calorieMeter/diet%20plan%20screen.dart';
import 'package:calorieMeter/homescreen.dart';
import 'scan.dart';
import 'profile.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  int _selectedIndex = 0;

  // List of pages for each tab
  final List<Widget> _pages = [
    HomeScreen(),
    DietPlanScreen(), // Diet Plan Page
    const scan(),
    CommunityFeedScreen(), // Community Page
    profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Add a Drawer
      drawer: Drawer(
        child: Container(
          color: Colors.green, // Drawer background color
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 2. Header Section (with logo and text)
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.green, // Matches the drawer background
                ),
             //child: SingleChildScrollView(
                //reverse: true,
                //padding : EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo or any other image
                    CircleAvatar(
                      radius: 35,
                     backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/logoIcon.png',
                        fit: BoxFit.cover,
                        height: 85,
                        width: 80,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                  ],
                ),
             //),
              ),
              // 3. Drawer Items
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Home',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate or perform any action
                  Navigator.pop(context); // Closes the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.white),
                title: const Text('Diet Plan',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text('Scan an Image',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people, color: Colors.white),
                title: const Text('Community',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('My Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.white70),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Logout',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Add your logout logic here
                },
              ),
            ],
          ),
        ),
      ),

      // 4. AppBar with a menu icon that opens the Drawer
      appBar: AppBar(
        title: const Text('Calorie Meter'),
        centerTitle: true,
        // Use a Builder so we can open the Drawer programmatically
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // This manually opens the Drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/logoIcon.png'),
          ),
        ],
      ),

      // 5. Main content for each bottom navigation tab
      body: _pages[_selectedIndex],

      // 6. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green, // Active tab color
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Diet Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
