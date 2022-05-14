import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_os_app/shared/component.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _Auth = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _Auth,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
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
            ),
          );
        }
        else if (snapShot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.deepOrange.shade50,
              body: Center(
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
              ),
            ),
          );
        }
        else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Work',
            home: statsOfUser(),
          );
        }
      },
    );
  }
}
