import 'package:flutter/material.dart';

class DoctorProfileUpdateFormWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController specializationController;
  final TextEditingController licenseController;
  final TextEditingController birthDateController;
  final TextEditingController addressController;
  final TextEditingController degreeController;
  final TextEditingController yearsController;
  final TextEditingController certificatesController;
  final VoidCallback onSaveProfile;
  final VoidCallback onCancel;
  final VoidCallback onBirthDateTap;

  const DoctorProfileUpdateFormWidget({
    Key? key,
    required this.phoneController,
    required this.specializationController,
    required this.licenseController,
    required this.birthDateController,
    required this.addressController,
    required this.degreeController,
    required this.yearsController,
    required this.certificatesController,
    required this.onSaveProfile,
    required this.onCancel,
    required this.onBirthDateTap,
  }) : super(key: key);

  InputDecoration _buildInputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon:
          icon != null ? Icon(icon, color: Colors.blueGrey.shade400) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blueGrey.shade500, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // <--- الخطوة 1: تغليف بـ GestureDetector
      onTap: () {
        // <--- الخطوة 2: إخفاء لوحة المفاتيح عند النقر
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
              child: Text(
                'Update Your Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            ),
            TextFormField(
              controller: phoneController,
              decoration:
                  _buildInputDecoration('Phone Number', icon: Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: specializationController,
              decoration: _buildInputDecoration('Specialization',
                  icon: Icons.medical_services),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: licenseController,
              decoration:
                  _buildInputDecoration('License Number', icon: Icons.badge),
            ),
            SizedBox(height: 12),
            // ... باقي الحقول النصية كما هي
            TextFormField(
              controller: birthDateController,
              decoration: _buildInputDecoration('Date of Birth',
                      icon: Icons.calendar_today)
                  .copyWith(
                      suffixIcon: Icon(Icons.calendar_today,
                          color: Colors.blueGrey.shade400)),
              readOnly: true,
              onTap: onBirthDateTap,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: addressController,
              decoration:
                  _buildInputDecoration('Address', icon: Icons.location_city),
              maxLines: 2,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: degreeController,
              decoration:
                  _buildInputDecoration('Academic Degree', icon: Icons.school),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: yearsController,
              decoration: _buildInputDecoration('Years of Experience',
                  icon: Icons.work_history),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: certificatesController,
              decoration: _buildInputDecoration('Certificates (Summary)',
                  icon: Icons.article),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.cancel_outlined,
                        color: Colors.blueGrey.shade600),
                    label: Text('Cancel',
                        style: TextStyle(
                            fontSize: 16, color: Colors.blueGrey.shade600)),
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.blueGrey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text('Save',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: onSaveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade500,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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
