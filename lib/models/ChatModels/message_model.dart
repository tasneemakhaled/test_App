class MessageModel {
  final String senderEmail;
  final String receiverEmail;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.senderEmail,
    required this.receiverEmail,
    required this.content,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderEmail: json['senderEmail'],
      receiverEmail: json['receiverEmail'],
      content: json['content'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
