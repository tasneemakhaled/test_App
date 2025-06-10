import 'package:flutter/material.dart';

class DoctorActionsWidget extends StatelessWidget {
  final bool showUpdateForm;
  final VoidCallback onToggleUpdateForm;

  const DoctorActionsWidget({
    Key? key,
    required this.showUpdateForm,
    required this.onToggleUpdateForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ElevatedButton.icon(
          onPressed: onToggleUpdateForm,
          icon: Icon(
            showUpdateForm ? Icons.close : Icons.edit,
            color: Colors.white,
          ),
          label: Text(
            showUpdateForm ? 'Hide Form' : 'Update Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade500,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
