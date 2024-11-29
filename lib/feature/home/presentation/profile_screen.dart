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
import 'package:cinemader/feature/home/presentation/widget/banner_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/category_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/section_title_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/upcoming_movie_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/now_playing_movie_widget.dart';
// import 'package:intl/intl.format.dart';

String formatTimestamp(Timestamp timestamp) {
  final formatter =
      DateFormat('MMMM d \'at\' hh:mm a'); // Customize format as needed
  return formatter.format(timestamp.toDate());
}

String formatDateTimestamp(Timestamp timestamp) {
  final formatter = DateFormat('d MMMM yy'); // Customize format as needed
  return formatter.format(timestamp.toDate());
}

String formatTimeTimestamp(Timestamp timestamp) {
  final formatter = DateFormat('hh:mm a'); // Customize format as needed
  return formatter.format(timestamp.toDate());
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    return 
    FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('tickets')
            .where('customer_id',
                isGreaterThanOrEqualTo: userid)
                                    .get(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      print('Error: ${snapshot.error}');
                                      return Text(
                                          'Error: ${snapshot.error}'); // Handle errors
                                    }
          
                                    QuerySnapshot querySnapshot = snapshot.data!;
                                    List<DocumentSnapshot> documents =
                                        querySnapshot.docs;
                                    List tickets = [''];
                                    // Process the documents where 'onShowing' is true
                                    for (var doc in documents) {
                                      tickets.add(doc.data()! as Map<String, dynamic>);
                                    }
            // List filteredTickets = tickets
            //     .where((ticket) => ticket == false)
            //     .toList();

            // print(filteredTickets);
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
                          onPressed: () =>
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      MainUser(),
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
              child: Column(children: [
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
                Row(
                  children: [
                    Text("E-mail: ", style: TextStyle(fontSize: 20)),
                    GetUserData(
                      documentId: userid,
                      field: "email",
                      textStyle: TextStyle(fontSize: 20),
                      maxLines: 1,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text("Pocket Money: ", style: TextStyle(fontSize: 20)),
                    GetCustomerData(
                      documentId: userid,
                      field: "pocket_money",
                      textStyle: TextStyle(fontSize: 20),
                      maxLines: 1,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text("Ticket all time: ${tickets.length}", style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text("Ticket Expired: 2", style: TextStyle(fontSize: 20)),
                  ],
                ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text("Lose money by Ticket Expired: 220",
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Text("Account ID: ", style: TextStyle(fontSize: 20)),
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
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  height: 60,
                  alignment: Alignment.center,
                  child: TextUtil(
                    text: "My Tickets",
                    color: Theme.of(context).primaryColor,
                    weight: true,
                    size: 28,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                            bottom: Radius.circular(30))),
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: MyTickets())),
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
            backgroundColor: AppColor.primaryColor,
            body: Center(
                child: SpinKitCubeGrid(color: AppColor.white, size: 50.0)),
          );
        }));

  }
}

class MyTickets extends StatelessWidget {
  const MyTickets({super.key});

  @override
  Widget build(BuildContext context) {
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    // FutureOr<DocumentSnapshot<Object?>> datax;
    return 
    FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('rounds')
            .where('time',
                isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
                                    .get(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      print('Error: ${snapshot.error}');
                                      return Text(
                                          'Error: ${snapshot.error}'); // Handle errors
                                    }
          
                                    QuerySnapshot querySnapshot = snapshot.data!;
                                    List<DocumentSnapshot> documents =
                                        querySnapshot.docs;
                                    List rounds_id = [''];
                                    // Process the documents where 'onShowing' is true
                                    for (var doc in documents) {
                                      rounds_id.add(doc.id);
                                    }
                                    print(rounds_id);
        return FutureBuilder<QuerySnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('tickets')
                                        .where('customer_id', isEqualTo: userid)
                                        .where('round_id', whereIn: rounds_id)
                                        .where('check_in_status', isEqualTo: false)
                                        .get(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasError) {
                                          print('Error: ${snapshot.error}');
                                          return Text(
                                              'Error: ${snapshot.error}'); // Handle errors
                                        }
              
                                        QuerySnapshot querySnapshot = snapshot.data!;
                                        List<DocumentSnapshot> documents =
                                            querySnapshot.docs;
                                        List tickets = [];
                                        List tickets_id = [];
                                        // Process the documents where 'onShowing' is true
                                        for (var doc in documents) {
                                          Map<String, dynamic> ticket =
                                              doc.data()! as Map<String, dynamic>;
                                          tickets.add(ticket);
                                          tickets_id.add(doc.id);
                                          print('object');
                                        }
                                        print(tickets_id);
                                        print(userid);
        // FutureBuilder<DocumentSnapshot>(
        //     future: FirebaseFirestore.instance
        //         .collection('customers')
        //         .doc(userid)
        //         .get(),
        //     builder: ((context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.done) {
        //         Map<String, dynamic> data =
        //             snapshot.data!.data() as Map<String, dynamic>;
        //         print(data['tickets_id']);
        
                return
                    ListView.builder(
                        itemCount: tickets_id.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ShowUpAnimation(
                              delay: 150 * index,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                              documentId: tickets_id[index],
                                              // index: index,
                                            )));
                                  },
                                  child: FlightCard(
                                    documentId: tickets_id[index],
                                    // index: index,
                                  )));
                        });
                // }
                // return Text('loading...');
                // })
                // );
              }
        
              return SpinKitCubeGrid(color: AppColor.backgroundGray, size: 50.0);
            }));
      }
              return SpinKitCubeGrid(color: AppColor.backgroundGray, size: 50.0);

                                }
                                )
    );
  }
}

class FlightCard extends StatelessWidget {
  String documentId;

  FlightCard({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('tickets')
            .doc(documentId)
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> ticket =
                snapshot.data!.data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('rounds')
                    .doc(ticket['round_id'].toString())
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> round =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(round['room_id'].toString())
                            .get(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> room =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .canvasColor))),
                                  child: Column(
                                    children: [
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GetCollectionData(
                                                  collect: 'rooms',
                                                  documentId: round['room_id'],
                                                  field: 'room_no',
                                                  size_: 28),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextUtil(
                                                text: 'room',
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                size: 12,
                                                weight: true,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GetCollectionData(
                                                  collect: 'cinemas',
                                                  documentId: room['cinema_id'],
                                                  field: 'name',
                                                  size_: 12),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              GetCollectionData(
                                                  collect: 'tickets',
                                                  documentId: documentId,
                                                  field: 'seat_no',
                                                  size_: 28),
                                              TextUtil(
                                                text: 'seat_no',
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                size: 12,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextUtil(
                                                text: "DATE",
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                size: 12,
                                                weight: true,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextUtil(
                                                text: formatTimestamp(
                                                    round['time']),
                                                color: Colors.white,
                                                size: 13,
                                                weight: true,
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              TextUtil(
                                                text: "MOVIE",
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                size: 12,
                                                weight: true,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GetCollectionData(
                                                  collect: 'movies',
                                                  documentId: round['movie_id'],
                                                  field: 'short_title',
                                                  size_: 12),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width: 60,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: const [
                                            0.5,
                                            0.5
                                          ],
                                          colors: [
                                            Theme.of(context).canvasColor,
                                            Theme.of(context).primaryColor,
                                          ])),
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Column(
                                      children: [
                                        Hero(
                                          tag: "hero",
                                          child: Transform.rotate(
                                              angle: 6,
                                              child: Icon(
                                                Icons.local_movies_sharp,
                                                size: 25,
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        GetCollectionDatamin(
                                            collect: 'movies',
                                            documentId: round['movie_id'],
                                            field: 'duration',
                                            textStyle: TextStyle(
                                                color: AppColor.white),
                                            maxLines: 1),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return SpinKitCubeGrid(
                              color: AppColor.backgroundGray, size: 50.0);
                        }));
                  }
                  return SpinKitCubeGrid(
                      color: AppColor.backgroundGray, size: 50.0);
                }));
          }
          return SpinKitCubeGrid(color: AppColor.backgroundGray, size: 50.0);
        }));
  }
}

class DetailScreen extends StatelessWidget {
  String documentId;

  DetailScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('tickets')
            .doc(documentId)
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> ticket =
                snapshot.data!.data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('rounds')
                    .doc(ticket['round_id'].toString())
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> round =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(round['room_id'].toString())
                            .get(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> room =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('cinemas')
                                    .doc(room['cinema_id'].toString())
                                    .get(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> cinema = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('movies')
                                            .doc(round['movie_id'].toString())
                                            .get(),
                                        builder: ((context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            Map<String, dynamic> movie =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            return Scaffold(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              appBar: AppBar(
                                                elevation: 0,
                                                leading: GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: Icon(
                                                      Icons.arrow_back_outlined,
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                    )),
                                                actions: [
                                                  // Container(
                                                  //   height: 50,
                                                  //   width: 50,
                                                  //   decoration: BoxDecoration(
                                                  //       borderRadius: BorderRadius.circular(10),
                                                  //       image: const DecorationImage(
                                                  //         image:
                                                  //             AssetImage("assets/profile.png"),
                                                  //       )),
                                                  // ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ),
                                              body: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          30),
                                                                  bottom: Radius
                                                                      .circular(
                                                                          20))),
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ShowUpAnimation(
                                                              delay: 200,
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20),
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          // Row(
                                                                          //   crossAxisAlignment:
                                                                          //       CrossAxisAlignment
                                                                          //           .start,
                                                                          //   mainAxisAlignment:
                                                                          //       MainAxisAlignment
                                                                          //           .center,
                                                                          //   children: [
                                                                          Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 30,
                                                                                right: 30,
                                                                                bottom: 20),
                                                                            // height: 80,
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                GetMovieImage(
                                                                              cirRadius: 15,
                                                                              documentId: round['movie_id'],
                                                                              heightLenght: 250.00,
                                                                              widthLenght: 300.00,
                                                                            ),
                                                                          ),
                                                                          TextUtil(
                                                                            text:
                                                                                movie['title'],
                                                                            size:
                                                                                22,
                                                                            weight:
                                                                                true,
                                                                            color:
                                                                                Theme.of(context).primaryColorDark,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      // Transform.rotate(
                                                                      //   angle: 0.3,
                                                                      //   child: SizedBox(
                                                                      //     height: 150,
                                                                      //     width: 200,
                                                                      //     child: Image.asset(
                                                                      //       "assets/world.png",
                                                                      //       color: Theme.of(
                                                                      //               context)
                                                                      //           .primaryColor,
                                                                      //     ),
                                                                      //   ),
                                                                      // ),
                                                                    ),
                                                                    const Divider(),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            TextUtil(
                                                                              text: "DATE",
                                                                              size: 12,
                                                                            ),
                                                                            TextUtil(
                                                                              text: formatDateTimestamp(round['time']),
                                                                              color: Theme.of(context).primaryColor,
                                                                              size: 15,
                                                                              weight: true,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            TextUtil(
                                                                              text: "CINEMA ${room['room_no']}",
                                                                              size: 12,
                                                                            ),
                                                                            TextUtil(
                                                                              text: cinema['name'],
                                                                              size: 15,
                                                                              weight: true,
                                                                              color: Theme.of(context).primaryColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            TextUtil(
                                                                              text: "MOVIE",
                                                                              size: 12,
                                                                            ),
                                                                            TextUtil(
                                                                              text: movie['short_title'],
                                                                              color: Theme.of(context).primaryColor,
                                                                              size: 15,
                                                                              weight: true,
                                                                            )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            TextUtil(
                                                                              text: "OPEN TIME",
                                                                              size: 12,
                                                                            ),
                                                                            TextUtil(
                                                                              text: formatTimeTimestamp(round['time']),
                                                                              color: Theme.of(context).primaryColor,
                                                                              size: 15,
                                                                              weight: true,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            TextUtil(
                                                                              text: "SEAT",
                                                                              size: 12,
                                                                            ),
                                                                            TextUtil(
                                                                              text: ticket['seat_no'],
                                                                              size: 15,
                                                                              weight: true,
                                                                              color: Theme.of(context).primaryColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            TextUtil(
                                                                              text: "PRICE",
                                                                              size: 12,
                                                                            ),
                                                                            TextUtil(
                                                                              text: '${round['price']} ฿',
                                                                              size: 15,
                                                                              weight: true,
                                                                              color: Theme.of(context).primaryColor,
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Stack(
                                                              children: [
                                                                SizedBox(
                                                                  height: 25,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              1,
                                                                          child:
                                                                              Row(
                                                                            children: List.generate(
                                                                                700 ~/ 10,
                                                                                (index) => Expanded(
                                                                                      child: Container(
                                                                                        color: index % 2 == 0 ? Colors.transparent : Theme.of(context).canvasColor,
                                                                                        height: 2,
                                                                                      ),
                                                                                    )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    left: -10,
                                                                    bottom: 0,
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          12,
                                                                      backgroundColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                    )),
                                                                Positioned(
                                                                    right: -10,
                                                                    bottom: 0,
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          12,
                                                                      backgroundColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                    ))
                                                              ],
                                                            ),
                                                            ShowUpAnimation(
                                                              delay: 300,
                                                              child: Column(
                                                                children: [
                                                                  Center(
                                                                      child:
                                                                          TextUtil(
                                                                    text:
                                                                        "Ticket pass",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    weight:
                                                                        true,
                                                                  )),
                                                                  Center(
                                                                    child:
                                                                        QrImageView(
                                                                      data:
                                                                          documentId,
                                                                      version:
                                                                          QrVersions
                                                                              .auto,
                                                                      size:
                                                                          200.0,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return Scaffold(
                                            backgroundColor:
                                                AppColor.primaryColor,
                                            body: Center(
                                                child: SpinKitCubeGrid(
                                                    color: AppColor.white,
                                                    size: 50.0)),
                                          );
                                        }));
                                  }
                                  return Scaffold(
                                    backgroundColor: AppColor.primaryColor,
                                    body: Center(
                                        child: SpinKitCubeGrid(
                                            color: AppColor.white, size: 50.0)),
                                  );
                                }));
                          }
                          return Scaffold(
                            backgroundColor: AppColor.primaryColor,
                            body: Center(
                                child: SpinKitCubeGrid(
                                    color: AppColor.white, size: 50.0)),
                          );
                        }));
                  }
                  return Scaffold(
                    backgroundColor: AppColor.primaryColor,
                    body: Center(
                        child:
                            SpinKitCubeGrid(color: AppColor.white, size: 50.0)),
                  );
                }));
          }
          return Scaffold(
            backgroundColor: AppColor.primaryColor,
            body: Center(
                child: SpinKitCubeGrid(color: AppColor.white, size: 50.0)),
          );
        }));
  }
}
