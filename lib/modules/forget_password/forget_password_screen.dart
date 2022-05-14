import 'package:flutter/material.dart';
import 'package:work_os_app/shared/component.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _passwordTextController = TextEditingController();
  final _resetPasswordKey = GlobalKey<FormState>();
  bool isObscure = true;
  final imgUrl =
      'https://image.freepik.com/free-vector/global-data-security-personal-data-security-cyber-data-security-online-concept-illustration-internet-security-information-privacy-protection_1150-37333.jpg';
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
    _passwordTextController.dispose();
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
                  height: 60.0,
                ),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _resetPasswordKey,
                  child: defaultTextFormFiled(
                    controller: _passwordTextController,
                    isFill: true,
                    backGroundTextFormFieldColor: Colors.grey[300],
                    border: InputBorder.none,
                    isBorder: false,
                    hint: '',
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
                ),
                const SizedBox(
                  height: 50.0,
                ),
                defaultButton(
                  onPress: () {
                    if (_resetPasswordKey.currentState!.validate()) {
                      print('hhhhhhhhhhhhhhhhhhhhh');
                    } else {
                      print('aaaaaaaaaaaaaaaaaaaaaaaaa');
                    }
                  },
                  text: 'Reset Now',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
