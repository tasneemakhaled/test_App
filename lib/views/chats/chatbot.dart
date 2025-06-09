import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final String telegramUrl =
      'https://t.me/AutismSupporterBot'; // Bot link (remains the same)
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> imagePaths = [
    'assets/images/chatbot.jpg',
    'assets/images/chatbot2.jpg',
    'assets/images/chatbot3.jpg',
    'assets/images/chatbot4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      if (_currentPage < imagePaths.length - 1) {
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

  void _launchTelegram() async {
    final Uri url = Uri.parse(telegramUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              // English error message
              content: Text(
                  'Could not launch $telegramUrl. Please make sure Telegram is installed.')),
        );
      }
      // Fallback option (remains commented as per original logic)
      // final Uri webFallbackUrl = Uri.parse('https://web.telegram.org/k/#@AutismSupporterBot');
      // if (await canLaunchUrl(webFallbackUrl)) {
      //   await launchUrl(webFallbackUrl, mode: LaunchMode.externalNonAppSpecific);
      // } else {
      //   throw 'Could not launch $url or the fallback web link';
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Changed textDirection to ltr for English
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        // Added AppBar
        appBar: AppBar(
          // English title for AppBar
          title: const Text('Smart Support'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Action for back button, usually Navigator.pop
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
          ),
          // Optional: Style the AppBar to match the theme
          backgroundColor: const Color(0xFF1976D2), // Example color
          foregroundColor: Colors.white, // Example color
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Automatic Image Slider (remains the same)
                  Container(
                    width: double.infinity,
                    height: 300,
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
                            errorBuilder: (context, error, stackTrace) {
                              // English error text for image loading
                              return const Center(
                                  child: Text('Error loading image'));
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Title (English)
                  const Text(
                    '🤖 Smart Support System',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Welcome to the Smart Support System for children with autism. 💙'
                    'You can now talk to the smart assistant to ask questions or request help at any time.\n'
                    'We are here to support you and provide the best possible assistance for you and your child.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF1A237E),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 10),

                  /// Button (English)
                  ElevatedButton.icon(
                    onPressed: _launchTelegram,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text(
                      'Chat with the Bot on Telegram', // English label
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
