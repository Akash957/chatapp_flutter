import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../Provider/ChatViewModel.dart';
import '../Provider/UserViewModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoginMode = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<UserViewModel>(context, listen: false)
          .checkUserLoginStatus(context);
      Provider.of<ChatViewModel>(context, listen: false).getUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          isLoginMode ? "Login" : "Register",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoginMode
                      ? "Login to your account:"
                      : "Register your account:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                if (!isLoginMode)
                  showInputField(
                    controller: viewModel.nameController,
                    hint: "Enter your name",
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                showInputField(
                  controller: viewModel.emailController,
                  hint: "Enter your email",
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                showInputField(
                  controller: viewModel.passwordController,
                  hint: "Enter your password",
                  icon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isLoginMode)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoginMode = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    if (!isLoginMode)
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.registerNow(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        if (isLoginMode) {
                          if (_formKey.currentState!.validate()) {
                            bool isSuccess = await viewModel.loginNow(context);
                            if (isSuccess) {
                              Fluttertoast.showToast(msg: "Login successfully");
                            } else {
                              Fluttertoast.showToast(msg: "Login failed");
                            }
                          }
                        } else {
                          setState(() {
                            isLoginMode = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        isLoginMode ? "Login" : "Login",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget showInputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      validator: validator,
      style: TextStyle(fontSize: 16),
    ),
  );
}
