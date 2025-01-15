import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../PageScreen/HomePage.dart';

class UserViewModel with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final nameHint = "Enter name";
  final emailHint = "Enter email";
  final passHint = "Enter password";

  loginNow(BuildContext context) async {
    var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString());
    if (result.user != null) {
      navigate(const HomePage(), context);
    }
  }

  registerNow(BuildContext context) async {
    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString());
    if (result.user != null) {
      var uid = result.user?.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

      await ref.set({
        "id": uid,
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      });
      clearInputText();
      Fluttertoast.showToast(msg: "Register successfully");
      navigate(const HomePage(), context);
    }
  }

  clearInputText() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  checkUserLoginStatus(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      navigate(HomePage(), context);
    }
  }
}

navigate(Widget page, BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}
