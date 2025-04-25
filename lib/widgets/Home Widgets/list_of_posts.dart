import 'package:auti_warrior_app/widgets/Home%20Widgets/home_body.dart';
import 'package:flutter/material.dart';

class ListOfPosts extends StatelessWidget {
  ListOfPosts({super.key});
  final List<String> posts = [
    'Autism spectrum disorder (ASD)is a complex developmental condition that affects how people interact with others, communicate, learn, and behave. ',
    'The severity of ASD can vary widely from person to person, which is why it Some individuals with ASD may require significant support, while others can live relatively independent lives. ',
    'Common characteristics of ASD include: ',
    '1- Difficulties with social interaction: This can include challenges with understanding and responding to social cues, making eye contact, and forming relationships.',
    '2- Repetitive behaviors: These might include repetitive movements (such as hand-flapping or rocking), insistence on sameness, and a strong attachment to routines. ',
    '3- Communication challenges: This can include difficulties with verbal and nonverbal communication, such as using and understanding language, and expressing needs or wants. ',
    '4- Sensory sensitivities: People with ASD may be overly sensitive or under-sensitive to sensory input, such as sounds, sights, smells, tastes, or textures. ',
    'Early intervention and support can be crucial for individuals with ASD, as it can help them develop essential skills and reach their full potential. There are many different therapies and interventions available, including speech therapy, occupational therapy, and behavioral therapy ',
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return HomeBody(
                text: posts[index],
              );
            }));
  }
}
