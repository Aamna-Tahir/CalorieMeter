import 'package:calorieMeter/login.dart';
import 'package:flutter/material.dart';
import 'boardpage.dart';
import 'package:calorieMeter/diet_plan_screen.dart';
import 'package:calorieMeter/homescreen.dart';
import 'scan.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';


class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  int _selectedIndex = 0;
  //int _drawerSelectedIndex = 0;

  // List of pages for each tab
  final List<Widget> _pages = [
    HomeScreen(),
    DietPlanScreen(), 
    const scan(),
    BoardPage(), 
    profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //_drawerSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          color: Colors.green, 
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.green, 
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
              
              Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? Color(0xFF37474F).withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Home', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(0);
                  },
                ),
              ),

              // Diet Plan
        Container(
          decoration: BoxDecoration(
            color: _selectedIndex == 1 ? Color(0xFF37474F).withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
                leading: Icon(Icons.fastfood, color:Colors.white),
                title: Text('Diet Plan', style: TextStyle(color:Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(1);
                },
              ),
        ),
              // Scan
        Container(
          decoration: BoxDecoration(
            color: _selectedIndex == 2 ? Color(0xFF37474F).withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
                leading: Icon(Icons.camera_alt, color:Colors.white),
                title: Text('Scan an Image', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(2);
                },
              ),
        ),
              // Achievement Feats
        Container(
          decoration: BoxDecoration(
            color: _selectedIndex == 3 ? Color(0xFF37474F).withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: ImageIcon(
              AssetImage('assets/target.png'),
              color: Colors.white, // if you want it white
              size: 28,
            ),
            title: Text('Feats', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(3);
            },
          ),
        ),
          
        Container(
          decoration: BoxDecoration(
            color: _selectedIndex == 4 ? Color(0xFF37474F).withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('My Profile', style: TextStyle(color:Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(4);
                },
              ),
        ),
              const Divider(color: Colors.white70),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context); 

                  
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => login()), 
                  );
                },
              ),

            ],
          ),
        ),
      ),

      
      appBar: AppBar(
        title: const Text('Calorie Meter'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
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

      
      body: _pages[_selectedIndex],

     
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green, 
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
          icon: ImageIcon(
            AssetImage('assets/target.png'),
            size: 24,
          
          ),
          activeIcon: ImageIcon(
            AssetImage('assets/target.png'),
            size: 28,
            color: Colors.green, 
          ),
          label: 'Feats',
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
