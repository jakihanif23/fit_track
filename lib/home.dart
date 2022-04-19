import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/card.dart';
import 'package:fit_tracker/navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  var ref = FirebaseFirestore.instance.collection('users');
  TextEditingController weightcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Fit Tracker'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 450,
            child: ListView(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: ref.doc(user!.uid).collection('weight').snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.docs
                            .map((e) =>
                                ItemCard(e['weight'], e['date'], onDelete: () {
                                  ref
                                      .doc(user!.uid)
                                      .collection('weight')
                                      .doc()
                                      .delete();
                                }))
                            .toList(),
                      );
                    } else {
                      return const Center(child: Text('loading'));
                    }
                  },
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-5, 0),
                      blurRadius: 15,
                      spreadRadius: 3)
                ]),
                width: double.infinity,
                height: 230,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            style: GoogleFonts.poppins(),
                            controller: weightcontroller,
                            decoration:
                                const InputDecoration(hintText: "Weight"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            DateFormat.yMMMEd().format(DateTime.now()),
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 130,
                      width: 130,
                      padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.amber,
                          child: Text(
                            'Add Data',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            //// ADD DATA HERE
                            ref.doc(user!.uid).collection('weight').add({
                              'weight': weightcontroller.text,
                              'date': DateFormat.yMMMEd()
                                  .format(DateTime.now())
                                  .toString(),
                            });
                            weightcontroller.text = '';
                          }),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
