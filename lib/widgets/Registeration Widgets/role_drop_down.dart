import 'package:auti_warrior_app/help/constants.dart';
import 'package:flutter/material.dart';

class RoleDropDown extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String?> onChanged;

  const RoleDropDown({Key? key, this.selectedRole, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedRole,
      hint: const Text('Select Role'),
      items: const [
        DropdownMenuItem(value: 'MOTHER', child: Text('Mother')),
        DropdownMenuItem(value: 'DOCTOR', child: Text('Doctor')),
      ],
      onChanged: onChanged,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: KColor, width: 1),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: KColor),
      style: const TextStyle(fontSize: 16, color: KColor),
      dropdownColor: Colors.white,
    );
  }
}
