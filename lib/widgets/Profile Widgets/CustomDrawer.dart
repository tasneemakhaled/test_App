import 'package:flutter/material.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/services/AuthService.dart';
import 'package:auti_warrior_app/views/RegisterationViews/login_view.dart';

import 'package:auti_warrior_app/views/chats/ChatsView.dart';

import '../../views/PrivacyPolicy.dart';

class CustomDrawer extends StatelessWidget {
  final String imageUrl; // URL or asset path for the user's photo
  final String userName; // User's name

  const CustomDrawer({
    Key? key,
    this.imageUrl = 'https://example.com/user_photo.png', // Default image URL
    this.userName = 'John Doe', // Default user name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          // Profile Image and Name
          GestureDetector(
            onTap: () {
              // يمكن إضافة إجراء عند الضغط على صورة الملف الشخصي إن لزم الأمر
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.camera_alt,
                          size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'KFontFamily',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const Divider(height: 2),
          // Contacts
          ListTile(
            onTap: () {
              Navigator.pop(context); // إغلاق الـ Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatsView()),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.contacts,
              color: Colors.blueGrey,
              size: 28,
            ),
            title: const Text(
              "My Contacts",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'KFontFamily',
                fontSize: 18,
              ),
            ),
          ),
          // Settings
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.settings,
              color: Colors.blueGrey,
              size: 28,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'KFontFamily',
                fontSize: 18,
              ),
            ),
          ),
          // Privacy Policy
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicy()),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.privacy_tip,
              color: Colors.blueGrey,
              size: 28,
            ),
            title: const Text(
              "Privacy Policy",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'KFontFamily',
                fontSize: 18,
              ),
            ),
          ),
          // Logout with real API call
          // Logout with better error handling
          ListTile(
            onTap: () async {
              // استرجاع التوكن من التخزين المحلي
              final token = await StorageService().getToken();

              // محاولة تسجيل الخروج عبر الـ API
              try {
                if (token != null && token.isNotEmpty) {
                  await AuthService().logout(token);
                  // بغض النظر عن نتيجة محاولة تسجيل الخروج، سنقوم بمسح البيانات
                }
              } catch (e) {
                print("خطأ في تسجيل الخروج: $e");
              } finally {
                // مسح جميع بيانات الجلسة المحلية
                await StorageService().clearToken();
                await StorageService().clearRole();
                await StorageService().clearAllSessionData();

                // إغلاق الـ Drawer وإعادة توجيه المستخدم إلى صفحة تسجيل الدخول
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.blueGrey,
              size: 28,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'KFontFamily',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
