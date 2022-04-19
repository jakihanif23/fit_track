import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController namacontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController gendercontroller = TextEditingController();
  TextEditingController birthcontroller = TextEditingController();
  TextEditingController heightcontroller = TextEditingController();

  String nama = '';
  String email = '';
  String gender = '';
  String birth = '';
  String height = '';

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: ref.snapshots(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var accdoc = snapshot.data;
                  return Container(
                    child: Center(
                      child: Column(
                        children: [
                          Text(accdoc!['nama'],
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          Text(accdoc['email'],
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.w300)),
                          Text(
                              accdoc['gender'] == ''
                                  ? "gender not set"
                                  : accdoc['gender'],
                              style: GoogleFonts.poppins(
                                  fontSize: 17, fontWeight: FontWeight.w300)),
                          Text(
                              accdoc['birth'] == ''
                                  ? "date of birth not set"
                                  : accdoc['birth'],
                              style: GoogleFonts.poppins(
                                  fontSize: 17, fontWeight: FontWeight.w300)),
                          Text(
                              accdoc['height'] == ''
                                  ? "height not set"
                                  : '${accdoc['height']} cm',
                              style: GoogleFonts.poppins(
                                  fontSize: 17, fontWeight: FontWeight.w300)),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              width: 500,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  namacontroller.text = accdoc['nama'];
                                  emailcontroller.text = accdoc['email'];
                                  gendercontroller.text = accdoc['gender'];
                                  birthcontroller.text = accdoc['birth'];
                                  heightcontroller.text = accdoc['height'];
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Edit Profile'),
                                          content: SizedBox(
                                            height: 500,
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: namacontroller,
                                                  autofocus: true,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Name',
                                                          labelText: 'Name'),
                                                ),
                                                TextField(
                                                  controller: emailcontroller,
                                                  autofocus: true,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Email',
                                                          labelText: 'Email'),
                                                ),
                                                TextField(
                                                  controller: gendercontroller,
                                                  autofocus: true,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Gender',
                                                          labelText: 'Gender'),
                                                ),
                                                TextField(
                                                  controller: birthcontroller,
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  autofocus: true,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              'Date of Birth',
                                                          labelText:
                                                              'Date of Birth'),
                                                ),
                                                TextField(
                                                  controller: heightcontroller,
                                                  autofocus: true,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Height',
                                                          labelText: 'Height'),
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        nama =
                                                            namacontroller.text;
                                                        gender =
                                                            gendercontroller
                                                                .text;
                                                        birth = birthcontroller
                                                            .text;
                                                        height =
                                                            heightcontroller
                                                                .text;
                                                      });
                                                      user!.updateDisplayName(
                                                          namacontroller.text);
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(user!.uid)
                                                          .set({
                                                        'nama': nama,
                                                        'email':
                                                            '${user!.email}',
                                                        'gender': gender,
                                                        'birth': birth,
                                                        'height': height
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Success Update Profile'),
                                                                  duration:
                                                                      Duration(
                                                                    seconds: 2,
                                                                  )));
                                                    },
                                                    child: const Text('Update'))
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Edit Profile',
                                      style: GoogleFonts.poppins(fontSize: 20),
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green),
                                    shape: MaterialStateProperty.all<
                                        StadiumBorder>(const StadiumBorder())),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
