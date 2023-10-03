import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:steps_counter1/domain/user.dart';
import 'package:steps_counter1/firebase_options.dart';

class AuthService{
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  
  Future<UserCurent?> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _fAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return UserCurent.fromFirebase(user!);
    }catch(e){
      return null;
    }
  }

  Future<UserCurent?> registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return UserCurent.fromFirebase(user!);
    }catch(e){
      return null;
    }
  }

  Future logOut() async{
    await _fAuth.signOut();
  }

  // Stream<UserCurent> get currentUser{
  //   return _fAuth.authStateChanges().map((User? user) => user );
  // }
}