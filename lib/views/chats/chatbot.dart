import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final String telegramUrl = 'https://t.me/AutismSupporterBot';
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

  void _launchTelegram() async {
    final Uri url = Uri.parse(telegramUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح الرابط: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                  /// ✅ سلايدر الصور التلقائي
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
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// العنوان
                  const Text(
                    '🤖 نظام الدعم الذكي',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  /// النص
                  const Text(
                    'مرحبًا بك في نظام الدعم الذكي للأطفال المصابين بالتوحد. 💙\n\n'
                    'يمكنك الآن التحدث مع المساعد الذكي لطرح الأسئلة أو طلب المساعدة في أي وقت.\n'
                    'نحن هنا لدعمك وتقديم المساعدة لك ولطفلك بأفضل الطرق الممكنة.',
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.6,
                      color: Color(0xFF1A237E),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  /// الزر
                  ElevatedButton.icon(
                    onPressed: _launchTelegram,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text(
                      'التحدث مع البوت على تيليجرام',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
