import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../Provider/ChatViewModel.dart';

class ChatPage extends StatefulWidget {
  final String otherUid, name;

  const ChatPage({super.key, required this.otherUid, required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String? uId = FirebaseAuth.instance.currentUser?.uid;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatViewModel>().getChatList(cid: uId ?? "", otherId: widget.otherUid);
    });
  }

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        context.read<ChatViewModel>().sendImage(otherUid: widget.otherUid, imagePath: image.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: viewModel.chatList.isEmpty
                ? const Center(child: Text("No messages yet", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              reverse: true,
              itemCount: viewModel.chatList.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final chat = viewModel.chatList[index];
                final isSender = chat.senderId == uId;
                final formattedTime = chat.dateTime != null
                    ? DateFormat('hh:mm a').format(chat.dateTime!)
                    : 'No time';

                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (chat.isImage && chat.imageUrl != null)
                        Image.asset(chat.imageUrl!, height: 100, width: 100, fit: BoxFit.cover)
                      else
                        Container(
                          padding: const EdgeInsets.all(14),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isSender ? Colors.orange.shade400 : Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isSender ? 16 : 4),
                              bottomRight: Radius.circular(isSender ? 4 : 16),
                            ),
                          ),
                          child: Text(
                            chat.message,
                            style: TextStyle(color: isSender ? Colors.white : Colors.black87),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(formattedTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.photo), onPressed: _pickImage),
                Expanded(
                  child: TextField(
                    controller: viewModel.chatController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: viewModel.chatHint,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.grey),
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
    );
  }
}
