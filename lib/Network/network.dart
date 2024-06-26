import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pune_india_app/auth/log_in.dart';
import 'package:pune_india_app/utilities/snackbar.dart';

class Network{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<String?> signUpUsers(String name,String email, String password, BuildContext context)async{
    try{
      UserCredential cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await firestore.collection('Users').doc(cred.user!.uid).set({
        "name": name,
        "email": email,
        "shopDetail":{}
      });
      return 'Account created successfully';
    }on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already in use.';
      }else if(e.code == 'weak-password'){
        return ' The given password is invalid. [ Password should be at least 6 characters ]';
      } else {
        return e.code;
      }
    } catch (e) {
      print(e);
      return 'An unknown error occurred.';
    }
  }

  Future<String?> signInUsersWithEmailAndPassword(String email, String password)async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return 'login Successful';
    }on FirebaseAuthException catch(e){
      if(e.code == 'invalid-credential'){
        return 'There are no valid credentials for this account. Please try signing up instead';
      }
      return e.code;
    }catch(e){
      return e.toString();
    }
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));

    await remoteConfig.setDefaults({
      "show_discounted_price": false,
    });

    await remoteConfig.fetchAndActivate();
  }

  signOut(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                  onPressed: ()async{
                   try{
                     await auth.signOut();
                     Navigator.push(context, MaterialPageRoute(builder: (context){
                       return const LogInPage();
                     }));
                   }on FirebaseAuthException catch (e){
                     snack(context, e.message!);
                   }
                   catch(e){
                     print(e.toString());
                   }
                  },
                  child: const Text('Yes')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('No')
              )
            ],
          );
        }
    );
  }
}