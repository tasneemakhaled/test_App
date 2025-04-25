import 'package:flutter/material.dart';

import '../help/constants.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advises For Moms',
          style: TextStyle(
            color: Colors.blueGrey,
            fontFamily: KFontFamily, // Custom font family
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.blueGrey),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("Advises for Moms"),
            const SizedBox(height: 16),
            buildAdviceItem(
              "Autism is a spectrum, and every child is unique. Focus on your child's strengths and celebrate their individuality.",
            ),
            buildAdviceItem(
              "Children with autism often thrive on predictability. Create consistent routines for daily activities like meals, bedtime, and school. Visual schedules can be especially helpful.",
            ),
            buildAdviceItem(
              "Learn how your child communicates, whether through words, gestures, or alternative methods like PECS (Picture Exchange Communication System).",
            ),
            buildAdviceItem(
              "Use simple language and clear instructions. Provide visual aids and social stories to help them understand situations.",
            ),
            buildAdviceItem(
              "Be aware of your child's sensory sensitivities to sounds, lights, textures, and tastes.",
            ),
            buildAdviceItem(
              "Provide a quiet space with calming sensory tools like weighted blankets, fidget toys, or soft lighting.",
            ),
            const SizedBox(height: 20),
            sectionTitle("Social Skills Development"),
            const SizedBox(height: 10),
            buildAdviceItem(
              "Social Stories: Use social stories to explain social situations and expected behaviors.",
            ),
            buildAdviceItem(
              "Social Groups: Encourage participation in social groups or activities tailored to children with autism.",
            ),
            buildAdviceItem(
              "Role-Playing: Practice social interactions through role-playing games.",
            ),
            const SizedBox(height: 20),
            sectionTitle("Remember"),
            const SizedBox(height: 10),
            buildAdviceItem(
              "Every child with autism is different, and what works for one may not work for another. Be patient, flexible, and celebrate your child's unique journey.",
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: KFontFamily,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget buildAdviceItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              color: Colors.blueGrey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: KFontFamily,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
