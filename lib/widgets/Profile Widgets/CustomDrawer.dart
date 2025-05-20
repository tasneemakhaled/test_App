import 'package:flutter/material.dart';
import 'dart:io';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/services/AuthService.dart';
import 'package:auti_warrior_app/views/RegisterationViews/login_view.dart';
import 'package:auti_warrior_app/views/PrivacyPolicy.dart';
import 'package:auti_warrior_app/views/chats/ChatsView.dart';
import '../../help/constants.dart';

class CustomDrawer extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final String userName;

  const CustomDrawer({
    Key? key,
    this.imageUrl,
    this.imageFile,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile!)
                      : (imageUrl != null && imageUrl!.isNotEmpty)
                          ? NetworkImage(imageUrl!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: KFontFamily,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const Divider(height: 2),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ChatsView()),
              // );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading:
                const Icon(Icons.contacts, color: Colors.blueGrey, size: 28),
            title: const Text(
              "My Contacts",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: KFontFamily,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading:
                const Icon(Icons.settings, color: Colors.blueGrey, size: 28),
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: KFontFamily,
                fontSize: 18,
              ),
            ),
          ),
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
            leading:
                const Icon(Icons.privacy_tip, color: Colors.blueGrey, size: 28),
            title: const Text(
              "Privacy Policy",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: KFontFamily,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              final token = await StorageService().getToken();
              try {
                if (token != null && token.isNotEmpty) {
                  await AuthService().logout(token);
                }
              } catch (e) {
                print("خطأ في تسجيل الخروج: $e");
              } finally {
                await StorageService().clearToken();
                await StorageService().clearRole();
                await StorageService().clearAllSessionData();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading:
                const Icon(Icons.exit_to_app, color: Colors.blueGrey, size: 28),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: KFontFamily,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
