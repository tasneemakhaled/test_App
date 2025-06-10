import 'package:flutter/material.dart';
// import '../../help/constants.dart'; // Ensure path is correct if used and KFontFamily is defined
import '../../models/doctorModels/UpdateProfileModel.dart';
import '../../services/DoctorProfileService.dart';
import '../../services/storage_service.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Doctor? doctorData; // Current doctor data

  UpdateProfileScreen({this.doctorData});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final StorageService _storageService = StorageService();
  final DoctorService _doctorService = DoctorService();

  // Form controllers
  late TextEditingController _phoneController;
  late TextEditingController _specializationController;
  late TextEditingController _licenseController;
  late TextEditingController _birthDateController;
  late TextEditingController _addressController;
  late TextEditingController _degreeController;
  late TextEditingController _yearsController;
  late TextEditingController _certificatesController; // For summary

  bool _isLoading = false;

  // Variables to store values from the form (initialized from widget.doctorData)
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  // Other fields will be handled via controllers directly on save

  @override
  void initState() {
    super.initState();
    _initializeControllersAndData();
  }

  void _initializeControllersAndData() {
    // Initialize controllers
    _phoneController = TextEditingController();
    _specializationController = TextEditingController();
    _licenseController = TextEditingController();
    _birthDateController = TextEditingController();
    _addressController = TextEditingController();
    _degreeController = TextEditingController();
    _yearsController = TextEditingController();
    _certificatesController = TextEditingController();

    if (widget.doctorData != null) {
      final data = widget.doctorData!;
      // Populate non-editable basic data directly
      _firstName = data.firstName ?? '';
      _lastName = data.lastName ?? '';
      _email = data.email ?? '';

      // Populate controllers
      _phoneController.text = data.phoneNumber ?? '';
      _specializationController.text = data.specialization;
      _licenseController.text = data.doctorLicense;
      _birthDateController.text = data.dateOfBirth;
      _addressController.text = data.address;
      _degreeController.text = data.academicDegree;
      _yearsController.text = data.yearsOfExperience.toString();
      _certificatesController.text = data.certificates; // Summary
    }
  }

  Future<void> _handleBirthDateTap() async {
    FocusScope.of(context)
        .requestFocus(new FocusNode()); // To hide keyboard if open
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDateController.text.isNotEmpty
          ? (DateTime.tryParse(_birthDateController.text) ?? DateTime.now())
          : DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      // If form is not valid, do nothing
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get doctorId. If widget.doctorData exists, use its doctorId.
      // Otherwise, try to get it from storage (this depends on your app logic)
      final int doctorId = widget.doctorData?.doctorId ??
          (int.tryParse(await _storageService.getDoctorId() ?? '0') ?? 0);

      if (doctorId == 0 && widget.doctorData == null) {
        // Cannot save without doctor ID if this is an update to an existing profile
        // or if we don't have basic data to create a new profile
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Doctor ID is missing.'),
              backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
        return;
      }

      final updatedDoctor = Doctor(
        doctorId: doctorId, // Use existing ID
        firstName: _firstName, // From initState
        lastName: _lastName, // From initState
        email: _email, // From initState
        phoneNumber: _phoneController.text,
        specialization: _specializationController.text,
        doctorLicense: _licenseController.text,
        dateOfBirth: _birthDateController.text,
        address: _addressController.text,
        academicDegree: _degreeController.text,
        yearsOfExperience: int.tryParse(_yearsController.text) ?? 0,
        certificates: _certificatesController.text, // Summary
      );

      // Call API to update profile
      // Assume DoctorService.completeProfile is the same as DoctorService.updateProfile
      final response = await _doctorService.completeProfile(updatedDoctor);

      final success = response.statusCode == 200 || response.statusCode == 201;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context, updatedDoctor); // Return updated data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to update profile. Status: ${response.statusCode} - ${response.body}'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("❌ PROFILE UPDATE ERROR (UpdateProfileScreen): $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred while updating the profile: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  InputDecoration _buildInputDecoration(String label,
      {IconData? icon, bool isDense = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.blueGrey.shade400, size: 20)
          : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blueGrey.shade500, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: isDense
          ? EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0)
          : EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      labelStyle: TextStyle(color: Colors.blueGrey.shade600),
      // floatingLabelBehavior: FloatingLabelBehavior.always, // If you want the label always on top
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile', // English
          style: TextStyle(
              color: Colors.blueGrey.shade700,
              // fontFamily: KFontFamily, // If KFontFamily is defined and you want to use it
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.blueGrey.shade700),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // To hide keyboard when tapping anywhere
        },
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator(color: Colors.blueGrey.shade500))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center(
                      //   child: Icon(Icons.edit_note,
                      //       size: 60, color: Colors.blueGrey.shade400),
                      // ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Update Your Professional Information', // English
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildSectionTitle('Contact Information'), // English
                      TextFormField(
                        controller: _phoneController,
                        decoration:
                            _buildInputDecoration('Phone Number', // English
                                icon: Icons.phone,
                                isDense: true),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number'; // English
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildSectionTitle('Professional Information'), // English
                      TextFormField(
                        controller: _specializationController,
                        decoration:
                            _buildInputDecoration('Specialization', // English
                                icon: Icons.medical_services,
                                isDense: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your specialization'; // English
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _licenseController,
                        decoration:
                            _buildInputDecoration('License Number', // English
                                icon: Icons.badge,
                                isDense: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your license number'; // English
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _degreeController,
                        decoration:
                            _buildInputDecoration('Academic Degree', // English
                                icon: Icons.school,
                                isDense: true),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _yearsController,
                        decoration: _buildInputDecoration(
                            'Years of Experience', // English
                            icon: Icons.work_history,
                            isDense: true),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      _buildSectionTitle('Personal Information'), // English
                      TextFormField(
                        controller: _birthDateController,
                        decoration:
                            _buildInputDecoration('Date of Birth', // English
                                    icon: Icons.calendar_today,
                                    isDense: true)
                                .copyWith(
                                    suffixIcon: Icon(Icons.calendar_today,
                                        color: Colors.blueGrey.shade400)),
                        readOnly: true,
                        onTap: _handleBirthDateTap,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        decoration: _buildInputDecoration('Address', // English
                            icon: Icons.location_city,
                            isDense: true),
                        maxLines: 2,
                      ),
                      SizedBox(height: 16),
                      _buildSectionTitle('Additional Information'), // English
                      TextFormField(
                        controller: _certificatesController, // For summary
                        decoration: _buildInputDecoration(
                            'Certificates (Summary)', // English
                            icon: Icons.article,
                            isDense: true),
                        maxLines: 3,
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text('Save Changes', // English
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade500,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 3,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          icon: Icon(Icons.cancel_outlined,
                              color: Colors.blueGrey.shade600),
                          label: Text('Cancel', // English
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey.shade600)),
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey.shade300)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _specializationController.dispose();
    _licenseController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _degreeController.dispose();
    _yearsController.dispose();
    _certificatesController.dispose();
    super.dispose();
  }
}
