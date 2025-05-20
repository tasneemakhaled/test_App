class MessageModel {
  final String senderEmail;
  final String receiverEmail;
  final String content;
  final DateTime timestamp;
  final String? senderName; // Optional: if your API returns it
  final String? senderRole; // Optional: if your API returns it
  final String? receiverName; // Optional: if your API returns it
  final String? receiverRole; // Optional: if your API returns it

  MessageModel({
    required this.senderEmail,
    required this.receiverEmail,
    required this.content,
    DateTime? timestamp,
    this.senderName,
    this.senderRole,
    this.receiverName,
    this.receiverRole,
  }) : timestamp = timestamp ?? DateTime.now();

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderEmail: json['senderEmail'] as String,
      receiverEmail: json['receiverEmail'] as String,
      content: json['content'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      senderName: json['senderName'] as String?,
      senderRole: json['senderRole'] as String?,
      receiverName: json['receiverName'] as String?,
      receiverRole: json['receiverRole'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      // You might not need to send these back when creating a message
      // 'senderName': senderName,
      // 'senderRole': senderRole,
      // 'receiverName': receiverName,
      // 'receiverRole': receiverRole,
    };
  }
}
