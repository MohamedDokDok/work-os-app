import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_os_app/modules/profile/profile_screen.dart';
import 'package:work_os_app/shared/component.dart';

class AllPeopleScreen extends StatefulWidget {
  @override
  _AllPeopleScreenState createState() => _AllPeopleScreenState();
}

class _AllPeopleScreenState extends State<AllPeopleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: drawerBuilder(context),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'All Users',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: Colors.deepOrange.shade900,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              final currentID = FirebaseAuth.instance.currentUser!.uid;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    currentID == snapshot.data!.docs[index]['uId']
                        ? Container()
                        : userItemBuilder(
                            userId: snapshot.data!.docs[index]['uId'],
                            posJob: snapshot.data!.docs[index]['position'],
                            name: snapshot.data!.docs[index]['name'],
                            imgUrl: snapshot.data!.docs[index]['imageUrl'],
                            phone: snapshot.data!.docs[index]['phone'],
                            email: snapshot.data!.docs[index]['email'],
                          ),
                itemCount: snapshot.data!.docs.length,
              );
            } else {
              return const Center(
                child: Text('No user found'),
              );
            }
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  /*
   final String userId;
  final String name;
  final String posJob;
  final String imgUrl;
  final String email;
  final String phone;

   AllPeopleScreen(
      {required this.userId,
      required this.name,
      required this.posJob,
      required this.imgUrl,
      required this.email,
      required this.phone});
   */
  Widget userItemBuilder({
    required String userId,
    required String posJob,
    required String name,
    required String imgUrl,
    required String email,
    required String phone,
  }) =>
      Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListTile(
            onTap: () {
              navigateTo(
                  widget: ProfileScreen(userId: userId), context: context);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1.0),
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.linear_scale,
                  color: Colors.pink.shade800,
                ),
                Text(
                  '$posJob \n $phone',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.mail_outline_outlined,
                size: 30,
                color: Colors.pink[800],
              ),
              onPressed: () async {
                var mailUrl = 'mailto:$email';
                if (await canLaunch(mailUrl)) {
                  await launch(mailUrl);
                } else {
                  throw 'Error occured coulnd\'t open link';
                }
              },
            )),
      );
}
