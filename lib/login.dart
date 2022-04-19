import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/home.dart';
import 'package:fit_tracker/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  static Future<User?> loginin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print('No User Found with that email');
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 50,),

            //circular avatar & Login text
            Container(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black12,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Center(
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            //input and button
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    style: GoogleFonts.poppins(),
                    controller: emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  TextField(
                    style: GoogleFonts.poppins(),
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          User? user = await loginin(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context);
                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({
                              'uid': user.uid,
                              'nama': user.displayName,
                              'email': user.email,
                              'gender': '',
                              'birth': '',
                              'height': ''
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Email/Password salah, silahkan masukkan kembali'),
                              duration: Duration(seconds: 5),
                            ));
                            emailController.clear();
                            passwordController.clear();
                          }
                        },
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.poppins(fontSize: 20),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xff69BCFC)),
                            shape: MaterialStateProperty.all<StadiumBorder>(
                                const StadiumBorder())),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      width: 500,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In With Google',
                              style: GoogleFonts.poppins(fontSize: 20),
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<StadiumBorder>(
                                const StadiumBorder())),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have Account?",
                        style: GoogleFonts.poppins(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Register()));
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
