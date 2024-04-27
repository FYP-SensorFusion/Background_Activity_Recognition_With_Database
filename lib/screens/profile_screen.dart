import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePageScreen extends StatefulWidget {
  ProfilePageScreen({Key? key, required this.title}) : super(key: key);

  final String title;

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
        title: const Text('Profile Details'),
        centerTitle: true,
      ),
      body: Stack(
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
            padding: EdgeInsets.only(top: height / 2.2),
            child: Container(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: height / 2.6, left: width / 20, right: width / 20),
            child: Column(
              children: <Widget>[
                infoChild(width, Icons.email, user?.email),
                infoChild(width, Icons.verified_user, user?.uid != null ? "General User" : "Registered User"),
                infoChild(width, Icons.north_east_rounded, user?.metadata.creationTime.toString()),
                infoChild(width, Icons.north_west_rounded, user?.metadata.lastSignInTime.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget headerChild(String header, int value) => Expanded(
          child: Column(
        children: <Widget>[
          Text(header),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            '$value',
            style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF26CBE6),
                fontWeight: FontWeight.bold),
          )
        ],
      ));

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
                width: width / 20,
              ),
              Text(data)
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
