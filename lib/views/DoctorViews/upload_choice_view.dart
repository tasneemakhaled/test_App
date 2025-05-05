import 'package:flutter/material.dart';
import '../../help/constants.dart';
import 'upload_certificate_view.dart';
import 'upload_post_view.dart';

class UploadChoiceView extends StatelessWidget {
  const UploadChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UploadCertificateView()),
                );

                if (result != null) {
                  Navigator.pop(
                      context, {'type': 'certificate', 'data': result});
                }
              },
              icon: const Icon(Icons.school),
              label: Text(
                'Add Certificate',
                style: TextStyle(
                  fontFamily: KFontFamily,
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade500,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadPostView()),
                );

                if (result != null) {
                  Navigator.pop(context, {'type': 'post', 'data': result});
                }
              },
              icon: const Icon(Icons.post_add),
              label: Text(
                'Uplaod Post ',
                style: TextStyle(
                  fontFamily: KFontFamily,
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade500,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
