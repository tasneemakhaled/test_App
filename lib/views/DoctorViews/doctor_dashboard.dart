import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/views/DoctorViews/doctorhomepage.dart';
import 'package:auti_warrior_app/views/DoctorViews/mothers_view.dart';
import 'package:auti_warrior_app/views/chats/ChatsView.dart';
import 'package:auti_warrior_app/widgets/Profile%20Widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0;
  final StorageService _storageService = StorageService();
  String? _firstName = '';
  String? _lastName = '';
  String? _role = '';
  String _profileImageUrl = '';
  File? _profileImageFile;

  // Computed property for full name
  String get fullName {
    return '${_firstName ?? ''} ${_lastName ?? ''}'.trim();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future _loadUserData() async {
    final firstName = await _storageService.getFirstName();
    final lastName = await _storageService.getLastName();
    final role = await _storageService.getRole();
    // You might need to add a method to get profile image in your StorageService
    // final profileImageUrl = await _storageService.getProfileImageUrl();

    setState(() {
      _firstName = firstName;
      _lastName = lastName;
      _role = role;
      // _profileImageUrl = profileImageUrl ?? '';
    });

    print("👩‍👦 HomeView loaded with role: $_role");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MothersView()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatsView()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        userName: fullName.isEmpty ? 'Doctor' : fullName,
        imageUrl: _profileImageFile == null ? _profileImageUrl : null,
        imageFile: _profileImageFile,
      ),
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Welcome Dr. ${_firstName?.isEmpty ?? true ? 'Doctor' : _firstName}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2A93D5),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16),
                childAspectRatio: 1.0,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildFeatureCard(
                    "Mothers List",
                    "View and manage mothers' profiles",
                    Icons.pregnant_woman,
                    Color(0xFFFF6B8B),
                  ),
                  _buildFeatureCard(
                    "Chat",
                    "Communicate with mothers",
                    Icons.chat_bubble_outline,
                    Color(0xFF49BEAA),
                  ),
                  _buildFeatureCard(
                    "Profile",
                    "Manage your profile",
                    Icons.person_outline,
                    Color(0xFF5E81F4),
                  ),
                  _buildFeatureCard(
                    "Reports",
                    "View follow-up reports",
                    Icons.analytics_outlined,
                    Color(0xFFFFA41B),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.pregnant_woman),
              label: 'Mothers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF2A93D5),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      String title, String subtitle, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        // Navigate based on the card title
        if (title == "Mothers List") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MothersView()),
          );
        } else if (title == "Chat") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatsView()),
          );
        } else if (title == "Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
          );
        } else if (title == "Reports") {
          // Add navigation for reports if needed
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
