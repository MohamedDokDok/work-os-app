import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:work_os_app/modules/forget_password/forget_password_screen.dart';
import 'package:work_os_app/modules/home/home_screen.dart';
import 'package:work_os_app/modules/singup/singup_screen.dart';
import 'package:work_os_app/shared/component.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {


  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool isObscure = true;
  final imgUrl = 'https://image.freepik.com/free-vector/tiny-people-doing-priorities-checklist-flat-illustration_74855-16294.jpg';
  final FocusNode _emailFCN = FocusNode();
  final FocusNode _passwordFCN = FocusNode();



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
    _passwordTextController.dispose();
    _emailFCN.dispose();
    _passwordFCN.dispose();
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
                  height: 150.0,
                ),
                const Text(
                  'LOGIN',
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
                        text: 'Don\'t have an account?',
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
                            navigateTo(
                                widget: SingUpScreen(), context: context);
                          },
                        text: 'SINGUP',
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
                  height: 40.0,
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      defaultTextFormFiled(
                        focusNode: _emailFCN,
                        action: TextInputAction.next,
                        onEditingComplete: () =>  FocusScope.of(context)
                            .requestFocus(_passwordFCN),
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
                        focusNode: _passwordFCN,
                        onEditingComplete: () {
                          singIn();
                        },
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: TextButton(
                    onPressed: () {
                      navigateTo(
                          widget: ForgetPasswordScreen(), context: context);
                    },
                    child: Text(
                      'Forget PassWord?',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100.0,
                ),
                !isLoading ? defaultButton(
                  onPress: (){
                    singIn();
                  },
                  text: 'Login',
                  icon: Icons.login,
                ) :const Center(child: CircularProgressIndicator(),),
              ],
            ),
          ),
        ],
      ),
    );
  }


  bool isLoading = false;

  void singIn() async{
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid){
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text.toLowerCase().trim(),
          password: _passwordTextController.text.toLowerCase().trim(),
        );
        flatToast(
          text: 'Sing In Successfully', state: stateToast.SUCCESS,);
        navigateFinish(widget: HomeScreen(), context: context);
      }
      catch(error){
        flatToast(
          text: error.toString(), state: stateToast.ERROR,);
        setState(() {
          isLoading = false;
        });
        throw error.toString();
      }
    }
    else{
      throw 'Error';
    }
    setState(() {
      isLoading = false;
    });

  }




}
