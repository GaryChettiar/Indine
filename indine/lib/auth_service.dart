import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final _auth = FirebaseAuth.instance; 
  Future<User?> createUserWithEmailAndPassword(String email, String password)async{
    try{

      final cred= await  _auth.createUserWithEmailAndPassword(email: email, password: password);
    return cred.user;
    }catch(e){
        print("something went wrong");
    }
    return null;
    
  }

  Future<User?> loginUserWithPhoneNumber(String email, String password)async{
    try{
       final cred= await  _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
    }catch(e){
        print("something went wrong");
    }
    return null;
   
  }

  Future<User?> logoutUserWithPhoneNumber(String email, String password)async{
    try{
      final cred= await  _auth.signOut();
    }catch(e){
        print("something went wrong");
    }
    
    
  }

}