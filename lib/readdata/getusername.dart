import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cinemader/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// import 'dart:ffi';
// import 'package:cinemader/apppages/eventprofilepage.dart';
// import 'package:cinemader/apppages/friendspage.dart';
// import 'package:cinemader/apppages/homepage.dart';
// import 'package:cinemader/apppages/profilepage.dart';
class GetUserName extends StatelessWidget {
  final String documentId;
  GetUserName({required this.documentId});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['name']}',
            style: TextStyle(fontSize: 17, color: Colors.white),
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}



class getFriendsList extends StatelessWidget {
  final String documentId;
  // final int count;
  getFriendsList({required this.documentId
      // ,required this.count
      });
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListView.builder(
            itemCount: data['friends'].length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              leading: GetUserImage(
                  documentId: "${data['friends'][index]}",
                  cirRadius: 20,
                  sideLenght: 50),
              // title: Text('${data['friends'][index]}',style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal,color: Colors.black)),
              title: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(242, 242, 242, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: getFullName(
                              documentId: data['friends'][index],
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[900])))
                    ],
                  ),
                ),
              ),
            ),
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

// class AddFriendfull extends StatefulWidget {
//   final String documentId;
//   final String friendId;
//   const AddFriendfull({super.key,required this.documentId,required this.friendId});

//   @override
//   State<AddFriendfull> createState() => _AddFriendfullState();
// }

// class _AddFriendfullState extends State<AddFriendfull> {
//   late final String documentId;
//   late final String friendId;
//   @override
//   Widget build(BuildContext context) {
//     //get the collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder: ((context, snapshot) {
//       if(snapshot.connectionState == ConnectionState.done){
//         Map<String,dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//         List<String> friendslist = data['friends'];
//         data['friends'].add(friendId);
//         return Text( data['friends'][data['friends'].length]);

//       }
//       return Text('loading..');
//     }),);
//   }
// }

// class AddFriend extends StatelessWidget {
//   final String documentId;
//   final String friendId;
//   // final formkey = GlobalKey<FormState>();
//   // final int count;
//   AddFriend({required this.documentId,required this.friendId});
//   @override
//   Widget build(BuildContext context) {
//     //get the collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder: ((context, snapshot) {
//       if(snapshot.connectionState == ConnectionState.done){
//         Map<String,dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//         data['friends'].add(friendId);
//         // await
//         FirebaseFirestore.instance.collection("users").doc(documentId).set({
//                                           "friends" : data['friends'],
//                                         })
//                                         .then((value){
//                                           context.loaderOverlay.hide();
//                                         // ignore: avoid_print
//                                         print(data['friends']);
//                                         // formKey.currentState?.reset();
//                                         Fluttertoast.showToast(msg: "Add friend successful");
//                                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
//                                           return MainWidgetXpage(initialPage: Friendspage(),);
//                                         }));
//                                         });
//       }
//       return Text('loading..');
//     }),);
//   }
// }

class GetUserData extends StatelessWidget {
  final String documentId, field;
  final TextStyle textStyle;
  final int maxLines;
  GetUserData(
      {required this.documentId,
      required this.field,
      required this.textStyle,
      required this.maxLines});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text('${data['${field}']}',style: TextStyle(fontSize: 17,color: Colors.white),);
          return AutoSizeText(
            '${data['${field}']}',
            style: textStyle,
            maxLines: maxLines,
            minFontSize: 12,
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

class getFullName extends StatelessWidget {
  final String documentId;
  final TextStyle? textStyle;
  getFullName({required this.documentId, this.textStyle});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text('${data['${field}']}',style: TextStyle(fontSize: 17,color: Colors.white),);
          return AutoSizeText(
            '${data['name']} ${data['surname']}',
            style: textStyle,
            maxLines: 1,
            minFontSize: 8,
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

class GetEventData extends StatelessWidget {
  final String eventId, field;
  final TextStyle textStyle;
  GetEventData(
      {required this.eventId, required this.field, required this.textStyle});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text('${data['${field}']}',style: TextStyle(fontSize: 17,color: Colors.white),);
          return Container(
              alignment: Alignment.centerLeft,
              child: Text('${data['${field}']}',
                  textAlign: TextAlign.left, style: textStyle));
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..', textAlign: TextAlign.left);
      }),
    );
  }
}

class GetUserImage extends StatelessWidget {
  final String documentId;
  final double cirRadius;
  final double sideLenght;
  GetUserImage(
      {required this.documentId,
      required this.cirRadius,
      required this.sideLenght});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text('${data['name']}',style: TextStyle(fontSize: 17,color: Colors.white),);
          // return Image.network("${data['imageUrl']}");
          // return DecorationImage(image: NetworkImage("${data['imageUrl']}"));
          return Container(
            height: sideLenght,
            width: sideLenght,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cirRadius),
                image: DecorationImage(
                    image: NetworkImage("${data['imageUrl']}"),
                    // image: DecorationImage(image: NetworkImage("${uImageUrl}"),
                    fit: BoxFit.cover)),
          );
        }
        return SpinKitCubeGrid(
                          color: AppColor.backgroundGray,
                    size: sideLenght,
                  );
      }),
    );
  }
}



class GetMovieImage extends StatelessWidget {
  final String documentId;
  final double cirRadius;
  final double heightLenght;
  final double widthLenght;
  GetMovieImage(
      {required this.documentId,
      required this.cirRadius,
      required this.heightLenght,
      required this.widthLenght});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference movies = FirebaseFirestore.instance.collection('movies');

    return FutureBuilder<DocumentSnapshot>(
      future: movies.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            height: heightLenght,
            width: widthLenght,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cirRadius),
                image: DecorationImage(
                    image: NetworkImage("${data['imageUrl']}"),
                    fit: BoxFit.cover)),
          );
        }
        return SpinKitCubeGrid(
          color: AppColor.backgroundGray,
          size: widthLenght,
        );
      }),
    );
  }
}

class getEventsList extends StatelessWidget {
  final String documentId;
  // final int count;
  getEventsList({required this.documentId
      // ,required this.count
      });
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListView.builder(
            itemCount: data['events'].length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              title: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(255, 188, 150, 0.4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      GetEventData(
                        eventId: "${data['events'][index]}",
                        field: "name",
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      GetEventData(
                        eventId: "${data['events'][index]}",
                        field: "detail",
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

// class getEventsListPlus extends StatelessWidget {
//   final String documentId;
//   // final int count;
//   getEventsListPlus({required this.documentId
//   // ,required this.count
//   });
//   @override
//   Widget build(BuildContext context) {
//     //get the collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder: ((context, snapshot) {
//       if(snapshot.connectionState == ConnectionState.done){
//         Map<String,dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//         CollectionReference events = FirebaseFirestore.instance.collection('events');

//         return ListView.builder(
//           itemCount: data['events'].length,
//           itemBuilder: (BuildContext context, int index) =>ListTile(
//             title: Builder(
//               builder: (context) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 4.0),
//                   child: Container(
//                     height: 120,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                   gradient: LinearGradient(
//             begin: Alignment.centerRight,
//             end: Alignment.centerLeft,
//             // colors: [Color.fromARGB(255, 15, 13, 11), Color.fromRGBO(247,110,17,1)],
//             colors: [ Color.fromRGBO(255,178,70,1),Color.fromRGBO(254,109,2,0.3),],
//             // colors: [Color.fromRGBO(247,110,17,1), Color.fromRGBO(247,110,17,1)],
//             tileMode: TileMode.repeated,
//           )
//                         // color: Color.fromRGBO(255, 188, 128, 1),
//                         ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         children: [
//                           FutureBuilder<DocumentSnapshot>(
//                             future: events.doc(data['events'][index]).get(),
//                             builder: ((context, snapshottwo) {
//                             if(snapshottwo.connectionState == ConnectionState.done){
//                               Map<String,dynamic> datatwo = snapshottwo.data!.data() as Map<String, dynamic>;
//                               // DateTime dtst = (datatwo['start'] as Timestamp).toDate();
//                               // var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00
//                               return MaterialButton(
//                                 onPressed: () {
//                                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
//                                               return MainWidgetXpage(initialPage:  EventProfilePage(eventid:data['events'][index]));
//                                             }));
//                                           },
//                                 child: Container(alignment: Alignment.centerLeft,child:
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 10.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Text('${datatwo['name']}',textAlign: TextAlign.left ,style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.grey[900])),
//                                           // IconButton(icon: Icon(Icons.info),iconSize: 20,
//                                           // IconButton(icon: Icon(Icons.arrow_forward_ios_rounded),iconSize: 20,
//                                           SizedBox(width: 5,),
//                                           Icon(Icons.arrow_circle_right_rounded, size: 20,),

//                                           // onPressed: () {
//                                           //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
//                                           //     return MainWidgetXpage(initialPage:  EventProfilePage(eventid:data['events'][index]));
//                                           //   }));
//                                           // },
//                                           // ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 5,),
//                                       // Text('${datatwo['detail']}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[500])),
//                                       // Text('Begin at: ${datatwo['start'].toDate()}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[500])),
//                                       // Text('Begin at: ${datatwo['start'].toDate().day}/${datatwo['start'].toDate().month}/${datatwo['start'].toDate().year} ${datatwo['start'].toDate().hour}:${datatwo['start'].toDate().minute}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[500])),
//                                       // Text('End at: ${datatwo['end'].toDate().day}/${datatwo['end'].toDate().month}/${datatwo['end'].toDate().year} ${datatwo['end'].toDate().hour}:${datatwo['end'].toDate().minute}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[500])),
//                                       Text('Begin on ${DateFormat('E dd/MM/yyyy, HH:mm').format(datatwo['start'].toDate())}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[900])),
//                                       Text('End on ${DateFormat('E dd/MM/yyyy, HH:mm').format(datatwo['end'].toDate())}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[900])),

//                                     ],
//                                   ),
//                                 )),
//                               );
//                             }
//                             return Text('loading..',textAlign: TextAlign.left);
//                             })),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             ),
//             ),
//             );
//           // return Image.network("${data['imageUrl']}");
//       }
//       return Text('loading..');
//     }),);
//   }
// }

class getMemberList extends StatelessWidget {
  final String eventid;
  getMemberList({required this.eventid});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventid).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListView.builder(
            itemCount: data['members'].length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              leading: GetUserImage(
                  documentId: "${data['members'][index]}",
                  cirRadius: 20,
                  sideLenght: 50),
              // title: Text('${data['friends'][index]}',style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal,color: Colors.black)),
              title: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      // GetUserImage(documentId: "${data['friends'][index]}", cirRadius: 20, sideLenght: 35),
                      //   Text(" "),
                      Expanded(
                          child: getFullName(
                              documentId: data['members'][index],
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[800])))
                      // Expanded(child: GetUserData(documentId: "${data['members'][index]}",field:"name",textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Colors.black), maxLines: 1,)),
                      // Text(" "),
                      // Expanded(child: GetUserData(documentId: "${data['members'][index]}",field:"surname",textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Colors.black), maxLines: 1,)),
                    ],
                  ),
                ),
              ),
            ),
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

class getFriendsListCheckScrollviewwithoutlist extends StatelessWidget {
  final String documentId;
  // final int count;
  getFriendsListCheckScrollviewwithoutlist({required this.documentId
      // ,required this.count
      });
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          List<Widget> children = [];
          for (var i = 0; i < data['friends'].length; i++) {
            children.add(Row(
              children: [
                GetUserImage(
                    documentId: "${data['friends'][i]}",
                    cirRadius: 20,
                    sideLenght: 50),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(251, 157, 150, 0.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: getFullName(
                                documentId: data['friends'][i],
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[900])))
                      ],
                    ),
                  ),
                ),
              ],
            ));
          }
          return SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: children,
            ),
          ));
        }
        return Text('loading..');
      }),
    );
  }
}

class getFriendsListToAddMember extends StatelessWidget {
  final String documentId;
  final String eventId;
  // final int count;
  getFriendsListToAddMember({required this.documentId, required this.eventId
      // ,required this.count
      });
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          CollectionReference events =
              FirebaseFirestore.instance.collection('events');
          return FutureBuilder<DocumentSnapshot>(
              future: events.doc(eventId).get(),
              builder: ((context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data2 =
                      snapshot2.data!.data() as Map<String, dynamic>;
                  List<bool> isMember = [];
                  List<dynamic> enabletoadd = [];
                  for (var i = 0; i < data['friends'].length; i++) {
                    for (var j = 0; j < data2['members'].length; j++) {
                      if (data2['members'][j] == data['friends'][i]) {
                        isMember.add(true);
                        break;
                      }
                      // print(j+1);
                      // print(data2['members'].length);
                      if (j + 1 == data2['members'].length) {
                        enabletoadd.add(data['friends'][i]);
                        isMember.add(false);
                      }
                    }
                  }
                  print(isMember);
                  print(enabletoadd);
                  List<bool> addMember = [];
                  for (var i = 0; i < enabletoadd.length; i++) {
                    addMember.add(false);
                  }
                  List<String> addMemberId = [];

                  return ListView.builder(
                    itemCount: enabletoadd.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      leading: GetUserImage(
                          documentId: enabletoadd[index],
                          cirRadius: 20,
                          sideLenght: 50),
                      // title: Text('${data['friends'][index]}',style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal,color: Colors.black)),
                      title: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(251, 157, 150, 0.4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              StatefulBuilder(builder: (context, setState) {
                                return Checkbox(
                                    value: addMember[index],
                                    onChanged: (value) {
                                      setState(() =>
                                          addMember[index] = !addMember[index]);
                                    });
                              }),
                              Expanded(
                                  child: getFullName(
                                      documentId: enabletoadd[index],
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[900])))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Text('loading..');
              }));
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

class GetCollectionData extends StatelessWidget {
  final String collect, documentId, field;
  final double size_;
  GetCollectionData(
      {required this.collect,
        required this.documentId,
      required this.field,
      required this.size_});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference col = FirebaseFirestore.instance.collection(collect);

    return FutureBuilder<DocumentSnapshot>(
      future: col.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text('${data['${field}']}',style: TextStyle(fontSize: 17,color: Colors.white),);
          return  TextUtil(
                  text: '${data['${field}']}',
                  // text: data.duration,
                  color: Colors.white,
                  size: size_,
                  weight: true,
              );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

class GetCollectionDatamin extends StatelessWidget {
  final String collect, documentId, field;
  final TextStyle textStyle;
  final int maxLines;
  GetCollectionDatamin(
      {required this.collect,
      required this.documentId,
      required this.field,
      required this.textStyle,
      required this.maxLines});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference col = FirebaseFirestore.instance.collection(collect);

    return FutureBuilder<DocumentSnapshot>(
      future: col.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text('${data['${field}']}',style: TextStyle(fontSize: 17,color: Colors.white),);
          return Expanded(
            child: TextUtil(
              text: '${data['${field}']} min',
              // text: data.duration,
              color: Colors.white,
              size: 11,
              weight: true,
            ),
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

// class getTodayEvent extends StatelessWidget {
//   final String documentId;
//   // final int count;
//   getTodayEvent({required this.documentId
//   // ,required this.count
//   });
//   @override
//   Widget build(BuildContext context) {
//     //get the collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     return Padding(
//       padding: const EdgeInsets.only(top: 32.0),
//       child: SizedBox(
//                                     height: 300,
//                                     width: double.maxFinite,
//         child: FutureBuilder<DocumentSnapshot>(
//           future: users.doc(documentId).get(),
//           builder: ((context, snapshot) {
//           if(snapshot.connectionState == ConnectionState.done){
//             Map<String,dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//             CollectionReference events = FirebaseFirestore.instance.collection('events');

//             return ListView.builder(
//               shrinkWrap: true,
//               // scrollDirection: Axis.horizontal,
//               itemCount: data['events'].length,
//               itemBuilder: (BuildContext context, int index) =>ListTile(
//                 title: Builder(
//                   builder: (context) {
//                     return
//                               Column(
//                                 children: [
//                                   FutureBuilder<DocumentSnapshot>(
//                                     future: events.doc(data['events'][index]).get(),
//                                     builder: ((context, snapshottwo) {
//                                     if(snapshottwo.connectionState == ConnectionState.done){
//                                       Map<String,dynamic> datatwo = snapshottwo.data!.data() as Map<String, dynamic>;
//                                       DateTime dtst = (datatwo['start'] as Timestamp).toDate();
//                                       DateTime dten = (datatwo['end'] as Timestamp).toDate();
//                                       // var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00
//                                       if(DateTime.now().isBefore(dten) && (DateTime.now().isAfter(dtst)||(DateTime.now().day==dtst.day&&DateTime.now().month==dtst.month&&DateTime.now().year==dtst.year))){
//                                       return Align(
//                       alignment: Alignment.topCenter,
//                       child: Container(
//                         height: 150,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25),
//                             color: Color.fromRGBO(252, 252, 252, 1),
//                             ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Container(alignment: Alignment.centerLeft,child:
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: [
//                                                 Text('${datatwo['name']}',textAlign: TextAlign.left ,style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.grey[900])),
//                                                 IconButton(icon: Icon(Icons.info),iconSize:16,
//                                                 onPressed: () {
//                                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
//                                                     return MainWidgetXpage(initialPage:  EventProfilePage(eventid:data['events'][index]));
//                                                   }));
//                                                 },
//                                                 ),
//                                               ],
//                                             ),
//                                             Text('Begin on ${DateFormat('E dd/MM/yyyy, HH:mm').format(datatwo['start'].toDate())}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[500],fontSize: 12)),
//                                             Text('End on ${DateFormat('E dd/MM/yyyy, HH:mm').format(datatwo['end'].toDate())}',textAlign: TextAlign.left ,style:  TextStyle(color: Colors.grey[500],fontSize: 12)),

//                                           ],
//                                         ),
//                                       )
//                                       )
//                         )
//                       )
//                                       );
//                                     }}
//                                     return SizedBox(height: 0,);

//                                     })),
//                                     SizedBox(height: 12,)
//                                 ],
//                               );
//                   }
//                 ),
//                 ),
//                 );
//               // return Image.network("${data['imageUrl']}");
//           }
//           return Text('loading..');
//         }),),
//       ),
//     );
//   }
// }

class GetCustomerData extends StatelessWidget {
  final String documentId, field;
  final TextStyle textStyle;
  final int maxLines;
  GetCustomerData(
      {required this.documentId,
      required this.field,
      required this.textStyle,
      required this.maxLines});
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('customers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text('${data['${field}']}',style: TextStyle(fontSize: 17,color: Colors.white),);
          return AutoSizeText(
            '${data['${field}']}',
            style: textStyle,
            maxLines: maxLines,
            minFontSize: 12,
          );
          // return Image.network("${data['imageUrl']}");
        }
        return Text('loading..');
      }),
    );
  }
}

class TextUtil extends StatelessWidget {
  String text;
  Color? color;
  double? size;
  bool? weight;
  TextUtil({super.key, required this.text, this.size, this.color, this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? Theme.of(context).canvasColor,
          fontSize: size ?? 18,
          fontWeight: weight == null ? FontWeight.normal : FontWeight.bold),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';

class ShowUpAnimation extends StatefulWidget {
  /// GETTING THE CHILD WIDGET
  final Widget child;
  /// GETTING THE ANIMATION DURATION
  int? delay;

  ShowUpAnimation({required this.child,  this.delay});

  @override
  _ShowUpAnimationState createState() => _ShowUpAnimationState();
}

class _ShowUpAnimationState extends State<ShowUpAnimation> with TickerProviderStateMixin {
  /// CREATING THE ANIMATION CONTROLLER VARIABLE
  late AnimationController _animController;
  /// CREATING THE ANIMATION  VARIABLE OF TYPE OFFSET
  late Animation<Offset> _animOffset;
  /// CREATING THE TIMER VARIABLE
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
    CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);


    if (widget.delay == null) {
      _animController.forward();
    } else {
      _timer= Timer(Duration(milliseconds: widget.delay!), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}