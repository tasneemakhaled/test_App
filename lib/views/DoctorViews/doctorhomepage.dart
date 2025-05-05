import 'package:auti_warrior_app/views/DoctorViews/upload_certificate_view.dart';
import 'package:auti_warrior_app/views/DoctorViews/upload_post_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:auti_warrior_app/services/storage_service.dart';
import '../../help/constants.dart';
import '../../widgets/Profile Widgets/CustomDrawer.dart';
import '../../widgets/Profile Widgets/UserPhotoAndName.dart';
import 'upload_choice_view.dart';

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({Key? key}) : super(key: key);

  @override
  _DoctorHomeViewState createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {
  final StorageService _storageService = StorageService();
  String _firstName = 'Abdullah'; // قيمة افتراضية
  String _lastName = 'Hatem'; // قيمة افتراضية
  String _role = 'doctor'; // قيمة افتراضية
  String _profileImageUrl =
      'https://xsgames.co/randomusers/assets/avatars/male/64.jpg'; // صورة افتراضية للطبيب
  File? _profileImageFile;
  bool _isLoading = false;

  // قوائم مؤقتة لتخزين البيانات حتى يتم إنشاء API
  List<Map<String, dynamic>> certificates = [
    {
      'id': '1',
      'title': 'شهادة تخصص في اضطراب طيف التوحد',
      'imageUrl':
          'https://img.freepik.com/free-vector/flat-certificate-template_52683-61537.jpg?t=st=1746367091~exp=1746370691~hmac=9cc2a41465a28becd13caa4bd4cda8b9cad11dc3499470f87988687d8e1a1ff2&w=1380',
      'isLocal': false
    },
    {
      'id': '2',
      'title': 'دكتوراه في طب الأطفال',
      'imageUrl':
          'https://img.freepik.com/free-psd/graduation-template-design_23-2151965033.jpg?t=st=1746367043~exp=1746370643~hmac=5ede014c270a7edfccf8589b1778708c4bb55422ad789c7b62eddfc090fb0781&w=1380',
      'isLocal': false
    },
    {
      'id': '3',
      'title': 'شهادة اعتماد دولي',
      'imageUrl':
          'https://img.freepik.com/premium-photo/education-concept-globe-certificate_441362-1904.jpg?w=1380',
      'isLocal': false
    },
  ];

  List<Map<String, dynamic>> posts = [
    {
      'id': '1',
      'text':
          'نصيحة اليوم: التواصل مع الأطفال المصابين بالتوحد يحتاج إلى صبر وتفهم. استخدام الصور والرموز المرئية يساعد كثيراً في تحسين التواصل معهم.',
      'imageUrl':
          'https://img.freepik.com/free-photo/childrens-showing-different-signs_23-2148445710.jpg?t=st=1746367233~exp=1746370833~hmac=aa97733fb8cfa68211f5838c17d1c8e0506432c3224dcbea6e18efd5116b6631&w=740',
      'isLocal': false
    },
    {
      'id': '2',
      'text':
          'جلسات العلاج الجماعي تبدأ من الأسبوع المقبل في مركزنا. الرجاء التواصل مع السكرتارية للحجز والاستفسار.',
      'imageUrl':
          'https://img.freepik.com/free-photo/female-psychologist-consulting-young-couple_23-2148761461.jpg',
      'isLocal': false
    },
    {
      'id': '3',
      'text':
          'تذكير: الورشة التدريبية لأولياء الأمور ستقام يوم السبت القادم في تمام الساعة العاشرة صباحاً.',
      'imageUrl': null,
      'isLocal': false
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // محاولة تحميل البيانات من StorageService
      final firstName = await _storageService.getFirstName();
      final lastName = await _storageService.getLastName();
      final role = await _storageService.getRole();

      setState(() {
        // التحقق من وجود البيانات قبل تعيينها
        if (firstName != null && firstName.isNotEmpty) {
          _firstName = firstName;
        }
        if (lastName != null && lastName.isNotEmpty) {
          _lastName = lastName;
        }
        if (role != null && role.isNotEmpty) {
          _role = role;
        }
        _isLoading = false;
      });

      print("👨‍⚕️ DoctorHomeView loaded with role: $_role");
    } catch (e) {
      // في حالة حدوث خطأ، استخدم القيم الافتراضية
      print("❌ حدث خطأ أثناء تحميل بيانات المستخدم: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("❌ حدث خطأ أثناء اختيار الصورة: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء اختيار الصورة')),
      );
    }
  }

  Future<void> _addNewCertificate() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UploadCertificateView()),
      );

      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          certificates.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'title': result['title'] ?? 'شهادة جديدة',
            'imageUrl': result['imageUrl'],
            'isLocal': result['imageUrl'] != null,
          });
        });
      }
    } catch (e) {
      print("❌ حدث خطأ أثناء إضافة شهادة جديدة: $e");
    }
  }

  void _deleteCertificate(String id) {
    setState(() {
      certificates.removeWhere((cert) => cert['id'] == id);
    });
  }

  Future<void> _addNewPost() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UploadPostView()),
      );

      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          posts.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': result['text'] ?? 'منشور جديد',
            'imageUrl': result['imageUrl'],
            'isLocal': result['imageUrl'] != null,
          });
        });
      }
    } catch (e) {
      print("❌ حدث خطأ أثناء إضافة منشور جديد: $e");
    }
  }

  void _deletePost(String id) {
    setState(() {
      posts.removeWhere((post) => post['id'] == id);
    });
  }

  Widget _buildImageWidget(String? imageUrl, bool isLocal) {
    if (imageUrl == null) {
      // إذا كانت الصورة غير موجودة، اعرض صورة افتراضية أو مساحة فارغة
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Icon(
            Icons.image,
            size: 50,
            color: Colors.grey[400],
          ),
        ),
      );
    }

    try {
      // محاولة عرض الصورة بناءً على نوعها
      if (isLocal) {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("❌ خطأ في عرض الصورة المحلية: $error");
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, color: Colors.red),
            );
          },
        );
      } else {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("❌ خطأ في عرض صورة الشبكة: $error");
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, color: Colors.red),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
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
      print("❌ استثناء عند محاولة عرض الصورة: $e");
      return Container(
        color: Colors.grey[200],
        child: Icon(Icons.error, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullName = '$_firstName $_lastName';
    final isDoctor = _role == "doctor";

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Center(
          child: Text(
            'Profile Page',
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontFamily: KFontFamily,
              fontSize: 32,
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(
        userName: fullName,
        imageUrl: _profileImageFile == null ? _profileImageUrl : null,
        imageFile: _profileImageFile,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // يمكن استخدام هذه الدالة لتحديث البيانات من API في المستقبل
                return Future.delayed(Duration(milliseconds: 300));
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          UserPhotoAndName(
                            name: fullName,
                            role: 'DOCTOR',
                            imageUrl: _profileImageUrl,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickProfileImage,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade500,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('معلومات الطبيب',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('• الدرجة العلمية: دكتوراه',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          Text('• التخصص: طب الأطفال والتوحد',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          Text('• سنوات الخبرة: 10',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          Text('• الشهادات: متخصص في التوحد',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _addNewCertificate,
                          icon: Icon(Icons.add_circle),
                          color: Colors.blueGrey.shade500,
                          tooltip: 'إضافة شهادة',
                        ),
                        Text('Certificates 🏅 ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: certificates.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final cert = certificates[index];
                        final bool isLocalImage = cert['isLocal'] == true;

                        return Stack(
                          children: [
                            Card(
                              elevation: 2,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: cert['imageUrl'] == null
                                        ? Container(
                                            color: Colors.grey[200],
                                            child: Icon(Icons.image,
                                                color: Colors.grey[400]),
                                          )
                                        : _buildImageWidget(
                                            cert['imageUrl'], isLocalImage),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      cert['title'] ?? 'شهادة',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteCertificate(cert['id']),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _addNewPost,
                          icon: Icon(Icons.add_circle),
                          color: Colors.blueGrey.shade500,
                          tooltip: 'إضافة منشور',
                        ),
                        Text('Posts 📄 ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    posts.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد منشورات حالياً',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              final bool isLocalImage = post['isLocal'] == true;

                              return Stack(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (post['imageUrl'] != null)
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(8)),
                                            child: _buildImageWidget(
                                                post['imageUrl'], isLocalImage),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            post['text'] ?? '',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deletePost(post['id']),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
      floatingActionButton: isDoctor
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UploadChoiceView()),
                );
              },
              child: const Icon(Icons.upload),
              backgroundColor: Colors.blueGrey,
            )
          : null,
    );
  }
}
