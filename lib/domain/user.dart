import 'package:firebase_auth/firebase_auth.dart';


class UserCurent {
  late String id;

  UserCurent.fromFirebase(User user){
    id = user.uid;
  }
}