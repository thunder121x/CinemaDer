import 'package:flutter/material.dart';
import 'package:cinemader/lobby/signin.dart';
import 'package:cinemader/decisiontree.dart';
import 'package:cinemader/view/page_viewer.dart';
import 'package:cinemader/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:cinemader/core/route/app_route.dart';
import 'package:cinemader/core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cinemader/core/route/app_route_name.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: DecisionTree(),
    );
  }
}


class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userid).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
              if(data['role'] == 0){
            print('customer');
                return MainUser();
              }
              else if(data['role'] == 1){
            print('usher');
                // return MainUsher();
                return MainUsher();
                // return Text('data')
              }
              else if(data['role'] == 2){
            print('manager');
                return PageViewer();
              } 
              else if (data['role'] == 3) {
                
                return PageViewer();
          }
        }
        // return Scaffold(
        //   backgroundColor: AppColor.backgroundBlack,
        //   body: Center(
        //   child: SpinKitCubeGrid(
        //               color: AppColor.backgroundGray,
        //               size: 50.0,
        //             ),
        // ),);
        return 
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    child: Material(
                      shadowColor: Colors.transparent,
                      color: Colors.transparent,
                      child: IconButton(
                          iconSize: 35,
                          icon: Icon(
                            Icons.logout_outlined,
                            color: AppColor.primarySwatch,
                          ),
                          onPressed: () =>
                              FirebaseAuth.instance.signOut().then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        Signin(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                                begin: Offset(0.0, 1.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              })),
                    ),
                  );
                  
      }),
    );
  }
}

class MainUser extends StatefulWidget {
  const MainUser({super.key});

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CineMaDer",

      /// by using this setting, UI will automatic support dark and light mode
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      initialRoute: AppRouteName.home,
      onGenerateRoute: AppRoute.generate,
    );
  }
}



class MainUsher extends StatefulWidget {
  const MainUsher({super.key});

  @override
  State<MainUsher> createState() => _MainUsherState();
}

class _MainUsherState extends State<MainUsher> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CineMaDer",

      /// by using this setting, UI will automatic support dark and light mode
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      initialRoute: AppRouteName.homeUsher,
      onGenerateRoute: AppRoute.generate,
    );
  }
}
