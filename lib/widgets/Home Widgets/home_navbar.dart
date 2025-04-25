import 'package:flutter/material.dart';

import '../../views/MotherView/doctors.dart';
import '../../views/chats/ChatsView.dart';
import '../../views/chats/chatbot.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey.shade500,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Doctors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat Bot',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.child_care),
          label: 'Kids',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 1: // "Doctors" tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvailableDoctorsPage()),
            );
            break;
          case 2: // "Doctors" tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatBot()),
            );
          case 3: // "Doctors" tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatsView()),
            );
            break;
          // Handle other tabs if needed
          default:
            break;
        }
      },
    );
  }
}
