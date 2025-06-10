import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String? email; // <-- إضافة حقل الإيميل (اختياري)
  final String imageUrl;
  final int? experienceYears;
  final VoidCallback? onTapCard;
  final VoidCallback? onChatPressed;

  const DoctorCard({
    Key? key,
    required this.name,
    required this.specialty,
    this.email, // <-- إضافة الإيميل إلى الكونستركتور
    required this.imageUrl,
    this.experienceYears,
    this.onTapCard,
    this.onChatPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTapCard,
        splashColor: Colors.blueGrey.withOpacity(0.2),
        highlightColor: Colors.blueGrey.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.person,
                          size: 40, color: Colors.grey.shade400),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      specialty,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (email != null && email!.isNotEmpty) ...[
                      // <-- التحقق من وجود الإيميل وعرضه
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.email_outlined,
                              size: 14, color: Colors.blueGrey.shade400),
                          SizedBox(width: 4),
                          Expanded(
                            // لتجنب overflow إذا كان الإيميل طويلًا
                            child: Text(
                              email!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blueGrey.shade500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (experienceYears != null && experienceYears! > 0) ...[
                      SizedBox(height: 4),
                      Text(
                        '$experienceYears years of experience',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.teal.shade600,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (onChatPressed != null)
                          ElevatedButton.icon(
                            icon: Icon(Icons.chat_bubble_outline, size: 18),
                            label: Text('Chat'),
                            onPressed: onChatPressed,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade400,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                textStyle: TextStyle(fontSize: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        if (onTapCard != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blueGrey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Colors.blueGrey.shade400),
                            ],
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
