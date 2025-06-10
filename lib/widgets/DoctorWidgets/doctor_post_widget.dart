import 'package:flutter/material.dart';
// import '../../../utils/ui_helpers.dart'; // إذا نقلت buildImageWidget إلى هناك

// تعريف TypeDef للوظيفة إذا لم تكن موجودة في ui_helpers.dart
typedef ImageBuilder = Widget Function(String? imageUrl, bool isLocal);

class DoctorPostsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> postsList;
  final VoidCallback onAddNewPost;
  final Function(String) onDeletePost;
  final ImageBuilder buildImageWidget; // استخدام الـ typedef

  const DoctorPostsWidget({
    Key? key,
    required this.postsList,
    required this.onAddNewPost,
    required this.onDeletePost,
    required this.buildImageWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Posts 📄',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700)),
            IconButton(
              onPressed: onAddNewPost,
              icon: Icon(Icons.add_circle_outline, size: 28),
              color: Colors.blueGrey.shade500,
              tooltip: 'Add Post',
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (postsList.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("No posts available.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: postsList.length,
            itemBuilder: (context, index) {
              final post = postsList[index];
              final bool isLocalImage = post['isLocal'] == true;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post['imageUrl'] != null)
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: buildImageWidget(
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
                    Positioned(
                      top: 4, // ضبط ليتناسب بشكل أفضل
                      right: 4,
                      child: Material(
                        // للـ splash effect
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(Icons.delete_outline,
                              color: Colors.red.shade400, size: 24),
                          onPressed: () => onDeletePost(post['id']),
                          tooltip: "Delete Post",
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
