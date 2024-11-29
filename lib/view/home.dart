import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinemader/view/test.dart';
import 'package:cinemader/lobby/signin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cinemader/view/page_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cinemader/view/worker_details.dart';
import 'package:cinemader/core/route/app_route.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:cinemader/readdata/getusername.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cinemader/core/route/app_route_name.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:cinemader/feature/usher/profile_usher_screen.dart';
import 'package:cinemader/feature/home/presentation/widget/section_title_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/now_playing_movie_widget.dart';

// import 'package:hr_management_app/view/worker_details.dart';
// lib/view/test.dart
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  final FirestoreService _firestoreService = FirestoreService();
  late List join = [];
  late int ticketCount = 0;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    join = await _firestoreService.fetchJoinedData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('managers').doc(userid).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> manager =
                snapshot.data!.data() as Map<String, dynamic>;
            ticketCount = join.where((ticket_id) {
              var round = ticket_id['round'];
              var room = round['room'];
              var cinema = room['cinema'];
              return cinema['cinema_id'] ==
                  manager[
                      'cinema_id']; // assuming cinema_id is stored as a string
            }).length;
            int totalPrice = join.where((ticket) {
              var round = ticket['round'];
              var room = round['room'];
              var cinema = room['cinema'];
              return cinema['cinema_id'] ==
                  manager[
                      'cinema_id']; // assuming cinema_id is stored as a string
            }).fold(
                0,
                (sum, ticket) =>
                    sum + (ticket['round']['price'] as int)); // summing the price
            
            return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('ushers')
                    .where('cinema_id', isEqualTo: manager['cinema_id'])
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Text('Error: ${snapshot.error}'); // Handle errors
                    }

                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<DocumentSnapshot> documents = querySnapshot.docs;
                    List ushers = [];
                    List ushersId = [];
                    // Process the documents where 'onShowing' is true
                    for (var doc in documents) {
                      ushers.add(doc.data()! as Map<String, dynamic>);
                      ushersId.add(doc.id);
                    }

                    print(ushers);
                    return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('cinemas')
                            .doc(manager['cinema_id'])
                            .get(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> cinema =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Scaffold(
                              backgroundColor: AppColor.white,
                              body: SafeArea(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Today",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Hello Manger, ",
                                                      style: TextStyle(
                                                        color: Colors.black38,
                                                      ),
                                                    ),
                                                    getFullName(
                                                      documentId: userid,
                                                      textStyle: TextStyle(
                                                        color: Colors.black38,
                                                      ),
                                                      // textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            MaterialButton(
                                                onPressed: () =>
                                                    Navigator.pushReplacement(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) =>
                                                            ProfileManagerScreen(),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          return SlideTransition(
                                                            position: Tween<
                                                                        Offset>(
                                                                    begin:
                                                                        Offset(
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
                                                    ),
                                                child: GetUserImage(
                                                    documentId: userid,
                                                    cirRadius: 20,
                                                    sideLenght: 50))
                                            // Container(
                                            //   height: 50,
                                            //   width: 50,
                                            //   decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(15),
                                            //       color: Colors.blueAccent,
                                            //       image: const DecorationImage(
                                            //           image: AssetImage("assets/user1.jpg"),
                                            //           fit: BoxFit.cover)),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              enabled: false,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon: const Icon(
                                                Feather.search,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          "Cinema",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print(join);
                                          print(ticketCount);
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          width: double.infinity,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: AppColor.backgroundGray,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Center(
                                            child: ListTile(
                                              leading: Container(
                                                // padding: EdgeInsets.all(10),
                                                height: 45,
                                                width: 30,
                                                child: Icon(
                                                  Icons.people_outline_rounded,
                                                ),
                                              ),
                                              title: Text(
                                                'Customer',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: ((join.length != 0)
                                                  ? Text(
                                                      'Total Tickets all time: ${ticketCount}')
                                                  : Text(
                                                      'Click to see analytic')),
                                              // Text('Total Tickets all time', style: const TextStyle(color: Colors.black54)),
                                              trailing: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColor.backgroundBlack,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Center(
                                                      child: Icon(
                                                    FontAwesome5Regular.eye,
                                                    size: 20,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print(join);
                                          print(ticketCount);
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          width: double.infinity,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: AppColor.backgroundGray,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Center(
                                            child: ListTile(
                                              leading: Container(
                                                // padding: EdgeInsets.all(10),
                                                height: 45,
                                                width: 30,
                                                child: Icon(
                                                  Icons.attach_money_rounded,
                                                ),
                                              ),
                                              title: Text(
                                                'Price',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: ((join.length != 0)
                                                  ? Text(
                                                      'Total Prices all time: ${totalPrice}')
                                                  : Text(
                                                      'Click to see analytic')),
                                              // Text('Total Tickets all time', style: const TextStyle(color: Colors.black54)),
                                              trailing: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColor.backgroundBlack,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Center(
                                                      child: Icon(
                                                    FontAwesome5Regular.eye,
                                                    size: 20,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print(join);
                                          print(ticketCount);
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          width: double.infinity,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: AppColor.backgroundGray,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Center(
                                            child: ListTile(
                                              leading: Container(
                                                // padding: EdgeInsets.all(10),
                                                height: 45,
                                                width: 30,
                                                child: Icon(
                                                  Icons.show_chart_rounded,
                                                ),
                                              ),
                                              title: Text(
                                                'Popular movie',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: ((join.length != 0)
                                                  ? Text(
                                                      'Popular movie all time: haikyuu')
                                                  : Text(
                                                      'Click to see analytic')),
                                              // Text('Total Tickets all time', style: const TextStyle(color: Colors.black54)),
                                              trailing: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColor.backgroundBlack,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Center(
                                                      child: Icon(
                                                    FontAwesome5Regular.eye,
                                                    size: 20,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 120,
                                      //   child: ListView(
                                      //     scrollDirection: Axis.horizontal,
                                      //     children: [
                                      //       const SizedBox(
                                      //         width: 20,
                                      //       ),
                                      //       departmentCard("Development", 88, "techies",
                                      //           Colors.blueAccent, "👨‍💻"),
                                      //       departmentCard("UI/UX design", 45, "creatives",
                                      //           Colors.orangeAccent, "👨‍🎨"),
                                      //       departmentCard("QA engineers", 24, "helpers",
                                      //           Colors.redAccent, "🙅‍♂️"),
                                      //     ],
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          "You recenty worked with",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          itemCount: ushers.length,
                                          itemBuilder: (context, index) {
                                            return FutureBuilder<
                                                    DocumentSnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(ushersId[index])
                                                    .get(),
                                                builder: ((context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    Map<String, dynamic> user =
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>;
                                                    return userYouWorkedWith(
                                                        "${user['name']} ${user['surname']}",
                                                        user['imageUrl'],
                                                        Colors.blueAccent,
                                                        "Usher",
                                                        ushers[index],
                                                        ushersId[index]);
                                                  }
                                                  return Scaffold(
                                                    // backgroundColor:
                                                    //     AppColor.primaryColor,
                                                    body: Center(
                                                        child: SpinKitCubeGrid(
                                                            color:
                                                                AppColor.backgroundGray,
                                                            size: 50.0)),
                                                  );
                                                }));
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Scaffold(
                            // backgroundColor: AppColor.primaryColor,
                            body: Center(
                                child: SpinKitCubeGrid(
                                    color: AppColor.backgroundGray, size: 50.0)),
                          );
                        }));
                  }
                  return Scaffold(
                    // backgroundColor: AppColor.primaryColor,
                    body: Center(
                        child:
                            SpinKitCubeGrid(color: AppColor.backgroundGray, size: 50.0)),
                  );
                }));
          }
          return Scaffold(
            // backgroundColor: AppColor.primaryColor,
            body: Center(
                child: SpinKitCubeGrid(color: AppColor.backgroundGray, size: 50.0)),
          );
        }));
  }

  Widget departmentCard(
      String name, int number, String title, Color color, String emoji) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 18),
                )),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                number.toString() + " " + title,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userYouWorkedWith(String name, String image, Color color,
      String jobTitle, Map<String, dynamic> usher, String usherId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          String _job;
          if (color == Colors.blueAccent) {
            _job = "Usher";
          } else if (color == Colors.redAccent) {
            _job = "Usher";
          } else {
            _job = "Usher";
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerDetailsPage(
                name: name,
                image: image,
                color: color,
                jobTitle: jobTitle,
                job: _job,
                usher: usher,
                usherId: usherId,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: ListTile(
              leading: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueAccent,
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover)),
              ),
              title: Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text(jobTitle, style: const TextStyle(color: Colors.black54)),
              trailing: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(
                      child: Icon(
                    FontAwesome5Regular.eye,
                    size: 20,
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileManagerScreen extends StatelessWidget {
  const ProfileManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('managers').doc(userid).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> usher =
                snapshot.data!.data() as Map<String, dynamic>;
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
                                              PageViewer(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                              // shadowColor: Colors.transparent,
                              // color: Colors.transparent,
                              child: IconButton(
                                  iconSize: 35,
                                  icon: Icon(
                                    Icons.logout_outlined,
                                    color: AppColor.primarySwatch,
                                  ),
                                  onPressed: () => FirebaseAuth.instance
                                          .signOut()
                                          .then((value) {
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                Signin(),
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
                                      })),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GetUserImage(
                        documentId: userid, cirRadius: 100, sideLenght: 240),
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
                                  textStyle: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                Text(" ", style: TextStyle(fontSize: 25)),
                                GetUserData(
                                  documentId: userid,
                                  field: "surname",
                                  textStyle: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
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
                            Text("Salary: ${usher['salary']} Baht",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 15,
                            ),
                            Row(children: [
                              Text("Employee ID: ",
                                  style: TextStyle(fontSize: 20)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: new GestureDetector(
                                    child: new Icon(
                                      Icons.copy,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      Clipboard.setData(
                                              new ClipboardData(text: userid))
                                          .then((value) =>
                                              Fluttertoast.showToast(
                                                  msg: "Copied",
                                                  gravity:
                                                      ToastGravity.CENTER));
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
                              GetUserData(
                                  documentId: userid,
                                  field: 'email',
                                  textStyle: TextStyle(fontSize: 18),
                                  maxLines: 1),
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

class Movie extends StatefulWidget {
  const Movie({super.key});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushReplacement(
          //     context,
          //     PageRouteBuilder(
          //       pageBuilder: (context, animation, secondaryAnimation) =>
          //           QRViewExample(),
          //       transitionsBuilder:
          //           (context, animation, secondaryAnimation, child) {
          //         return SlideTransition(
          //           position: Tween<Offset>(
          //                   begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
          //               .animate(animation),
          //           child: child,
          //         );
          //       },
          //     ));
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Hello Manger, ",
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          ),
                          getFullName(
                            documentId: userid,
                            textStyle: TextStyle(
                              color: Colors.black38,
                            ),
                            // textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  MaterialButton(
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ProfileManagerScreen(),
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
                          documentId: userid, cirRadius: 20, sideLenght: 50))
                  // Container(
                  //   height: 50,
                  //   width: 50,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       color: Colors.blueAccent,
                  //       image: const DecorationImage(
                  //           image: AssetImage("assets/user1.jpg"),
                  //           fit: BoxFit.cover)),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    enabled: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Feather.search,
                      color: Colors.black,
                      size: 30,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SectionTitleWidget(title: "Now Playing"),
            ),
            const SizedBox(height: 16),
            const NowPlayingMovieWidget(
              role: 2,
            ),
          ],
        ),
      ),
    );
  }
}