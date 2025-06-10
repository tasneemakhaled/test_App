import 'package:auti_warrior_app/views/chats/ChatsView.dart'; // سيبقى هذا الاستيراد إذا كنتِ ستستخدمينه في مكان آخر
import 'package:flutter/material.dart';
import '../../models/doctorModels/AllDoctorsModel.dart';
import 'dart:io'; // لاستخدام File في buildImageWidget إذا كانت الصور محلية

// يمكنك نقل هذه إلى ملف ui_helpers.dart إذا أردتِ
Widget buildImageWidget(String? imageUrl, bool isLocal) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.grey[400],
        ),
      ),
    );
  }
  try {
    if (isLocal) {
      final file = File(imageUrl);
      if (!file.existsSync()) {
        print("❌ Local image file not found: $imageUrl");
        return _buildErrorImagePlaceholder();
      }
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("❌ Error displaying local image: $error");
          return _buildErrorImagePlaceholder(icon: Icons.broken_image);
        },
      );
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("❌ Error displaying network image ($imageUrl): $error");
          return _buildErrorImagePlaceholder(icon: Icons.cloud_off);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
  } catch (e) {
    print("❌ Exception when trying to display image ($imageUrl): $e");
    return _buildErrorImagePlaceholder();
  }
}

Widget _buildErrorImagePlaceholder({IconData icon = Icons.error_outline}) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Icon(
        icon,
        size: 50,
        color: Colors.red[300],
      ),
    ),
  );
}
// نهاية دالة buildImageWidget

class DoctorDetailsPage extends StatelessWidget {
  final AllDoctorsModel doctor;

  const DoctorDetailsPage({Key? key, required this.doctor}) : super(key: key);

  // بيانات افتراضية للشهادات
  static final List<Map<String, dynamic>> defaultCertificates = [
    {
      'id': 'cert1',
      'title': 'Advanced Autism Intervention Techniques',
      'imageUrl':
          'https://img.freepik.com/free_vector/flat-professional-certificate-template_23-2149455355.jpg?w=1380&t=st=1700000001~exp=1700000601~hmac=abcdef123456', // استخدمي URL حقيقي
      'isLocal': false
    },
    {
      'id': 'cert2',
      'title': 'Behavioral Therapy for Children',
      'imageUrl':
          'https://img.freepik.com/premium_psd/professional-certificate-template_561081-125.jpg?w=1380', // استخدمي URL حقيقي
      'isLocal': false
    },
  ];

  // بيانات افتراضية للمنشورات
  static final List<Map<String, dynamic>> defaultPosts = [
    {
      'id': 'post1',
      'text':
          'Understanding sensory processing in children with autism is crucial for effective support. Simple adjustments at home and school can make a big difference.',
      'imageUrl':
          'https://img.freepik.com/free_photo/children-playing-therapist-s-office_23-2149343396.jpg?w=1380&t=st=1700000002~exp=1700000602~hmac=abcdef123457', // استخدمي URL حقيقي
      'isLocal': false
    },
    {
      'id': 'post2',
      'text':
          'Join our upcoming webinar on "Fostering Communication Skills in Non-Verbal Children with Autism." Register by next Friday!',
      'imageUrl': null, // منشور بدون صورة
      'isLocal': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    // استخدام صورة البروفايل من الموديل إذا كانت موجودة، وإلا صورة افتراضية
    final String profilePicUrl =
        "https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg";

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade700,
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 20), // تعديل الحشو
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor avatar and name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 65, // تكبير الصورة قليلاً
                    backgroundColor: Colors.blueGrey.shade100,
                    backgroundImage: NetworkImage(profilePicUrl),
                    onBackgroundImageError: (exception, stackTrace) {
                      // يمكنك عرض أيقونة بديلة هنا إذا فشل تحميل الصورة
                      print("Error loading profile image: $exception");
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${doctor.firstName} ${doctor.lastName}",
                    style: TextStyle(
                      fontSize: 26, // تكبير الخط
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    doctor.specialization ?? 'Psychologist',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.teal.shade600, // لون مختلف للتخصص
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Doctor Information Card
            _buildSectionContainer(
              title: 'Doctor Information',
              icon: Icons.person_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Email:', doctor.email ?? 'Not provided'),
                  _infoRow('Phone:', doctor.phoneNumber ?? 'Not provided'),
                  _infoRow('Specialization:',
                      doctor.specialization ?? 'Not provided'),
                  _infoRow('Academic Degree:',
                      doctor.academicDegree ?? 'Not provided'),
                  _infoRow(
                      'Years of Experience:',
                      doctor.yearsOfExperience != null
                          ? '${doctor.yearsOfExperience} years'
                          : 'Not provided'),
                  _infoRow('License:', doctor.doctorLicense ?? 'Not provided'),
                  _infoRow('Address:', doctor.address ?? 'Not provided',
                      isMultiline: true),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Certificates Section
            _buildSectionTitle('Certificates 🏅'),
            SizedBox(height: 10),
            defaultCertificates.isEmpty
                ? _buildEmptyState("No certificates to display.")
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: defaultCertificates.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85, // تعديل النسبة
                    ),
                    itemBuilder: (context, index) {
                      final cert = defaultCertificates[index];
                      return _buildCertificateCard(cert);
                    },
                  ),

            SizedBox(height: 30),

            // Posts Section
            _buildSectionTitle('Recent Posts 📄'),
            SizedBox(height: 10),
            defaultPosts.isEmpty
                ? _buildEmptyState("No posts to display.")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: defaultPosts.length,
                    itemBuilder: (context, index) {
                      final post = defaultPosts[index];
                      return _buildPostCard(post);
                    },
                  ),
            SizedBox(height: 20),
            // تم إزالة أزرار Chat و Subscribe
          ],
        ),
      ),
    );
  }

  // واجهة لعرض عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.shade700,
      ),
    );
  }

  // واجهة لحاوية القسم (مثل معلومات الطبيب)
  Widget _buildSectionContainer(
      {required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, // تغيير لون الخلفية
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border:
              Border.all(color: Colors.blueGrey.shade100) // إضافة حدود خفيفة
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueGrey.shade600, size: 22),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                    color: Colors.blueGrey.shade800,
                    fontSize: 18, // تصغير الخط قليلاً
                    fontWeight: FontWeight.w600), // تعديل الوزن
              ),
            ],
          ),
          Divider(color: Colors.blueGrey.shade200, thickness: 1, height: 20),
          // SizedBox(height: 6), // تم استبدالها بـ Divider
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6.0), // زيادة المسافة العمودية
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2, // تعديل النسبة
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blueGrey.shade700, // لون أغمق للـ label
                fontSize: 15, // تصغير الخط قليلاً
                fontWeight: FontWeight.w500, // تعديل الوزن
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 4, // تعديل النسبة
            child: Text(
              value.isEmpty ? "Not available" : value,
              style: TextStyle(
                color: Colors.black87, // لون أغمق للقيمة
                fontSize: 15,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // واجهة لعرض بطاقة الشهادة
  Widget _buildCertificateCard(Map<String, dynamic> cert) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: buildImageWidget(cert['imageUrl'], cert['isLocal'] ?? false),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cert['title'] ?? 'Certificate',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // واجهة لعرض بطاقة المنشور
  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post['imageUrl'] != null)
            SizedBox(
              height: 180, // تعديل ارتفاع الصورة
              width: double.infinity,
              child:
                  buildImageWidget(post['imageUrl'], post['isLocal'] ?? false),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              post['text'] ?? '',
              style: TextStyle(
                  fontSize: 15, height: 1.4), // تعديل حجم الخط وارتفاع السطر
            ),
          ),
        ],
      ),
    );
  }
}
