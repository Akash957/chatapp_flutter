import 'package:flutter/material.dart';

import 'HomePage.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;

  const ProfileScreen({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profiles Screen'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTSKbCFe_QYSVH-4FpaszXvakr2Eti9eAJpQ&s",
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name, // Display user's name
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email, // Display user's email
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                  ),
                  child: const Text(
                    'Open Instagram',
                    style: TextStyle(fontSize: 16, color: Colors.black,),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                menuItem(context, Icons.lock, 'Account'),
                menuItem(context, Icons.message, 'Chats'),
                menuItem(context, Icons.notifications_active, 'Notifications'),
                menuItem(context, Icons.data_usage, 'Data and Security'),
                menuItem(context, Icons.help, 'Help'),
                menuItem(context, Icons.logout, 'Logout', isLast: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(BuildContext context, IconData icon, String title,
      {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {},
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.amber,
          ),
      ],
    );
  }
}
