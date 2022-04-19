import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/account.dart';
import 'package:fit_tracker/login.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user!.displayName.toString()),
            accountEmail: Text(user!.email.toString()),
            currentAccountPicture: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Account()));
            },
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Account'),
            ),
          ),
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Login()));
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }
}
