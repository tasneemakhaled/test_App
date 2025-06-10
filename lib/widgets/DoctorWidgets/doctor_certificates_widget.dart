import 'package:flutter/material.dart';
// import '../../../utils/ui_helpers.dart'; // إذا نقلت buildImageWidget إلى هناك

// تعريف TypeDef للوظيفة إذا لم تكن موجودة في ui_helpers.dart
typedef ImageBuilder = Widget Function(String? imageUrl, bool isLocal);

class DoctorCertificatesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> certificatesList;
  final VoidCallback onAddNewCertificate;
  final Function(String) onDeleteCertificate;
  final ImageBuilder buildImageWidget; // استخدام الـ typedef

  const DoctorCertificatesWidget({
    Key? key,
    required this.certificatesList,
    required this.onAddNewCertificate,
    required this.onDeleteCertificate,
    required this.buildImageWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Certificates 🏅',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700)),
            IconButton(
              onPressed: onAddNewCertificate,
              icon: Icon(Icons.add_circle_outline, size: 28),
              color: Colors.blueGrey.shade500,
              tooltip: 'Add Certificate',
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (certificatesList.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("No certificates added yet.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: certificatesList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final cert = certificatesList[index];
              final bool isLocalImage = cert['isLocal'] == true;

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child:
                              buildImageWidget(cert['imageUrl'], isLocalImage),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cert['title'] ?? 'Certificate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        // للـ splash effect
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(Icons.delete,
                              color: Colors.red.shade400, size: 24),
                          onPressed: () => onDeleteCertificate(cert['id']),
                          tooltip: "Delete Certificate",
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
