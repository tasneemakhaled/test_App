import 'package:flutter/material.dart';

import '../../views/MotherView/MotherProfile.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Padding(
        padding:  EdgeInsets.only(right: 8, left: 9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Learn about autism and choose ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  fontFamily: ' ADLaM Display'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'your doctor',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: ' ADLaM Display'),
                ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MotherProfileView()),
                      );
                    },
                    icon: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 50,
                    )),
              ],
            )
          ],
        ),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 7,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade500,
      ),
    );
  }
}
