import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../Provider/ChatViewModel.dart';

class ChatPage extends StatefulWidget {
  final String otherUid;
  final String name;

  const ChatPage({super.key, required this.otherUid, required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String? uId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var viewModel = Provider.of<ChatViewModel>(context, listen: false);
      viewModel.getChatList(cid: uId ?? "", otherId: widget.otherUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.name,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Options or settings functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, value, child) {
                  if (value.chatList.isEmpty) {
                    return const Center(
                      child: Text(
                        "No messages yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: value.chatList.length,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      var chat = value.chatList[index];
                      bool isSender = chat.senderId == uId;
//Date time
                      String formattedTime = chat.dateTime != null
                          ? DateFormat('hh:mm a').format(chat.dateTime!)
                          : 'No time';

                      return Align(
                        alignment:
                            isSender ? Alignment.topLeft : Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: isSender
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? Colors.orange.shade400
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft:
                                        Radius.circular(isSender ? 16 : 4),
                                    bottomRight:
                                        Radius.circular(isSender ? 4 : 16),
                                  ),
                                ),
                                child: Text(
                                  chat.message,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSender
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewModel.chatController,
                      maxLines: null,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: viewModel.chatHint,
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.orange.shade400),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (viewModel.chatController.text.trim().isNotEmpty) {
                        viewModel.sendChat(otherUid: widget.otherUid);
                      }
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange.shade400,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
