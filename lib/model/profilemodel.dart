import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel{
  String email;
  String password;
  String name,surname;
  ProfileModel({this.email='',this.password='',this.name='',this.surname=''});
}

class ProfileModelx {
  String email;
  String password;
  String name, surname;
  String general, attitude;
  ProfileModelx(
      {this.email = '', this.password = '', this.name = '', this.surname = '', this.general = '', this.attitude = ''});
}
