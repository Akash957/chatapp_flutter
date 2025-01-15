import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ChatViewModel.dart';
import 'ChatPage.dart';
import 'ProfileScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              var viewModel = Provider.of<ChatViewModel>(context, listen: false);
              if (viewModel.userList.isNotEmpty) {
                var currentUser = viewModel.userList[0];
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      name: currentUser.name,
                      email: currentUser.email,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No user data available")),
                );
              }
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.userList.isEmpty) {
            return const Center(child: Text("No users available"));
          }
          return ListView.builder(
            itemCount: viewModel.userList.length,
            itemBuilder: (context, index) {
              var user = viewModel.userList[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(otherUid: user.id,name: user.name,),
                    ),
                  );
                },
                title: Text(user.name),
                subtitle: Text(user.email),
                leading: CircleAvatar(
                  child: Text(user.name[0].toUpperCase()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
