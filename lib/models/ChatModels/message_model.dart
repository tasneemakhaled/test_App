class MessageModel {
  final String senderEmail;
  final String receiverEmail;
  final String content;

  MessageModel({
    required this.senderEmail,
    required this.receiverEmail,
    required this.content,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderEmail: json['senderEmail'],
      receiverEmail: json['receiverEmail'],
      content: json['content'],
    );
  }
}

//   Map<String, dynamic> toJson() {
//     return {
//       'senderEmail': senderEmail,
//       'receiverEmail': receiverEmail,
//       'content': content,
//     };
//   }
// }
