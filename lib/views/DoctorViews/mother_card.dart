// widgets/mother_card.dart
import 'package:auti_warrior_app/models/MotherModels/mother_model.dart';
import 'package:auti_warrior_app/views/chats/ChatsView.dart';
import 'package:flutter/material.dart';

class MotherCard extends StatelessWidget {
  final Mother mother;

  const MotherCard({Key? key, required this.mother}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${mother.firstName} ${mother.lastName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mother.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to chat page with this mother
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatsView(email: mother.email),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
