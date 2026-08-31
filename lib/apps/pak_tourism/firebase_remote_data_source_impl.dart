import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_erp/models/user.dart' as app_user;

class FirebaseRemoteDataSourceImpl {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> getCreateCurrentUser(app_user.User user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUId();
    userCollection
        .doc(uid)
        .get()
        .then((userDoc) {
          final newUser = app_user.User(
            id: uid,
            firstName: user.firstName,
            email: user.email,
            /**The method 'toMap' isn't defined for the type 'User'.
Try correcting the name to the name of an existing method, or defining a method named 'toMap'. */
          ).toJson();
          if (!userDoc.exists) {
            userCollection.doc(uid).set(newUser);
            return;
          } else {
            userCollection.doc(uid).update(newUser);
            print("user already exist");
            return;
          }
        })
        .catchError((error) {
          print(error);
        });
  }

  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signIn(app_user.User user) async {
    await auth.signInWithEmailAndPassword(
      email: user.email!,
      password: user.pass!,
    );
  }

  Future<void> signUp(app_user.User user) async {
    await auth.createUserWithEmailAndPassword(
      email: user.email!,
      password: user.pass!,
    );
  }
}
