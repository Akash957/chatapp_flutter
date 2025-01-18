import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../UserModels/ChatModel.dart';

class ChatViewModel with ChangeNotifier {
  final TextEditingController chatController = TextEditingController();
  var chatList = <ChatModel>[];
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<void> getChatList({required String cid, required String otherId}) async {
    var chatId = getChatId(cid: cid, otherId: otherId);
    DatabaseReference chatRef =
    FirebaseDatabase.instance.ref('messages/$chatId');
    chatRef.orderByChild("dateTime").onValue.listen((event) {
      chatList.clear();
      var data = event.snapshot.children;
      for (var element in data) {
        var chat = ChatModel.fromJson(Map<String, dynamic>.from(
            element.value as Map<dynamic, dynamic>));
        chatList.add(chat);
      }
      notifyListeners();
    });
  }

  Future<void> sendChat({required String otherUid, String? imageUrl}) async {
    var chatId = getChatId(cid: uid, otherId: otherUid);
    var randomId = generateRandomString(40);
    DatabaseReference chatRef =
    FirebaseDatabase.instance.ref('messages/$chatId');

    var messageType = imageUrl != null ? "image" : "text";
    var messageData = ChatModel(
      message: imageUrl == null ? chatController.text.trim() : null,
      senderId: uid,
      receiverId: otherUid,
      status: "sent",
      photo_url: imageUrl,
      message_type: messageType,
      dateTime: DateTime.now(),
    );

    await chatRef.child(randomId).set(messageData.toJson());
    if (imageUrl == null) chatController.clear();
    notifyListeners();
  }

  String generateRandomString(int len) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[Random().nextInt(chars.length)])
        .join();
  }

  String getChatId({required String cid, required String otherId}) {
    return cid.compareTo(otherId) > 0 ? "${cid}_$otherId" : "${otherId}_$cid";
  }

}
