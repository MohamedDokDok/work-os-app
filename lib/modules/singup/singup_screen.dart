import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_os_app/modules/home/home_screen.dart';
import 'package:work_os_app/modules/login/login_screen.dart';
import 'package:work_os_app/shared/component.dart';

class SingUpScreen extends StatefulWidget {
  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _posTextController = TextEditingController();
  final _singUpKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isObscureConfirm = true;
  final imgUrl =
      'https://image.freepik.com/free-vector/log-into-several-devices-responsive-app-design-wifi-zone-gadgets-online-communication-social-networking-web-connection-initialize-sign-up-vector-isolated-concept-metaphor-illustration_335657-4301.jpg';
  final FocusNode _nameFCN = FocusNode();
  final FocusNode _emailFCN = FocusNode();
  final FocusNode _passwordFCN = FocusNode();
  final FocusNode _confirmPasswordFCN = FocusNode();
  final FocusNode _phoneFCN = FocusNode();
  final FocusNode _posFCN = FocusNode();
  File? imageFile;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 20,
      ),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(
            () => setState(() {}),
          )
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _confirmPasswordTextController.dispose();
    _nameTextController.dispose();
    _passwordTextController.dispose();
    _phoneTextController.dispose();
    _posTextController.dispose();
    _nameFCN.dispose();
    _emailFCN.dispose();
    _passwordFCN.dispose();
    _confirmPasswordFCN.dispose();
    _phoneFCN.dispose();
    _posFCN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backGroundImagesAnimation(animation: _animation, imgUrl: imgUrl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Sing Up',
                  style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Have Account?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: '     ',
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigateTo(widget: LoginScreen(), context: context);
                          },
                        text: 'LOGIN',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: _singUpKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: defaultTextFormFiled(
                              focusNode: _nameFCN,
                              action: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFCN),
                              controller: _nameTextController,
                              hint: 'Full Name',
                              type: TextInputType.name,
                              validator: (String? name) {
                                if (name!.isEmpty || name.length < 4) {
                                  return 'Enter Invalid Name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Flexible(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        width: 1.2,
                                        color: Colors.deepOrange.shade300,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: imageFile == null
                                          ? Image.asset(
                                              'assets/images/user.png',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(imageFile!,
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      showDialogBuilder(
                                        context: context,
                                        title: 'Choose Image',
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            listTiles(
                                              title: 'Camera',
                                              onTap: () {
                                                pickImageWithCamera();
                                              },
                                              icon: Icons.camera_alt,
                                            ),
                                            listTiles(
                                              title: 'Gallery',
                                              onTap: () {
                                                pickImageWithGallery();
                                              },
                                              icon: Icons.image_outlined,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          imageFile == null
                                              ? Icons.add_a_photo
                                              : Icons.edit_outlined,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultTextFormFiled(
                        focusNode: _emailFCN,
                        action: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_phoneFCN),
                        controller: _emailTextController,
                        hint: 'Email Address',
                        type: TextInputType.emailAddress,
                        validator: (String? email) {
                          if (email!.isEmpty ||
                              !email.contains('@') ||
                              email.indexOf('@') == email.length - 1) {
                            return 'Enter Invalid Email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultTextFormFiled(
                        focusNode: _phoneFCN,
                        action: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passwordFCN),
                        controller: _phoneTextController,
                        hint: 'Phone',
                        type: TextInputType.phone,
                        validator: (String? phone) {
                          if (phone!.isEmpty || phone.length < 11) {
                            return 'Enter Invalid Number';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultTextFormFiled(
                        focusNode: _passwordFCN,
                        action: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_confirmPasswordFCN),
                        controller: _passwordTextController,
                        isObscure: isObscure,
                        suffixIconPress: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        suffixIcon: !isObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        hint: 'Password',
                        type: TextInputType.visiblePassword,
                        validator: (String? password) {
                          if (password!.isEmpty || (password.length < 8)) {
                            return 'Enter Invalid Password';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultTextFormFiled(
                        focusNode: _confirmPasswordFCN,
                        action: TextInputAction.done,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        controller: _confirmPasswordTextController,
                        isObscure: isObscureConfirm,
                        suffixIconPress: () {
                          setState(() {
                            isObscureConfirm = !isObscureConfirm;
                          });
                        },
                        suffixIcon: !isObscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        hint: 'Confirm Password',
                        type: TextInputType.visiblePassword,
                        validator: (String? password) {
                          if (password!.isEmpty ||
                              (password.length < 8) ||
                              _confirmPasswordTextController.text !=
                                  _passwordTextController.text) {
                            return 'Not Matched Password';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      InkWell(
                        onTap: () {
                          showDialogBuilder(
                            context: context,
                            title: 'All Categorise',
                            content: Container(
                              height: 300,
                              width: 300,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    catBuilder(index, onTap: () {
                                  _posTextController.text =
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
                          focusNode: _posFCN,
                          action: TextInputAction.none,
                          controller: _posTextController,
                          hint: 'Position',
                          type: TextInputType.none,
                          validator: (String? pos) {
                            if (pos!.isEmpty) {
                              return 'Enter Invalid Number';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                !isLoading
                    ? defaultButton(
                        onPress: () {
                          singUp();
                        },
                        text: 'Sin Up',
                        icon: Icons.person_add_alt_1_outlined,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.deepOrange.shade200,
                          color: Colors.deepOrange.shade600,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isLoading = false;

  void singUp() async {
    final isValid = _singUpKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      if (imageFile == null) {
        showDialogBuilder(
          context: context,
          title: 'Error',
          content: const Text('Please Insert Image. All Filed Is Required'),
        );
      } else {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordTextController.text.toLowerCase().trim(),
          );
          final uId = FirebaseAuth.instance.currentUser!.uid;
          final ref = FirebaseStorage.instance
              .ref()
              .child('userImages')
              .child(uId + '.png');
          await ref.putFile(imageFile!);
          final url = await ref.getDownloadURL();
          await FirebaseFirestore.instance.collection('users').doc(uId).set({
            'uId': uId,
            'email': _emailTextController.text,
            'password': _passwordTextController.text,
            'name': _nameTextController.text,
            'phone': _phoneTextController.text,
            'position': _posTextController.text,
            'imageUrl': url,
            'createTimedAt': Timestamp.now(),
          });

          flatToast(
            text: 'Sing Up Successfully',
            state: stateToast.SUCCESS,
          );
          navigateFinish(widget: HomeScreen(), context: context);
        } catch (error) {
          showDialogBuilder(
            context: context,
            title: 'Error',
            content: Text(error.toString()),
          );
          setState(() {
            isLoading = false;
          });
          print(error.toString());
        }
      }
    } else {
      throw 'Error';
    }
    setState(() {
      isLoading = false;
    });
  }

  void pickImageWithGallery() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      cropImage(pickedFile!.path);
    } catch (error) {
      print(error.toString());
    }
    Navigator.pop(context);
  }

  void pickImageWithCamera() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      cropImage(pickedFile!.path);

    } catch (error) {
      print(error.toString());
    }
    Navigator.pop(context);
  }

  void cropImage(filePath) async {
    File? cropImageS = await ImageCropper().cropImage(sourcePath: filePath);
    if (cropImageS != null) {
      setState(() {
        imageFile = cropImageS;
      });
    }
  }
}
