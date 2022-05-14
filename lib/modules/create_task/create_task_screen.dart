import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:work_os_app/modules/home/home_screen.dart';
import 'package:work_os_app/shared/component.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController catController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Timestamp? deadlineDateTimeStamp;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    catController.dispose();
    titleController.dispose();
    desController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            navigateFinish(widget: HomeScreen(), context: context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.black,),
        ),
        centerTitle: true,
        title:  const Text(
          'Add Task',
          style: TextStyle(
              fontSize: 25,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange[50],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'All field are required',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),

                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textBuilder(textLabel: 'Task category*'),
                          InkWell(
                            onTap: () {
                              showDialogBuilder(
                                context: context,
                                title: 'All Categorise',
                                content: Container(
                                  width: 300,
                                  height: 300,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        catBuilder(index, onTap: () {
                                          catController.text =
                                          taskCategoryList[index];
                                          Navigator.pop(context);
                                        }),
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
                                ],
                              );
                            },
                            child: defaultTextFormFiled(
                              enable: false,
                              onEditingComplete: (){},
                              controller: catController,
                              isFill: true,
                              backGroundTextFormFieldColor: Colors.grey[300],
                              border: InputBorder.none,
                              isBorder: false,
                              hint: '',
                              type: TextInputType.none,
                              validator: (String? email){}
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          textBuilder(textLabel: 'Task Title*'),
                          defaultTextFormFiled(
                            controller: titleController,
                            onEditingComplete: (){},
                            isFill: true,
                            backGroundTextFormFieldColor: Colors.grey[300],
                            border: InputBorder.none,
                            isBorder: false,
                            hint: '',
                            type: TextInputType.emailAddress,
                            validator: (String? email) {
                              if (email!.isEmpty) {
                                return 'Enter Invalid Title';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          textBuilder(textLabel: 'Task Description*'),
                          defaultTextFormFiled(
                            controller: desController,
                            onEditingComplete: (){},
                            isFill: true,
                            maxLength: 2000,
                            maxLines: 6,
                            backGroundTextFormFieldColor: Colors.grey[300],
                            border: InputBorder.none,
                            isBorder: false,
                            hint: '',
                            type: TextInputType.emailAddress,
                            validator: (String? email) {
                              if (email!.isEmpty) {
                                return 'Enter Invalid Descriptions';
                              } else {
                                return null;
                              }
                            },
                          ),
                          textBuilder(textLabel: 'Task  Deadline date*'),
                          InkWell(
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100))
                                  .then((value) {
                                if (value != null) {
                                  deadlineDateTimeStamp =
                                      Timestamp.fromMicrosecondsSinceEpoch(
                                          value.microsecondsSinceEpoch);
                                  dateController.text =
                                      DateFormat.yMMMd().format(value);
                                }
                              }).catchError((error) {
                                print(error.toString());
                              });
                            },
                            child: defaultTextFormFiled(
                              controller: dateController,
                              onEditingComplete: (){},
                              enable: false,
                              isFill: true,
                              backGroundTextFormFieldColor: Colors.grey[300],
                              border: InputBorder.none,
                              isBorder: false,
                              hint: '',
                              type: TextInputType.text,
                              validator: (String? email) {},
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                   const SizedBox(
                     height: 25.0,
                   ),
                  !isLoading ?
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                     child: defaultButton(
                              onPress: () {
                                final String taskID =  Uuid().v4();
                                final String userID = FirebaseAuth.instance.currentUser!.uid;
                                FocusScope.of(context).unfocus();
                                if(formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if(catController.text.isEmpty || dateController.text.isEmpty){
                                    flatToast(text: 'Fill All Filed', state: stateToast.ERROR);
                                  }
                                  else {
                                    FirebaseFirestore.instance.collection('tasks').doc(taskID).set({
                                  'TaskId' : taskID,
                                  'UploadBy' : userID,
                                  'Title' : titleController.text,
                                  'Description' : desController.text,
                                  'Date' : dateController.text,
                                  'Category' : catController.text,
                                  'TaskComment' : [],
                                  'IsDone' : false,
                                  'DateTimeUpload' : DateFormat.yMMMd().format(DateTime.now()),
                                  'DateTimeUploadTimestamp' :Timestamp.now(),
                                  'DeadlineDateTimeStamp' : deadlineDateTimeStamp,

                                }).then((value){
                                      flatToast(text: 'UploadDone', state: stateToast.SUCCESS);
                                      navigateFinish(widget: HomeScreen(), context: context);
                                      setState(() {
                                        isLoading = false;
                                      });
                                }).catchError((onError){
                                      setState(() {
                                        isLoading = false;
                                      });
                                      flatToast(text: onError.toString(), state: stateToast.ERROR);
                                });
                                  }
                                }
                                else{
                                  flatToast(text: 'Fill All Filed', state: stateToast.ERROR);
                                }
                              },
                              text: 'Done',
                            ),
                   ) : const Center(child: CircularProgressIndicator(),),

                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textBuilder({
    required String? textLabel,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          textLabel!,
          style: TextStyle(
              fontSize: 18,
              color: Colors.red.shade900,
              fontWeight: FontWeight.bold),
        ),
      );


}
