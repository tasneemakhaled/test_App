// views/mothers_view.dart
import 'package:auti_warrior_app/models/MotherModels/mother_model.dart';
import 'package:auti_warrior_app/services/mother_service.dart';
import 'package:auti_warrior_app/views/DoctorViews/mother_card.dart';
import 'package:flutter/material.dart';

class MothersView extends StatefulWidget {
  const MothersView({Key? key}) : super(key: key);

  @override
  _MothersViewState createState() => _MothersViewState();
}

class _MothersViewState extends State<MothersView> {
  final MotherService _apiService = MotherService();
  List<Mother> mothers = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchMothers();
  }

  Future<void> fetchMothers() async {
    try {
      final fetchedMothers = await _apiService.getAllMothers();
      setState(() {
        mothers = fetchedMothers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mothers List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(
                  child: Text(error, style: const TextStyle(color: Colors.red)))
              : mothers.isEmpty
                  ? const Center(child: Text('No mothers found in the list'))
                  : ListView.builder(
                      itemCount: mothers.length,
                      itemBuilder: (context, index) {
                        return MotherCard(mother: mothers[index]);
                      },
                    ),
    );
  }
}
