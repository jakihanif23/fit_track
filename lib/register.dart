import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String email = '';
  String password = '';
  String nama = '';
  final AuthService authService = AuthService();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formkey,
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
                        'Sign Up',
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
                    TextFormField(
                      style: GoogleFonts.poppins(),
                      controller: nameController,
                      validator: (val) =>
                          val!.isEmpty ? 'Input Your Name' : null,
                      onChanged: (val) => nama = val,
                      decoration: const InputDecoration(hintText: "Name"),
                    ),
                    TextFormField(
                      style: GoogleFonts.poppins(),
                      controller: emailController,
                      validator: (val) =>
                          val!.isEmpty ? 'Input Your Email' : null,
                      onChanged: (val) => email = val,
                      decoration: const InputDecoration(hintText: "Email"),
                    ),
                    TextFormField(
                      style: GoogleFonts.poppins(),
                      obscureText: true,
                      controller: passwordController,
                      validator: (val) => val!.length < 6
                          ? 'Minimum password 6 character'
                          : null,
                      onChanged: (val) => password = val,
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
                            if (_formkey.currentState!.validate()) {
                              _register(email, password);
                              nameController.clear();
                              emailController.clear();
                              passwordController.clear();
                              print(auth.currentUser);
                            }
                          },
                          child: Text(
                            'Sign Up',
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
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Have Account?",
                          style: GoogleFonts.poppins(),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Sign In',
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
      ),
    );
  }

  _register(String _email, String _password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;
        user!.updateDisplayName(nama);
        var FUser = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(FUser).set({
          'uid': FUser,
          'nama': nama,
          'email': email,
          'password': password,
          'gender': '',
          'birth': '',
          'height': ''
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Register Berhasil, Silahkan ke Halaman Login'),
          duration: Duration(seconds: 5),
        ));
      });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Registrasi Failed'),
                content: Text('${e.message}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'),
                  )
                ],
              ));
    }
  }
}
