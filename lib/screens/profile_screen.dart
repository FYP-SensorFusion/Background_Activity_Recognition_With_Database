import 'package:lifespark/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePageScreen extends StatefulWidget {
  ProfilePageScreen({Key? key}) : super(key: key);

  @override
  _ProfilePageScreenState createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/purple-sky.png'),
                fit: BoxFit.fill),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/black-1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: height / 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                          const AssetImage('assets/images/sample-profile.png'),
                      radius: height / 10,
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: height / 3, left: width / 25, right: width / 25),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/purple-sky.png"),
                    fit: BoxFit.fill,
                  ),
                  color:
                      Colors.purple.shade200, // Use a darker teal for contrast
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    infoChild(width, Icons.email, user?.email),
                    infoChild(width, Icons.verified_user,
                        user?.uid != null ? "Registered User" : "General User"),
                    infoChild(width, Icons.north_east_rounded,
                        user?.metadata.creationTime.toString()),
                    infoChild(width, Icons.north_west_rounded,
                        user?.metadata.lastSignInTime.toString()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget infoChild(double width, IconData icon, data) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width / 10,
              ),
              Icon(
                icon,
                color: const Color(0xFF26CBE6),
                size: 36.0,
              ),
              SizedBox(
                width: width / 10,
              ),
              Text(
                data,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );
}
