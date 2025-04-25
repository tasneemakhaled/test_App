import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/widgets/Home%20Widgets/home_body.dart';
import 'package:auti_warrior_app/widgets/Home%20Widgets/home_header.dart';
import 'package:auti_warrior_app/widgets/Home%20Widgets/home_navbar.dart';
import 'package:auti_warrior_app/widgets/Home%20Widgets/list_of_posts.dart';
import 'package:auti_warrior_app/widgets/Profile Widgets/CustomDrawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final StorageService _storageService = StorageService();
  String? _firstName = '';
  String? _role = '';
  
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> imagePaths = [
    'assets/images/homeimage1.jpg',
    'assets/images/homeimage2.jpg',
    'assets/images/homeimage3.jpg',
    'assets/images/homeimage4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Start image slider timer
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future _loadUserData() async {
    final firstName = await _storageService.getFirstName();
    final role = await _storageService.getRole();

    setState(() {
      _firstName = firstName;
      _role = role;
    });

    print("👩‍👦 HomeView loaded with role: $_role");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade500,
        title: Text('مرحباً $_firstName!'),
      ),
      drawer: CustomDrawer(
        userName: _firstName ?? 'مستخدم',
        imageUrl: 'https://example.com/user_photo.png',
      ),
      body: SafeArea(
        child: Column(
          children: [
SizedBox(height: 5),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      imagePaths[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            ListOfPosts(),
          ],
        ),
      ),
      bottomNavigationBar: HomeNavbar(),
    );
  }
}
