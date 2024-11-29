import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinemader/feature/home/model/movie_model.dart';
import 'package:cinemader/core/utils/date_time_extension.dart';
import 'package:cinemader/feature/home/presentation/profile_screen.dart';
import 'package:cinemader/feature/movie_booking/presentation/widget/date_widget.dart';
import 'package:cinemader/feature/movie_booking/presentation/widget/seat_widget.dart';
import 'package:cinemader/feature/movie_booking/presentation/widget/time_widget.dart';

class MovieBookingScreen extends StatefulWidget {
  final Movie movie;
  const MovieBookingScreen({super.key, required this.movie});

  @override
  State<MovieBookingScreen> createState() => _MovieBookingScreenState();
}

class _MovieBookingScreenState extends State<MovieBookingScreen> {
  final selectedSeat = ValueNotifier<List<String>>([]);
  final selectedDate = ValueNotifier<DateTime>(DateTime.now());
  final selectedTime = ValueNotifier<TimeOfDay?>(null);
  final selectedRound = ValueNotifier<String?>(null);
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          return Center(
            child: SpinKitCubeGrid(
              color: AppColor.backgroundGray,
              size: 50.0,
            ),
          );
        },
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('tickets')
                .where('round_id', isEqualTo: selectedRound.value)
                .get(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Text('Error: ${snapshot.error}'); // Handle errors
                }

                QuerySnapshot querySnapshot = snapshot.data!;
                List<DocumentSnapshot> documents = querySnapshot.docs;
                List<String> seat_reserved = [];
                // Process the documents where 'onShowing' is true
                for (var doc in documents) {
                  Map<String, dynamic> ticket =
                      doc.data()! as Map<String, dynamic>;
                  seat_reserved.add(ticket['seat_no'].toString());
                }

                print(seat_reserved);
                return Scaffold(
                  appBar: AppBar(
                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                      ),
                    ),
                    centerTitle: true,
                    title: Text(
                      "Select Seat",
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
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 24),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  color: AppColor.primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Screen: ${widget.movie.title}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: AppColor.white),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),

                                /// lets make 8 seat horizontal
                                /// and 6 seat vertical
                                for (int i = 1; i <= 6; i++) ...[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int j = 1; j <= 8; j++) ...[
                                        SeatWidget(
                                          seatNumber:
                                              "${String.fromCharCode(i + 64)}$j",
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  48 -
                                                  66) /
                                              8,
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  48 -
                                                  66) /
                                              8,
                                          isAvailable: (!(seat_reserved).contains(
                                              "${String.fromCharCode(i + 64)}$j")),
                                          isSelected: value.contains(
                                            "${String.fromCharCode(i + 64)}$j",
                                          ),
                                          onTap: () {
                                            if (value.contains(
                                              "${String.fromCharCode(i + 64)}$j",
                                            )) {
                                              selectedSeat.value =
                                                  List.from(value)
                                                    ..remove(
                                                      "${String.fromCharCode(i + 64)}$j",
                                                    );
                                            } else {
                                              selectedSeat.value =
                                                  List.from(value)
                                                    ..add(
                                                      "${String.fromCharCode(i + 64)}$j",
                                                    );
                                              print(selectedSeat.value);
                                            }
                                          },
                                        ),
                                        // make gap, and in the center wider gap
                                        if (i != 8)
                                          SizedBox(width: j == 4 ? 16 : 4)
                                      ]
                                    ],
                                  ),
                                  if (i != 6) const SizedBox(height: 6)
                                ],
                                const Expanded(child: SizedBox()),
                                const SeatInfoWidget(),
                                const SizedBox(height: 24),
                              ],
                            ),
                          );
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
                                              setState(() {});
                                              // print(date);
                                            },
                                            child: DateWidget(
                                              date: date,
                                              isSelected: value.simpleDate ==
                                                  date.simpleDate,
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
                                  final startMillis =
                                      selectedDate.value.millisecondsSinceEpoch;
                                  final endMillis = startMillis +
                                      Duration(days: 1).inMilliseconds;
                                  DateTime tomorrow = selectedDate.value
                                      .add(const Duration(days: 1));
                                  DateTime tomorrowMidnight = tomorrow.copyWith(
                                      hour: 0,
                                      minute: 0,
                                      second: 0,
                                      microsecond: 0);
                                  final tomorrowMidnightMills =
                                      tomorrowMidnight.millisecondsSinceEpoch;
                                  print((selectedDate.value).runtimeType);
                                  print(Timestamp.fromDate(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          startMillis)));
                                  return FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('rounds')
                                          .where('movie_id',
                                              isEqualTo: widget.movie.id)
                                          .where(
                                            'time',
                                            isGreaterThanOrEqualTo:
                                                Timestamp.fromDate(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        startMillis)),
                                          )
                                          // .where(
                                          //   'time',
                                          //   isLessThan: Timestamp.fromDate(
                                          //       DateTime
                                          //           .fromMillisecondsSinceEpoch(
                                          //               tomorrowMidnightMills)),
                                          // )
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
                                          List rounds = [];
                                          List round_id = [];
                                          // Process the documents where 'onShowing' is true
                                          for (var doc in documents) {
                                            Map<String, dynamic> round =
                                                doc.data()!
                                                    as Map<String, dynamic>;
                                            rounds.add(round);
                                            round_id.add(doc.id);
                                          }
                                          print(rounds);
                                          return SizedBox(
                                            height: 48,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: List.generate(
                                                rounds.length,
                                                (index) {
                                                  // print(timestampToTimeOfDay(
                                                  //             rounds[index]['time'])
                                                  final time =
                                                      timestampToTimeOfDay(
                                                          rounds[index]
                                                              ['time']);

                                                  // final time = TimeOfDay(
                                                  //   hour: 10 + (index * 2),
                                                  //   minute: 0,
                                                  // );
                                                  return InkWell(
                                                    onTap: () {
                                                      print(seat_reserved);
                                                      selectedTime.value = time;
                                                      selectedRound.value =
                                                          round_id[index];
                                                      setState(() {});
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
                                        }
                                        return Text('loading');
                                      }));
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Price",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        const SizedBox(height: 16),
                                        ValueListenableBuilder<List<String>>(
                                          valueListenable: selectedSeat,
                                          builder: (context, value, _) {
                                            return Text(
                                              "${value.length * 80} ฿",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32))),
                                        shadowColor: AppColor.white,
                                      ),
                                      onPressed: () async {
                                        context.loaderOverlay.show();
                                        String errorMessage;
                                        errorMessage = (selectedSeat
                                                    .value.isNotEmpty |
                                                (selectedTime.value
                                                        .toString() !=
                                                    'null'))
                                            ? (selectedSeat.value.isNotEmpty
                                                ? ((selectedTime.value
                                                            .toString() !=
                                                        'null')
                                                    ? 'null'
                                                    : 'Please select round.')
                                                : 'Please select seat.')
                                            : 'Please select seat and round.';
                                        print(errorMessage);
                                        if (errorMessage == 'null') {
                                          final String userid = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          print('buying');

                                          await FirebaseFirestore.instance
                                              .collection('rounds')
                                              .doc(selectedRound.value)
                                              .get()
                                              .then((DocumentSnapshot
                                                  documentSnapshot) async {
                                            if (documentSnapshot.exists) {
                                              int price = documentSnapshot
                                                  .get(FieldPath(['price']));
                                              for (var seat
                                                  in selectedSeat.value) {
                                                await FirebaseFirestore.instance
                                                    .collection('tickets')
                                                    .doc(
                                                        "${seat}_${selectedRound.value}")
                                                    .set({
                                                  "check_in_status": false,
                                                  "round_id":
                                                      selectedRound.value,
                                                  "seat_no": seat,
                                                  "customer_id": userid
                                                }).then((value) {
                                                  FirebaseFirestore.instance
                                                      .collection('customers')
                                                      .doc(userid)
                                                      .get()
                                                      .then((DocumentSnapshot
                                                          documentSnapshot) async {
                                                    if (documentSnapshot
                                                        .exists) {
                                                      int pocket_money =
                                                          documentSnapshot.get(
                                                              FieldPath([
                                                        'pocket_money'
                                                      ]));
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "customers")
                                                          .doc(userid)
                                                          .update({
                                                        "pocket_money":
                                                            pocket_money - price
                                                      }).then((value) {
                                                        context.loaderOverlay
                                                            .hide();

                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder: (context,
                                                                    animation,
                                                                    secondaryAnimation) =>
                                                                ProfileScreen(),
                                                            transitionsBuilder:
                                                                (context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child) {
                                                              return SlideTransition(
                                                                position: Tween<
                                                                            Offset>(
                                                                        begin: Offset(
                                                                            1.0,
                                                                            0.0),
                                                                        end: Offset(
                                                                            0.0,
                                                                            0.0))
                                                                    .animate(
                                                                        animation),
                                                                child: child,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      });
                                                    }
                                                  });
                                                });
                                              }
                                            }
                                          });
                                        } else {
                                          context.loaderOverlay.hide();
                                          Fluttertoast.showToast(
                                              msg: errorMessage,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      },
                                      child: Text(
                                        "Book Now",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                  ),
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
              return Scaffold(
                  body: Center(
                      child: SpinKitCubeGrid(
                          color: AppColor.backgroundGray, size: 50.0)));
            })));
  }
}

TimeOfDay timestampToTimeOfDay(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}
