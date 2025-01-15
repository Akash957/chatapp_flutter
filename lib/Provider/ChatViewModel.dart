import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../UserModels/ChatModel.dart';
import '../UserModels/UserModel.dart';

class ChatViewModel with ChangeNotifier {
  final TextEditingController chatController = TextEditingController();
  final String chatHint = "Enter your message...";
  var chatList = <ChatModel>[];
  var userList = <UserModel>[];
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

  // Get chat list from Firebase Realtime Database
  void getChatList({required String cid, required String otherId}) {
    var chatId = getChatId(cid: cid, otherId: otherId);

    FirebaseDatabase.instance.ref('messages/$chatId').onValue.listen((event) {
      chatList.clear();
      for (var element in event.snapshot.children) {
        var chat = ChatModel(
          senderId: element.child("senderId").value.toString(),
          receiverId: element.child("receiverId").value.toString(),
          message: element.child("message").value.toString(),
          status: element.child("status").value.toString(),

          // dateTime
          dateTime: element.child("dateTime").value != null
              ? DateTime.parse(element.child("dateTime").value.toString())
              : null,
        );
        chatList.add(chat);
      }
      notifyListeners();
    });
  }

  void sendChat({required String otherUid}) {
    var chatId = getChatId(cid: uid, otherId: otherUid);
    var timestamp = DateTime.now().toIso8601String();

    var chatMessage = {
      'senderId': uid,
      'receiverId': otherUid,
      'message': chatController.text,
      'status': 'sent',
      'dateTime': timestamp,
    };

    FirebaseDatabase.instance.ref('messages/$chatId').push().set(chatMessage);

    chatController.clear();
  }

  String generateRandomString(int len) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(
      Iterable.generate(len, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
    );
  }

  String getChatId({required String cid, required String otherId}) {
    return cid.compareTo(otherId) > 0 ? "${cid}_$otherId" : "${otherId}_$cid";
  }

  void getUserList() {
    FirebaseDatabase.instance.ref('users').onValue.listen((event) {
      userList.clear();
      for (var element in event.snapshot.children) {
        var user = UserModel(
          id: element.child("id").value.toString(),
          name: element.child("name").value.toString(),
          email: element.child("email").value.toString(),
          password: element.child("password").value.toString(),
        );
        userList.add(user);
      }
      notifyListeners();
    });
  }
}