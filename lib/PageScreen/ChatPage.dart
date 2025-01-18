import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Provider/ChatViewModel.dart';
import 'HomePage.dart';

class ChatScreen extends StatefulWidget {
  final String otherUid;
  final String otherName;

  const ChatScreen({
    super.key,
    required this.otherUid,
    required this.otherName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final uId = FirebaseAuth.instance.currentUser?.uid;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    Future.delayed(
      Duration(seconds: 2),
          () async {
        var viewModel = Provider.of<ChatViewModel>(context, listen: false);
        await viewModel.getChatList(cid: uid, otherId: widget.otherUid);
      },
    );
  }

  Future<void> pickAndSendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String imageUrl = await _uploadImageToFirebase(imageFile);
      Provider.of<ChatViewModel>(context, listen: false).sendChat(
        otherUid: widget.otherUid,
        imageUrl: imageUrl,
      );
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    String fileName =
        "chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
    try {
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Image upload failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ChatViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(uid: ""),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("images/young.png"),
            ),
            SizedBox(width: 10),
            Text(
              widget.otherName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, value, child) {
                if (value.chatList.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: value.chatList.length,
                  itemBuilder: (context, index) {
                    var user = value.chatList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Align(
                        alignment: user.senderId == uId
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: user.senderId == uId
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: user.message_type == "image"
                              ? Image.network(
                            user.photo_url ?? "",
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                              : Text(
                            user.message ?? "",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message Input Section
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: viewModel.chatController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: IconButton(
                        onPressed: pickAndSendImage,
                        icon: Icon(Icons.photo, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    viewModel.sendChat(otherUid: widget.otherUid);
                    Future.delayed(
                      Duration(milliseconds: 300),
                          () {
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(
                            scrollController.position.maxScrollExtent,
                          );
                        }
                      },
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 24,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
