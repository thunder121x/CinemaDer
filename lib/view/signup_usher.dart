import 'dart:io';
import '../firebase_options.dart';
import 'package:cinemader/main.dart';
import 'package:flutter/material.dart';
import 'package:cinemader/decisiontree.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cinemader/model/profilemodel.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import 'package:cinemader/database.dart';
// import 'package:cinemader/apppages/homepage.dart';

// import 'package:firebase_storage/firebase_storage.dart';
class SignupUsher extends StatefulWidget {
  const SignupUsher({super.key});

  @override
  State<SignupUsher> createState() => _SignupUsherState();
}

class _SignupUsherState extends State<SignupUsher> with SingleTickerProviderStateMixin {
  bool? _animate;
  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  Future<bool> pickImage() async {
    // final animate;
    photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
        requestFullMetadata: false);
    setState(() {});
    return false;
  }

  @override
  void initState() {
    super.initState();
    // Calculate or fetch the value here
    _animate = true;
  }

  Future<void> uploadPfp() async {
    File uploadFile = File(photo!.path);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${uploadFile.path}')
          .putFile(uploadFile != null
              ? uploadFile
              : File("assets/profile-image.jpg"));
      // } on FirebaseException catch(e){print(e);}
    } catch (e) {
      print(e);
    }
  }

  Future<String> getDownload() async {
    File uploadedFile = File(photo!.path);
    return firebase_storage.FirebaseStorage.instance
        .ref("uploads/${uploadedFile.path}")
        .getDownloadURL();
  }

  final formKey = GlobalKey<FormState>();
  ProfileModelx profileModel = ProfileModelx();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  @override
  Widget build(BuildContext context) {
    // bool _animate = true;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    
    print(_animate);
    return         FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('managers').doc(userid).get(),
      builder: ((context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        Map<String,dynamic> managers = snapshot.data!.data() as Map<String, dynamic>;
        return
FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                // backgroundColor: AppColor.backgroundGray,
                body: SafeArea(
                  child: LoaderOverlay(
                    useDefaultLoading: false,
                    overlayWidgetBuilder: (_) {
                      return Center(
                        child: SpinKitCubeGrid(
                          color: AppColor.secondaryColor,
                          size: 50.0,
                        ),
                      );
                    },
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image(image: AssetImage('assets/images/cinemader-logo.png'),
                            //   height: 150.0,
                            //   fit: BoxFit.cover,
                            // ),
                            Text(
                              'Registration',
                              //style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                              style: GoogleFonts.actor(fontSize: 40),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Let\'s working together',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //image picker
                            GestureDetector(
                              onTap: () {
                                pickImage().then((value) => setState(() {
                                      _animate = false;
                                    }));
                              },
                              child: AvatarGlow(
                                  glowColor: AppColor.primarySwatch,
                                  animate: _animate!,
                                  repeat: true,
                                  // glowBorderRadius: BorderRadius.all(Radius.circular(90)),
                                  child: Material(
                                    shape: const CircleBorder(),
                                    elevation: 90,
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: photo != null
                                            ? FileImage(File(photo!.path))
                                            : null,
                                        backgroundColor: AppColor.primaryColor,
                                        child: photo == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 60,
                                              )
                                            : null),
                                  )),
                            ),
                            photo == null
                                ? Text(
                                    'add profile picture\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.black26),
                                  )
                                : SizedBox(
                                    height: 30,
                                  ),
                            Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundGray,
                                          border:
                                              Border.all(color: AppColor.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            onChanged: (String email) =>
                                                profileModel.email = email,
                                            validator: MultiValidator([
                                              RequiredValidator(
                                                errorText:
                                                    "Please field E-mail",
                                              ),
                                              EmailValidator(
                                                  errorText:
                                                      "Incorrect form of E-mail")
                                            ]),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'E-mail',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //password textfield
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundGray,
                                          border:
                                              Border.all(color: AppColor.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: TextFormField(
                                            validator: RequiredValidator(
                                              errorText:
                                                  "Please field password",
                                            ),
                                            obscureText: true,
                                            onChanged: (String password) =>
                                                profileModel.password =
                                                    password,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Password',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //name textfield
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundGray,
                                          border:
                                              Border.all(color: AppColor.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: TextFormField(
                                            validator: RequiredValidator(
                                              errorText:
                                                  "Please field your name",
                                            ),
                                            onChanged: (String name) =>
                                                profileModel.name = name,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Name',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //surname textfield
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundGray,
                                          border:
                                              Border.all(color: AppColor.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: TextFormField(
                                            validator: RequiredValidator(
                                              errorText:
                                                  "Please field your surname",
                                            ),
                                            onChanged: (String surname) =>
                                                profileModel.surname = surname,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Surname',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //general textfield
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundGray,
                                          border:
                                              Border.all(color: AppColor.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: TextFormField(
                                            validator: RequiredValidator(
                                              errorText:
                                                  "Please field your general",
                                            ),
                                            onChanged: (String general) =>
                                                profileModel.general = general,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'general',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                        //attitude textfield
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.backgroundGray,
                                              border: Border.all(
                                                  color: AppColor.white),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: TextFormField(
                                                validator: RequiredValidator(
                                                  errorText:
                                                      "Please field your attitude",
                                                ),
                                                onChanged: (String attitude) =>
                                                    profileModel.attitude =
                                                        attitude,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'attitude',
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                  ],
                                )),
                            //button

                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryColor,
                                    // foregroundColor: Color.fromRGBO(251, 157, 150, 1),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    shadowColor: AppColor.white,
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      context.loaderOverlay.show();
                                      formKey.currentState!.save();
                                      try {
                                        await uploadPfp()
                                            .then((newVal) async {});
                                        String newVal = await getDownload();
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email: profileModel.email,
                                                  password:
                                                      profileModel.password)
                                              .then((value) async {
                                            // try{
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .set({
                                              "email": profileModel.email,
                                              "name": profileModel.name,
                                              "surname": profileModel.surname,
                                              "imageUrl": newVal,
                                              "role": 0,
                                            }).then((value) async {
                                              await FirebaseFirestore.instance
                                                  .collection("ushers")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .set({
                                                    "cinema_id" : managers['cinema_id'],
                                                    "contract_expiration_date": Timestamp.fromDate(Timestamp.now().toDate().add(Duration(days: 365 * 6 ~/ 12))),
                                                    "contract_signing_date": Timestamp.now(),
                                                    "general": profileModel.general,
                                                    "attitude": profileModel.attitude,
                                                    "salary": 9000,
                                                // "tickets_id" : [],
                                                // "pocket_money": 0,
                                              }).then((value) {
                                                context.loaderOverlay.hide();
                                                // ignore: avoid_print
                                                print(
                                                    "email = ${profileModel.email} password = ${profileModel.password}");
                                                formKey.currentState?.reset();
                                                Fluttertoast.showToast(
                                                    msg: "Sign up successful");
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  return MainUser();
                                                }));
                                              });
                                            });
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          context.loaderOverlay.hide();
                                          // print(e.code);
                                          // print(e.message);
                                          Fluttertoast.showToast(
                                              msg: e.message!,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      } catch (e) {
                                        context.loaderOverlay.hide();
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please fill your image profile",
                                            gravity: ToastGravity.CENTER);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),

                            //already have a member? Login now
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
          }
          return Scaffold(
            backgroundColor: AppColor.primaryColor,
            body: Center(
                child: SpinKitCubeGrid(color: AppColor.white, size: 50.0)),
          );
        }));

  }
}
