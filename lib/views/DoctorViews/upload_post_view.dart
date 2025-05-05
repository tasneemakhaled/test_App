import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../help/constants.dart';

class UploadPostView extends StatefulWidget {
  const UploadPostView({super.key});

  @override
  State<UploadPostView> createState() => _UploadPostViewState();
}

class _UploadPostViewState extends State<UploadPostView> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _submitPost() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text or select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: إرسال البيانات إلى السيرفر عندما يتم تجهيز API
      // حاليًا نستخدم تأخير مصطنع لمحاكاة عملية الرفع
      await Future.delayed(const Duration(milliseconds: 800));

      Navigator.pop(context, {
        'text': text,
        'imageUrl': _selectedImage?.path,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء نشر المنشور: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Post Content ',
                hintText: 'Write here what you want to share.....',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              style: TextStyle(
                fontFamily: KFontFamily,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (_selectedImage != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isLoading ? null : _removeImage,
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    tooltip: 'Remove Image',
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 100,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: KFontFamily,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
