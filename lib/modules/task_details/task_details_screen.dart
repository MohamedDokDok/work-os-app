import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:work_os_app/modules/profile/profile_screen.dart';
import 'package:work_os_app/shared/component.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  final String uploadedBy;

  const TaskDetailsScreen({
    required this.taskId,
    required this.uploadedBy,
  });

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isComment = false;
  String? taskDescription;
  String? title;
  String? currentUserId;
  String? imgUrl;
  String? imgUrl2;
  String? name;
  String? name2;
  String? position;
  String? uploadDate;
  String? deadlineDate;
  bool? isDone;
  bool? isAvailable;
  var temp;
  TextEditingController commentController = TextEditingController();

  void getTaskData() {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get()
        .then((value) {
      if (value.data() == null) {
        return;
      } else {
        setState(() {
          taskDescription = value.get('Description');
          isDone = value.get('IsDone');
          title = value.get('Title');
          deadlineDate = value.get('Date');
          uploadDate = value.get('DateTimeUpload');
          temp = value.get('DeadlineDateTimeStamp').toDate();
          isAvailable = temp.isAfter(DateTime.now());
        });
      }
    }).catchError((error) {});
  }

  void getUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get()
        .then((value) {
      if (value.data() == null) {
        return;
      } else {
        setState(() {
          name = value.get('name');
          position = value.get('position');
          imgUrl = value.get('imageUrl');
        });
      }
    }).catchError((error) {
      print(error.toString());
    });
  }
  void getCurrentUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get()
        .then((value) {
      if (value.data() == null) {
        return;
      } else {
        setState(() {
          name2= value.get('name');
          imgUrl2 = value.get('imageUrl');
        });
      }
    }).catchError((error) {
      print(error.toString());
    });
  }



  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getTaskData();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[50],
        elevation: 0.0,
        titleSpacing: 30.0,
        leadingWidth: 80.0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              color: Colors.deepOrange[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.red.shade800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'Uploaded By',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red),
                          ),
                        ),
                       const SizedBox(
                         width: 20.0,
                       ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.deepOrange.shade200,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                  imgUrl ??
                                      'https://image.freepik.com/free-vector/log-into-several-devices-responsive-app-design-wifi-zone-gadgets-online-communication-social-networking-web-connection-initialize-sign-up-vector-isolated-concept-metaphor-illustration_335657-4301.jpg',
                                ),
                                fit: BoxFit.fill),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              ),
                              Text(
                                position ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Uploaded on:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red),
                        ),
                        Text(
                          uploadDate ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Deadline date:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red),
                        ),
                        Text(
                          deadlineDate ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        isAvailable ?? true
                            ? 'Still have enough time'
                            : 'Not Available',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Done state:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: TextButton(
                          child: const Text('Done',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.deepOrange)),
                          onPressed: () {
                            setState(() {
                              final String currentId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              if (currentId == widget.uploadedBy) {
                                setState(() {
                                  isDone = true;
                                });
                              }else{
                                flatToast(text: 'Can Not Edit By You', state: stateToast.ERROR);
                              }
                            });
                          },
                        )),
                        Opacity(
                          opacity: isDone ?? false ? 1 : 0,
                          child: Icon(
                            Icons.check_box,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Flexible(
                            child: TextButton(
                          child: Text('Not Done',
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.deepOrange)),
                          onPressed: () {
                            final String currentId =
                                FirebaseAuth.instance.currentUser!.uid;
                            if (currentId == widget.uploadedBy) {
                              setState(() {
                                isDone = false;
                              });
                            }else{
                              flatToast(text: 'Can Not Edit By You', state: stateToast.ERROR);
                            }
                          },
                        )),
                        Opacity(
                          opacity: isDone ?? true ? 0 : 1,
                          child: Icon(
                            Icons.check_box,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Task description:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      taskDescription ?? '',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isComment == true
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: TextField(
                                    maxLength: 200,
                                    controller: commentController,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      errorBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.pink),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (commentController.text.length >
                                                7) {
                                              final commentID = Uuid().v4();
                                              FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(widget.taskId)
                                                  .update({
                                                'TaskComment':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'commentID': commentID,
                                                    'userID': currentUserId,
                                                    'commentBody':
                                                        commentController.text,
                                                    'name': name2,
                                                    'userImageUrl': imgUrl2,
                                                    'Time': Timestamp.now(),
                                                  }
                                                ])
                                              }).then((value) {
                                                flatToast(
                                                    text:
                                                        'Comment Successfully',
                                                    state: stateToast.SUCCESS);
                                                setState(() {
                                                  isComment = false;
                                                  commentController.text = '';
                                                });
                                              }).catchError((error) {
                                                flatToast(
                                                    text: error.toString(),
                                                    state: stateToast.ERROR);
                                              });
                                            } else {
                                              flatToast(
                                                  text:
                                                      'Invalid Comment length must be more than 7 character',
                                                  state: stateToast.ERROR);
                                            }
                                          },
                                          color: Colors.pink.shade700,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              side: BorderSide.none),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            child: Text(
                                              'Post',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  // fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isComment = false;
                                                commentController.text = '';
                                              });
                                            },
                                            child: Text('Cancel')),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    isComment = !isComment;
                                  });
                                },
                                color: Colors.pink.shade700,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    side: BorderSide.none),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Add a comment',
                                    style: TextStyle(
                                        color: Colors.white,
                                        // fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.taskId)
                          .get(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text(
                                'No Comment Yet',
                              ),
                            );
                          }
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => commentItemBuilder(
                            commentUserId: snapshot.data!['TaskComment'][index]
                            ['userID'],
                              userImgUlr: snapshot.data!['TaskComment'][index]
                                  ['userImageUrl'],
                              nameOfUser: snapshot.data!['TaskComment'][index]
                                  ['name'],
                              commentBody: snapshot.data!['TaskComment'][index]
                                  ['commentBody']),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: snapshot.data!['TaskComment'].length,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commentItemBuilder({
    required String userImgUlr,
    required String nameOfUser,
    required String commentBody,
    required String commentUserId,
  }) =>
      InkWell(
        onTap: () {
          navigateTo(
              widget:
                  ProfileScreen(userId: commentUserId),
              context: context,);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.deepOrange,
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                        userImgUlr,
                      ),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameOfUser,
                      maxLines: 1,
                      style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      commentBody,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
