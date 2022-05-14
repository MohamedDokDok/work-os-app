import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_os_app/modules/task_details/task_details_screen.dart';
import 'package:work_os_app/shared/component.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade100,
      drawer: drawerBuilder(context),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        backgroundColor: Colors.deepOrange.shade50,
        title: Text(
          'Tasks',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: Colors.deepOrange.shade900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialogBuilder(
                context: context,
                title: 'All Categorise',
                content: Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => catBuilder(
                      index,
                      onTap: () {
                        setState(() {
                          filter = taskCategoryList[index];
                        });
                        print(filter);
                        print(taskCategoryList[index]);
                        Navigator.pop(context);
                      },
                    ),
                    itemCount: taskCategoryList.length,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        filter = null;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Clear Filter',
                    ),
                  ),
                ],
              );
            },
            icon: const Icon(
              Icons.filter_list_outlined,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('Category', isEqualTo: filter)
            .orderBy('DateTimeUploadTimestamp', descending: true)
            .snapshots().handleError((error) {
          print(error.toString());
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if(filter == null) {
              return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrange.shade200,
                color: Colors.deepOrange.shade600,
              ),
            );
            }else{
              return const Center(
                child: Text('No tasks found'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => taskBuilderItem(
                        context: context,
                        description: snapshot.data!.docs[index]['Description'],
                        title: snapshot.data!.docs[index]['Title'],
                        isDone: snapshot.data!.docs[index]['IsDone'],
                        taskId: snapshot.data!.docs[index]['TaskId'],
                        uploadBy: snapshot.data!.docs[index]['UploadBy'],
                      ),
                  separatorBuilder: (context, index) => Container(),
                  itemCount: snapshot.data!.docs.length);
            }
            else {
              return const Center(
                child: Text('No tasks found'),
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

  Widget taskBuilderItem({
    required BuildContext context,
    required String title,
    required String description,
    required bool isDone,
    required String taskId,
    required String uploadBy,
  }) =>
      Card(
        elevation: 10.0,
        margin: EdgeInsets.all(10.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 10.0,
          ),
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.linear_scale,
                color: Colors.deepOrange,
              ),
              // ignore: prefer_const_constructors
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          leading: Container(
            padding: const EdgeInsets.only(right: 12.0),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(width: 1.0),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20, //
              child: isDone == true
                  ? Icon(
                      Icons.done,
                      size: 30,
                      color: Colors.green,
                    )
                  : Icon(Icons.remove_red_eye),
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Colors.pink[800],
          ),
          onLongPress: () {
            final String currentId = FirebaseAuth.instance.currentUser!.uid;
            if (currentId == uploadBy) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(taskId)
                            .delete();
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_rounded,
                              size: 22.0, color: Colors.deepOrange),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 22.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          onTap: () {
            navigateTo(
                widget: TaskDetailsScreen(
                  taskId: taskId,
                  uploadedBy: uploadBy,
                ),
                context: context);
          },
        ),
      );
}
