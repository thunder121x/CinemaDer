import 'dart:io';
import 'dart:developer';
import 'package:cinemader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:cinemader/core/route/app_route.dart';
import 'package:cinemader/core/theme/app_theme.dart';
import 'package:cinemader/readdata/getusername.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cinemader/core/route/app_route_name.dart';
import 'package:cinemader/feature/usher/profile_usher_screen.dart';
import 'package:cinemader/feature/home/presentation/widget/section_title_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/now_playing_movie_widget.dart';
// import 'package:cinemader/feature/home/presentation/profile_screen.dart';

class HomeUsherScreen extends StatelessWidget {
  const HomeUsherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    // return QRViewExample();
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          QRViewExample(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation),
                          child: child,
                        );
                      },
                    ));
              },
              foregroundColor: AppColor.backgroundBlack,
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const Icon(Icons.qr_code_scanner_rounded),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Are you ready, ",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            getFullName(
                              documentId: userid,
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              // textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        MaterialButton(
                            onPressed: () => Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ProfileUsherScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                                begin: Offset(1.0, 0.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                ),
                            child: GetUserImage(
                                documentId: userid,
                                cirRadius: 20,
                                sideLenght: 50)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Check it up here!",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SectionTitleWidget(title: "Now Playing"),
                  ),
                  const SizedBox(height: 16),
                  const NowPlayingMovieWidget(
                    role: 1,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: AppColor.backgroundBlack,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MainUsher(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                        .animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Scanner Ticket",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    TextUtil(
                      text: 'Scaning Ticket QR',
                      color: Theme.of(context).indicatorColor,
                      size: 24,
                      weight: true,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        // height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),

                            // borderRadius: BorderRadius.circular(10),
                            // border: Border.all(),
                            color: AppColor.primaryColor),
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 20),
                        child: MaterialButton(
                          onPressed: () async {
                            if (result != null)
                              print(
                                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}');
                            // print(describeEnum(snapshot.data!));
                            await FirebaseFirestore.instance
                                .collection('tickets')
                                .doc(result!.code)
                                .get()
                                .then(
                                    (DocumentSnapshot documentSnapshot) async {
                              if (documentSnapshot.exists) {
                                bool check_in_status = documentSnapshot
                                    .get(FieldPath(['check_in_status']));
                                // String customer_id =
                                if (!check_in_status) {
                                  await FirebaseFirestore.instance
                                      .collection('tickets')
                                      .doc(result!.code)
                                      .set({
                                    "check_in_status": true,
                                    'customer_id': documentSnapshot
                                    .get(FieldPath(['customer_id'])),
                                    'round_id': documentSnapshot
                                    .get(FieldPath(['round_id'])),
                                    'seat_no': documentSnapshot
                                    .get(FieldPath(['seat_no'])),
                                  })
                                  .then((value) {
                                    // context.loaderOverlay.hide();

                                    Fluttertoast.showToast(
                                        msg:
                                            'Checked-in!',
                                        gravity: ToastGravity.CENTER);
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            DetailScreen(
                                                documentId:
                                                    result!.code.toString()),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                                    begin: Offset(1.0, 0.0),
                                                    end: Offset(0.0, 0.0))
                                                .animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'The ticket are already checked-in.',
                                      gravity: ToastGravity.CENTER);
                                }
                              }
                            });
                          },
                          child: TextUtil(
                            text: 'Sending',
                            color: Theme.of(context).dialogBackgroundColor,
                            size: 24,
                            weight: false,
                          ),
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         await controller?.flipCamera();
                      //         setState(() {});
                      //       },
                      //       child: FutureBuilder(
                      //         future: controller?.getCameraInfo(),
                      //         builder: (context, snapshot) {
                      //           if (snapshot.data != null) {
                      //             return Text(
                      //                 'Camera facing ${describeEnum(snapshot.data!)}');
                      //           } else {
                      //             return const Text('loading');
                      //           }
                      //         },
                      //       )),
                      // )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),

                            // borderRadius: BorderRadius.circular(10),
                            // border: Border.all(),
                            color: AppColor.backgroundGray),
                        margin: const EdgeInsets.only(right: 1),
                        child: MaterialButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: TextUtil(
                            text: 'pause',
                            color: Theme.of(context).dialogBackgroundColor,
                            size: 20,
                            weight: false,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            // border: Border.all(),
                            color: AppColor.backgroundGray),
                        margin: const EdgeInsets.only(left: 1),
                        child: MaterialButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: TextUtil(
                            text: 'resume',
                            color: Theme.of(context).dialogBackgroundColor,
                            size: 20,
                            weight: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
                                                    onTap: () =>Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        HomeUsherScreen(),
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
                                  ),),
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
                                                  //           ShowUpAnimation(
                                                  //             delay: 300,
                                                  //             child: Column(
                                                  //               children: [
                                                  //                 Center(
                                                  //                     child:
                                                  //                         TextUtil(
                                                  //                   text:
                                                  //                       "Ticket Passed",
                                                  //                   color: Theme.of(
                                                  //                           context)
                                                  //                       .primaryColor,
                                                  //                   weight:
                                                  //                       true,
                                                  //                 )),
                                                  //                 Center(
                                                  //                   child:
                                                                        
                                                  // Container(
                                                  //   height: 50,
                                                  //   width: 50,
                                                  //   decoration: BoxDecoration(
                                                  //       borderRadius: BorderRadius.circular(10),
                                                  //       image: const DecorationImage(
                                                  //         image:
                                                  //             AssetImage("assets/app logo.png"),
                                                  //       )),
                                                  // ),
                                                  //                 ),
                                                  //                 SizedBox(
                                                  //                   height: 30,
                                                  //                 )
                                                  //               ],
                                                  //             ),
                                                  //           ),
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
