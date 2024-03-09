import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky_ease/UI/screens/dashboard.dart';

import '../const/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool passwordVisible = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.lightColor,
      appBar: AppBar(
        title: Text("Login",style: headingStyle,),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.25,),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: "Enter your email",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1, color: Themes.darkColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Themes.mainColor),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              const SizedBox(
                height:20,
              ),
              Obx (()=>TextField(
                controller: password,
                keyboardType: TextInputType.text,
                obscureText: passwordVisible.value,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: Themes.darkColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Themes.mainColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        passwordVisible.toggle();
                      },
                      icon: Icon(passwordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility)),
                ),
              ),
              ),
              const SizedBox(
                height:20,
              ),
              ElevatedButton(onPressed: () async {
                if (email.text.isNotEmpty && password.text.isNotEmpty) {
                  try {
                    UserCredential userData = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: email.text.trim(),
                        password: password.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Login Successfully.',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                    if (userData.user != null) {
                      Get.offAll( () => const Dashboard());
                    }
                  } on FirebaseAuthException catch (e) {
                    print(
                        "#########Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.message.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill in all fields.',
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(
                          seconds: 2), // Adjust the duration as needed
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }, child: Text("Login",style: titleStyle,)),
            ],
          ),
        ),
      ),
    );
  }
}
