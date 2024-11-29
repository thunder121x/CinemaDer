import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cinemader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cinemader/lobby/signin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:cinemader/readdata/getusername.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinemader/feature/home/presentation/widget/section_title_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/now_playing_movie_widget.dart';
// import 'package:intl/intl.format.dart';

String formatTimestamp(Timestamp timestamp) {
  final formatter =
      DateFormat('MMMM d \'at\' hh:mm a'); // Customize format as needed
  return formatter.format(timestamp.toDate());
}

String formatDateTimestamp(Timestamp timestamp) {
  final formatter = DateFormat('MMMM d, yyyy'); // Customize format as needed
  return formatter.format(timestamp.toDate());
}

String formatTimeTimestamp(Timestamp timestamp) {
  final formatter = DateFormat('hh:mm a'); // Customize format as needed
  return formatter.format(timestamp.toDate());
}

class ProfileUsherScreen extends StatelessWidget {
  const ProfileUsherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    return        FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('ushers').doc(userid).get(),
      builder: ((context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        Map<String,dynamic> usher = snapshot.data!.data() as Map<String, dynamic>;
        return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    child: Material(
                      shadowColor: Colors.transparent,
                      color: Colors.transparent,
                      child: IconButton(
                          iconSize: 35,
                          icon: Icon(
                            Icons.keyboard_double_arrow_left_rounded,
                            color: AppColor.primarySwatch,
                          ),
                          onPressed: () => Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      MainUsher(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(-1.0, 0.0),
                                              end: Offset(0.0, 0.0))
                                          .animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              )),
                    ),
                  ),
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            GetUserImage(documentId: userid, cirRadius: 100, sideLenght: 240),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetUserData(
                      documentId: userid,
                      field: "name",
                      textStyle:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                    Text(" ", style: TextStyle(fontSize: 25)),
                    GetUserData(
                      documentId: userid,
                      field: "surname",
                      textStyle:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                
                        Text("Salary: ${usher['salary']} Baht", style: TextStyle(fontSize: 18)),


                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Text("Employee ID: ", style: TextStyle(fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: new GestureDetector(
                        child: new Icon(
                          Icons.copy,
                          size: 16,
                        ),
                        onTap: () {
                          Clipboard.setData(new ClipboardData(text: userid))
                              .then((value) => Fluttertoast.showToast(
                                  msg: "Copied", gravity: ToastGravity.CENTER));
                        }),
                  ),
                  Expanded(
                      child: AutoSizeText(
                    "${userid}",
                    style: TextStyle(fontSize: 18),
                    minFontSize: 14,
                    maxLines: 1,
                  )),
                ]),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Text("E-mail: ", style: TextStyle(fontSize: 18)),
                  GetUserData(documentId: userid, field: 'email', textStyle: TextStyle(fontSize: 18), maxLines: 1),
                ]),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                                "Signing Date: ${formatDateTimestamp(usher['contract_expiration_date'])}",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                                "Contract Expiration Date: ${formatDateTimestamp(usher['contract_expiration_date'])}",
                                style: TextStyle(fontSize: 18)),
                
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                //   height: 60,
                //   alignment: Alignment.center,
                //   child: TextUtil(
                //     text: "My Tickets",
                //     color: Theme.of(context).primaryColor,
                //     weight: true,
                //     size: 28,
                //   ),
                // ),

                // ticket
                // Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     decoration: BoxDecoration(
                //         color: Theme.of(context).primaryColor,
                //         borderRadius: const BorderRadius.vertical(
                //             top: Radius.circular(30),
                //             bottom: Radius.circular(30))),
                //     alignment: Alignment.topCenter,
                //     child: Padding(
                //         padding: const EdgeInsets.only(top: 0),
                //         child: MyTickets())),
                // )
              ]),
            ),
            MaterialButton(onPressed: () {
              FirebaseAuth.instance.signOut().then(
                (value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Signin();
                  }));
                },
              );
            })
          ],
        ),
      ),
    );
          }
          return Scaffold(
              body: Center(
                  child: SpinKitCubeGrid(
                      color: AppColor.backgroundGray, size: 50.0)));
        }));

  }
}
