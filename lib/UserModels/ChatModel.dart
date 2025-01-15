class ChatModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String status;
  final DateTime? dateTime;

  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.status,
    this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "status": status,
      "dateTime": dateTime?.toIso8601String(),
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
    );
  }
}
