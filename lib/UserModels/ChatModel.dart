class ChatModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String status;
  final DateTime? dateTime;
  final bool isImage;
  final String? imageUrl;

  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.status,
    this.dateTime,
    this.isImage = false,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "status": status,
      "dateTime": dateTime?.toIso8601String(),
      "isImage": isImage,
      "imageUrl": imageUrl,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      senderId: json["sender_id"],
      receiverId: json["receiver_id"],
      message: json["message"],
      status: json["status"],
      dateTime: json["dateTime"] != null
          ? DateTime.parse(json["dateTime"])
          : null,
      isImage: json["isImage"] ?? false,
      imageUrl: json["imageUrl"],
    );
  }
}
