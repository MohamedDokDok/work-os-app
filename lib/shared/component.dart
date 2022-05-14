
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:work_os_app/modules/create_task/create_task_screen.dart';
import 'package:work_os_app/modules/home/home_screen.dart';
import 'package:work_os_app/modules/login/login_screen.dart';
import 'package:work_os_app/modules/people/all_people_screen.dart';
import 'package:work_os_app/modules/profile/profile_screen.dart';


void navigateTo({
  required Widget widget,
  required BuildContext context,
}) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),);

void navigateFinish({
  required Widget widget,
  required BuildContext context,
}) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
            (route) => false,
    );

Widget backGroundImagesAnimation({
  required Animation<double> animation,
  required String imgUrl,
}) =>
    FadeInImage(
      alignment: FractionalOffset(animation.value, 0),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: const AssetImage(
        'assets/images/login.png',
      ),
      image: NetworkImage(
        imgUrl,
      ),
    );

Widget defaultTextFormFiled({
  required TextEditingController controller,
  required String hint,
  required TextInputType type,
  required FormFieldValidator<String> validator,
  IconData? suffixIcon,
  Function? suffixIconPress,
  bool isObscure = false,
  FocusNode? focusNode,
  TextInputAction action = TextInputAction.done,
  Function? onEditingComplete,
  bool isFill = false,
  bool isBorder = true,
  Color? backGroundTextFormFieldColor,
  bool enable = true,
  int maxLines = 1,
  int? maxLength,
  InputBorder border = InputBorder.none,
}) =>
    TextFormField(
      focusNode: focusNode,
      textInputAction: action,
      onEditingComplete: () {
        onEditingComplete!();
      },
      controller: controller,
      obscureText: isObscure,
      enabled: enable,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        filled: isFill,
        fillColor: backGroundTextFormFieldColor,
        border: isFill ? border : null,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: () {
                  suffixIconPress!();
                },
                icon: Icon(
                  suffixIcon,
                  color: Colors.black,
                ),
              ),
        enabledBorder: isBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              )
            : null,
        focusedBorder: isBorder
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepOrange.shade700,
                  width: 2,
                ),
              )
            : null,
        errorBorder: isBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              )
            : null,
      ),
      cursorColor: Colors.deepOrange.shade700,
      keyboardType: type,
      validator: validator,
    );

Widget defaultButton({
  required Function onPress,
  Color color = Colors.deepOrange,
  Color textColor = Colors.white,
  Color iconColor = Colors.white,
  required String text,
  IconData? icon,
}) =>
    MaterialButton(
      onPressed: () {
        onPress();
      },
      color: color,
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13), side: BorderSide.none),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              text,
              style: TextStyle(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          if (icon != null)
            Icon(
              icon,
              color: iconColor,
            ),
        ],
      ),
    );

Widget catBuilder(index, {Function? onTap }) => ListTile(
      onTap: (){
        onTap!();
      },
  leading: const Icon(
    Icons.check_box_outline_blank_outlined ,
  ),
  title: Text(
    taskCategoryList[index],
    style: const TextStyle(
      fontSize: 18.0,
    ),
  ),
  contentPadding: const EdgeInsets.symmetric(
      horizontal: 5.0,
  ),
    );

List<String> taskCategoryList = [
  'Business',
  'Programming',
  'Information Technology',
  'Human resources',
  'Marketing',
  'Design',
  'Accounting',
];

showDialogBuilder({
  required context,
  required String title,
  required Widget content,
   List<Widget>? actions,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.deepOrange[300],
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: content,
        actions: actions,
    ),);



Widget listTiles({
  required String title,
  required Function onTap,
  required IconData icon,
}) =>
    ListTile(
      onTap: () {
        onTap();
      },
      leading: Icon(
        icon,
        color: Colors.red.shade400,
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontStyle: FontStyle.italic),
      ),
    );

Widget drawerBuilder(context) => Drawer(
    child: ListView(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange[50]),
            child: Column(
              children: [
                Flexible(
                    child: Image.network(
                        'http://assets.stickpng.com/thumbs/5f439d47777cdb0004f2ecae.png',
                      fit: BoxFit.cover,
                    ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Flexible(
                    child: Text(
                      'Work OS Arabic',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                          fontSize: 22,
                          fontStyle: FontStyle.italic),
                    ))
              ],
            )),
        const SizedBox(
          height: 30,
        ),
        listTiles(
          title: 'All tasks',
          onTap: () {
            navigateFinish(widget: HomeScreen(), context:context);
          },
          icon: Icons.task_outlined,
        ),
        listTiles(
          title: 'My account',
          onTap: () {
            final String userId = FirebaseAuth.instance.currentUser!.uid;
            navigateTo(widget: ProfileScreen(userId: userId,), context: context);
          },
          icon: Icons.settings_outlined,
        ),
        listTiles(
          title: 'People',
          onTap: () {
            navigateTo(widget: AllPeopleScreen(), context: context);
          },
          icon: Icons.workspaces_outline,
        ),
        listTiles(
          title: 'Add task',
          onTap: () {
            navigateTo(widget: AddTaskScreen(), context: context);
          },
          icon: Icons.add_task_outlined,
        ),
        const Divider(
          thickness: 1,
        ),
        listTiles(
          title: 'Logout',
          onTap: () {
            logout(context);
          },
          icon: Icons.logout_outlined,
        ),

      ],
    ));


void logout(context) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                'https://image.flaticon.com/icons/png/128/1252/1252006.png',
                height: 20,
                width: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Sign out'),
            ),
          ],
        ),
        content: const Text(
          'Do you wanna Sign out',
          style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 20,
              fontStyle: FontStyle.italic),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            child: const Text('Cancel'),
          ),
          TextButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                navigateFinish(widget: statsOfUser(),context: context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ))
        ],
      );
    });


void flatToast({
  required String text,
  required stateToast state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: toastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum stateToast { SUCCESS, ERROR, WARNING }

Color toastColor(stateToast state) {
  Color? color;
  switch (state) {
    case stateToast.SUCCESS:
      color = Colors.green;
      break;
    case stateToast.ERROR:
      color = Colors.red;
      break;
    case stateToast.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}


Widget statsOfUser(){
  return StreamBuilder (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:  (context, userSnapshot) {
        if (userSnapshot.data == null) {
          if(userSnapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              backgroundColor: Colors.deepOrange.shade50,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.deepOrange.shade200,
                      color: Colors.deepOrange.shade600,
                    ),
                    Text(
                      'App Loading, Please Wait',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        height: 2,
                        color: Colors.green.shade200,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }else {
            return LoginScreen();
          }
        } else if (userSnapshot.hasData) {
            return HomeScreen();
        } else if (userSnapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red.shade400,
                ),
                Text(
                  'Loading Failed!! Please Try Again',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    height: 2,
                    color: Colors.green.shade200,
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red.shade400,
                ),
                Text(
                  'Failed!! Please Try Again',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    height: 2,
                    color: Colors.green.shade200,
                  ),
                ),
              ],
            ),
          ),
        );
      }
  );
}