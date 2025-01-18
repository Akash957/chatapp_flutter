import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/UserViewModel.dart';
import 'ChatPage.dart';
import 'ProfileScreen.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserViewModel>(context, listen: false)
          .fetchUserData(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Chat Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(name: "Name", email: "Email")));
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 34,
              )),
        ],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoding) {
            return Center(child: CircularProgressIndicator());
          } else if (userProvider.userData.isEmpty) {
            return Center(child: Text("No users found"));
          } else {
            return ListView.builder(
              itemCount: userProvider.userData.length,
              itemBuilder: (context, index) {
                var user = userProvider.userData[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          otherUid: user.id.toString(),
                          otherName: user.name.toString(),
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text("${user.name}"),
                      subtitle: Text("${user.email}"),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
