import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/widgets/Home%20Widgets/home_navbar.dart';
import 'package:auti_warrior_app/widgets/Profile%20Widgets/CustomDrawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final StorageService _storageService = StorageService();
  String? _firstName = '';
  String? _lastName = '';
  String? _role = '';

  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<Map<String, dynamic>> carouselItems = [
    {
      'image': 'assets/images/homeimage1.jpg',
      'title': 'Autism Support',
      'subtitle': 'Building a community of warriors'
    },
    {
      'image': 'assets/images/homeimage2.jpg',
      'title': 'Early Intervention',
      'subtitle': 'Start the journey together'
    },
    {
      'image': 'assets/images/homeimage3.jpg',
      'title': 'Therapy Success',
      'subtitle': 'Celebrating every milestone'
    },
    {
      'image': 'assets/images/homeimage4.jpg',
      'title': 'Family Support',
      'subtitle': 'You are not alone'
    },
  ];

  final List<Map<String, dynamic>> guidanceTips = [
    {
      'icon': Icons.lightbulb_outline,
      'title': 'Today\'s Tip',
      'content':
          'Use visual schedules to help your child understand daily routines.',
      'color': Color(0xFFADD8E6) // Light blue
    },
    {
      'icon': Icons.self_improvement,
      'title': 'Sensory Activity',
      'content':
          'Try finger painting with different textures to develop sensory integration.',
      'color': Color(0xFFD8D8D8) // Light grey
    },
    {
      'icon': Icons.menu_book,
      'title': 'Learn Today',
      'content':
          'Nonverbal communication: Understanding and responding to body language cues.',
      'color': Color(0xFFF5F5DC) // Beige
    },
  ];

  final List<String> autismFacts = [
    'Autism affects 1 in 36 children globally according to recent studies.',
    'Early intervention can significantly improve outcomes for children with autism.',
    'Many people with autism have exceptional abilities in visual skills, music, math, and art.',
    'Autism is a spectrum condition that affects people in different ways and to varying degrees.',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Start image slider timer
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < carouselItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
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
    final lastName = await _storageService.getLastName();
    final role = await _storageService.getRole();

    setState(() {
      _firstName = firstName;
      _lastName = lastName;
      _role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade600,
        elevation: 0,
        title: Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: Colors.blueGrey.shade500,
            //   radius: 18,
            //   child: Text(
            //     _firstName?.isNotEmpty == true ? _firstName![0] : 'A',
            //     style:
            //         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            //   ),
            // ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome${_firstName?.isNotEmpty == true ? ', $_firstName' : ''}!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Text(
                //   'Auti Warrior',
                //   style: TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.w300,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(
        userName: '$_firstName $_lastName' ?? 'User',
        imageUrl: 'https://example.com/user_photo.png',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          // Refresh content here if needed
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: carouselItems.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: double.infinity,
                            child: Image.asset(
                              carouselItems[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black54],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 28,
                          right: 28,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                carouselItems[index]['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                carouselItems[index]['subtitle'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Indicator dots
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    carouselItems.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.blueGrey.shade600
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ),

              // Today's Guidance Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Guidance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: guidanceTips.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: guidanceTips[index]['color'],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        guidanceTips[index]['icon'],
                                        color: Colors.blueGrey.shade700,
                                        size: 28,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        guidanceTips[index]['title'],
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade700,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Expanded(
                                    child: Text(
                                      guidanceTips[index]['content'],
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Autism Facts
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Autism Awareness',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blueGrey.shade700,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Did You Know?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueGrey.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ...autismFacts
                              .map((fact) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(fact),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeNavbar(),
    );
  }
}
