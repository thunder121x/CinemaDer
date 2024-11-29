import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cinemader/view/page_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cinemader/readdata/getusername.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinemader/feature/home/model/movie_model.dart';
import 'package:cinemader/core/utils/date_time_extension.dart';
import 'package:cinemader/feature/home/presentation/profile_screen.dart';
import 'package:cinemader/feature/movie_booking/presentation/widget/seat_widget.dart';
import 'package:cinemader/feature/movie_booking/presentation/widget/date_widget.dart';
import 'package:cinemader/feature/movie_booking/presentation/widget/time_widget.dart';
// import 'package:cinemader/feature/usher/movie_booking/presentation/widget/seat_widget.dart';


class MovieBookingManagerScreen extends StatefulWidget {
  final Movie movie;
  const MovieBookingManagerScreen({super.key, required this.movie});

  @override
  State<MovieBookingManagerScreen> createState() => _MovieBookingManagerScreenState();
}

class _MovieBookingManagerScreenState extends State<MovieBookingManagerScreen> {
  
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String userid = FirebaseAuth.instance.currentUser!.uid;

  final selectedSeat = ValueNotifier<List<String>>([]);
  final selectedDate = ValueNotifier<DateTime>(DateTime.now());
  final selectedTime = ValueNotifier<TimeOfDay?>(null);
  final selectedRoom = ValueNotifier<String?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PageViewer(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                        .animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_downward_rounded,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Select Room and Round",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<List<String>>(
            valueListenable: selectedSeat,
            builder: (context, value, _) {
              return         FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('managers').doc(userid).get(),
      builder: ((context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        Map<String,dynamic> manager = snapshot.data!.data() as Map<String, dynamic>;
        return
FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('rooms')
                                          .where('cinema_id',
                                              isEqualTo: manager['cinema_id'])
                                          .get(),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            print('Error: ${snapshot.error}');
                                            return Text(
                                                'Error: ${snapshot.error}'); // Handle errors
                                          }

                                          QuerySnapshot querySnapshot =
                                              snapshot.data!;
                                          List<DocumentSnapshot> documents =
                                              querySnapshot.docs;
                                          List rooms = [];
                                          List rooms_id = [];
                                          // Process the documents where 'onShowing' is true
                                          for (var doc in documents) {
                                            Map<String, dynamic> room =
                                                doc.data()!
                                                    as Map<String, dynamic>;
                                            rooms.add(room);
                                            rooms_id.add(doc.id);
                                          }
                                          print(rooms);
                                          return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    const Expanded(child: SizedBox()),
                    Container(
                      height: 400,
                      child: ListView.builder(
                                  itemCount: rooms.length,
                                  itemBuilder: (BuildContext context, int index) => ListTile(
                                    // title: Text('${data['friends'][index]}',style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal,color: Colors.black)),
                                    title: InkWell(
                                            onTap: () {
                                              selectedRoom.value = rooms_id[index];
                                              print("room ${rooms[index]['room_no']} ${selectedRoom.value}");
                                              // Navigator.pushNamed(
                                              //   context,
                                              //   AppRouteName.movieDetail,
                                              //   arguments: widget.movie,
                                              // );
                                            },
                                            child: Container(
                                        // height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppColor.primaryColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("Room NO. ${rooms[index]['room_no']}")
                                          
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                    const Expanded(child: SizedBox()),
                    // const SeatInfoWidget(),
                    const SizedBox(height: 24),
                  ],
                ),
              );
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
            },
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(48),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Date",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ValueListenableBuilder<DateTime>(
                    valueListenable: selectedDate,
                    builder: (context, value, _) {
                      return SizedBox(
                        height: 96,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            14,
                            (index) {
                              final date = DateTime.now().add(
                                Duration(days: index),
                              );
                              return InkWell(
                                onTap: () {
                                  selectedDate.value = date;
                                },
                                child: DateWidget(
                                  date: date,
                                  isSelected:
                                      value.simpleDate == date.simpleDate,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder<TimeOfDay?>(
                    valueListenable: selectedTime,
                    builder: (context, value, _) {
                      return SizedBox(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            8,
                            (index) {
                              final time = TimeOfDay(
                                hour: 10 + (index * 2),
                                minute: 0,
                              );
                              return InkWell(
                                onTap: () {
                                  selectedTime.value = time;
                                },
                                child: TimeWidget(
                                  time: time,
                                  isSelected: value == time,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price / Ticket",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ValueListenableBuilder<List<String>>(
                              valueListenable: selectedSeat,
                              builder: (context, value, _) {
                                return Text(
                                  // "\$${value.length * 10}",
                                  "\$200",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.center,
                            backgroundColor: AppColor.primaryColor,
                            // foregroundColor: Color.fromRGBO(251, 157, 150, 1),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))),
                            shadowColor: AppColor.white,
                          ),
                          onPressed: () async {
                            // // context.loaderOverlay.show();
                            // String errorMessage;
                            // errorMessage = (selectedSeat.value.isNotEmpty |
                            //         (selectedTime.value.toString() != 'null'))
                            //     ? (selectedSeat.value.isNotEmpty
                            //         ? ((selectedTime.value.toString() != 'null')
                            //             ? 'null'
                            //             : 'Please select round.')
                            //         : 'Please select seat.')
                            //     : 'Please select seat and round.';
                            // print(errorMessage);
                            // if (errorMessage == 'null') {
                              final String userid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              // print('buying');

                              await FirebaseFirestore.instance
                                  .collection('managers')
                                  .doc(userid)
                                  .get()
                                  .then((DocumentSnapshot
                                      documentSnapshot) async {
                                if (documentSnapshot.exists) {
                                print(selectedTime);
                                print(selectedDate);
                                DateTime? date = selectedDate.value;
                                TimeOfDay? time = selectedTime.value;

  // Combine date and time
  DateTime dateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time!.hour,
                                    time.minute);

                                Timestamp timestamp =
                                    Timestamp.fromDate(dateTime);
                                    await FirebaseFirestore.instance
                                        .collection('rounds')
                                        .doc("${selectedRoom.value}${time.toString()}")
                                        .set({
                                      "movie_id": widget.movie.id,
                                      "price": 200,
                                      "room_id": selectedRoom.value,
                                      "time": timestamp
                                    }).then((value) {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              DetailScreen(documentId: "${selectedRoom.value}${time.toString()}"),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                                    });

                                  // int price = documentSnapshot
                                  //     .get(FieldPath(['price']));
                                  // for (var seat in selectedSeat.value) {
                                  //   await FirebaseFirestore.instance
                                  //       .collection('tickets')
                                  //       .doc("${seat}_${selectedRound.value}")
                                  //       .set({
                                  //     "check_in_status": false,
                                  //     "round_id": selectedRound.value,
                                  //     "seat_no": seat,
                                  //     "customer_id": userid
                                  //   }).then((value) {
                                  //     FirebaseFirestore.instance
                                  //         .collection('customers')
                                  //         .doc(userid)
                                  //         .get()
                                  //         .then((DocumentSnapshot
                                  //             documentSnapshot) async {
                                  //       if (documentSnapshot.exists) {
                                  //         int pocket_money = documentSnapshot
                                  //             .get(FieldPath(['pocket_money']));
                                  //         await FirebaseFirestore.instance
                                  //             .collection("customers")
                                  //             .doc(userid)
                                  //             .update({
                                  //           "pocket_money": pocket_money - price
                                  //         }).then((value) {
                                  //           context.loaderOverlay.hide();

                                  //           Navigator.pushReplacement(
                                  //             context,
                                  //             PageRouteBuilder(
                                  //               pageBuilder: (context,
                                  //                       animation,
                                  //                       secondaryAnimation) =>
                                  //                   ProfileScreen(),
                                  //               transitionsBuilder: (context,
                                  //                   animation,
                                  //                   secondaryAnimation,
                                  //                   child) {
                                  //                 return SlideTransition(
                                  //                   position: Tween<Offset>(
                                  //                           begin: Offset(
                                  //                               1.0, 0.0),
                                  //                           end: Offset(
                                  //                               0.0, 0.0))
                                  //                       .animate(animation),
                                  //                   child: child,
                                  //                 );
                                  //               },
                                  //             ),
                                  //           );
                                  //         });
                                  //       }
                                  //     });
                                  //   });
                                  // }
                                }
                              });
                            // } else {
                            //   context.loaderOverlay.hide();
                            //   Fluttertoast.showToast(
                            //       msg: errorMessage,
                            //       gravity: ToastGravity.CENTER);
                            // }
                          },
                          child: Text(
                            "Add Round",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class DetailScreen extends StatelessWidget {
  String documentId;

  DetailScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('rounds')
            .doc(documentId)
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> round =
                snapshot.data!.data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('movies')
                    .doc(round['movie_id'].toString())
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> movie =
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
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PageViewer(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                        .animate(animation),
                    child: child,
                  );
                },
              ),
            ),
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
                                                                              color: AppColor.secondaryColor,
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
                                                                              color: AppColor.secondaryColor,
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
                                                                              color: AppColor.secondaryColor,
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
                                                                              color: AppColor.secondaryColor,
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
                                                                              color: AppColor.secondaryColor,
                                                                              text: "TOTAL SEAT",
                                                                              size: 12,
                                                                            ),
                                                                            TextUtil(
                                                                              text: "48",
                                                                              size: 15,
                                                                              weight: true,
                                                                              color: Theme.of(context).primaryColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            TextUtil(
                                                                              color: AppColor.secondaryColor,
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
                                                                        "Added Successful",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    weight:
                                                                        true,
                                                                  )),
                                                                  // Center(
                                                                  //   child:
                                                                  //       QrImageView(
                                                                  //     data:
                                                                  //         documentId,
                                                                  //     version:
                                                                  //         QrVersions
                                                                  //             .auto,
                                                                  //     size:
                                                                  //         200.0,
                                                                  //   ),
                                                                  // ),
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
