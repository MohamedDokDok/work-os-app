import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_os_app/modules/home/home_screen.dart';
import 'package:work_os_app/shared/component.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  bool isMe = false;
  String name = '';
  String phone = '';
  String email = '';
  String posJob = '';
  String imgUrl = '';
  String joinDateAt = '0';

  void getUserDate() async {
    isLoading = true;
    try {
      final DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userData.data() == null) {
        return;
      } else {
        email = userData.get('email');
        phone = userData.get('phone');
        name = userData.get('name');
        posJob = userData.get('position');
        imgUrl = userData.get('imageUrl');
        Timestamp date = userData.get('createTimedAt');
        joinDateAt = DateFormat.yMMMd().format(date.toDate());
        String currentUserId = FirebaseAuth.instance.currentUser!.uid;
        setState(() {
          isMe = currentUserId == widget.userId;
        });
      }
    } catch (error) {
      print(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            navigateFinish(widget: HomeScreen(), context: context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.deepOrange[50],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 60.0),
          child: Stack(
            children: [
              Card(
                margin: const EdgeInsets.all(30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          name,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$posJob Since joined $joinDateAt',
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Contact Info',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      socialInfo(label: 'email Address', content: email),
                      const SizedBox(
                        height: 10,
                      ),
                      socialInfo(label: 'Phone', content: phone),
                      const SizedBox(
                        height: 10,
                      ),
                      if (!isMe)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            socialButtons(
                                color: Colors.green,
                                icon: Icons.whatshot_rounded,
                                fct: () {
                                  openWhatsApp();
                                }),
                            socialButtons(
                                color: Colors.red,
                                icon: Icons.mail_outline_outlined,
                                fct: () {
                                  mailTo();
                                }),
                            socialButtons(
                              color: Colors.purple,
                              icon: Icons.call_outlined,
                              fct: () {
                                call();
                              },
                            ),
                          ],
                        ),
                      if (!isMe)
                        const SizedBox(
                          height: 20,
                        ),
                      if (isMe)
                        const Divider(
                          thickness: 1,
                        ),
                      if (isMe)
                        const SizedBox(
                          height: 20,
                        ),
                      if (isMe)
                        defaultButton(
                          onPress: () {
                            logout(context);
                          },
                          text: 'Logout',
                          icon: Icons.logout,
                          color: Colors.deepOrange.shade700,
                        ),
                      if (isMe)
                        const SizedBox(
                          height: 15.0,
                        )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 5,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imgUrl == ''
                              ? const NetworkImage(
                                  'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png')
                              : NetworkImage(imgUrl),
                          fit: BoxFit.fill)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget socialButtons({
    required Color color,
    required IconData icon,
    required Function fct,
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void openWhatsApp() async {
    var whatsappUrl = 'https://wa.me/$phone?text=HelloThere';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void mailTo() async {
    var mailUrl = 'mailto:$email';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void call() async {
    var phoneGoTo = 'tel://$phone';
    if (await canLaunch(phoneGoTo)) {
      await launch(phoneGoTo);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  Widget socialInfo({required String label, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}
