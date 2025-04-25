import 'package:flutter/material.dart';

import '../../help/constants.dart';
import '../../widgets/paywidgets/payment_option_button.dart';

class PaymentMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Method',
          style: TextStyle(
            color: Colors.blueGrey.shade500,
            fontFamily: KFontFamily, // Custom font family
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit & Debit Card',
              style: TextStyle(
                fontSize: 25,
                color: Colors.blueGrey.shade500,
                fontFamily: KFontFamily,
              ),
            ),
            SizedBox(height: 10),
            PaymentOptionButton(
              label: 'Add New Card',
              icon: Icons.credit_card,
              onTap: () {
                // Add your navigation or logic here
              },
            ),
            SizedBox(height: 50),
            Text(
              'More Payment Option',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey.shade500,
                fontFamily: KFontFamily,
              ),
            ),
            SizedBox(height: 10),
            PaymentOptionButton(
              label: 'Apple Play',
              icon: Icons.apple,
              onTap: () {},
            ),
            PaymentOptionButton(
              label: 'Paypal',
              icon: Icons.paypal,
              onTap: () {},
            ),
            PaymentOptionButton(
              label: 'Google Play',
              icon: Icons.play_circle,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentMethod(),
  ));
}
