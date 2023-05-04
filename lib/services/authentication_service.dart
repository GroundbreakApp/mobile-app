import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:ground_break/models/models.dart';

class AuthenticationService {
  static const String _usersCollectionName = 'users';

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String?> signUpWithEmail({
    required UserProfileModel profile,
    required String password,
  }) async {
    try {
      final List<String> methods =
          await firebaseAuth.fetchSignInMethodsForEmail(profile.email);

      if (methods.isNotEmpty) {
        return 'This Email is Already in Use, Choose a Different one, or Sign In with this email.';
      }

      await firebaseAuth.createUserWithEmailAndPassword(
        email: profile.email,
        password: password,
      );

      await updateProfile(profile);

      return null;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('[signUpWithEmail] ${e.toString()}');
      }
      if (e.code == 'weak-password') {
        return 'You Have Provided a Password Which is Too Weak, Please Change your Password.';
      } else if (e.code == 'email-already-in-use') {
        return 'This Email is Already in Use, Choose a Different one, or Sign In with this email.';
      } else if (e.code == 'invalid-email') {
        return 'This Email isn\'t Valid. Correct The Email Address and Try Again.';
      } else {
        return 'Something Went Wrong, Please Try Again.';
      }
    }
  }

  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw 'The Provided Email or Password is Incorrect';
      } else if (e.code == 'network-request-failed') {
        throw 'Whoops! Something went wrong. But don’t fret your Pals are checking in on it!';
      } else {
        rethrow;
      }
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithPopup(GoogleAuthProvider());

      final AdditionalUserInfo? additionalUserInfo =
          userCredential.additionalUserInfo;

      if (additionalUserInfo?.isNewUser == true) {
        await updateProfile(
          UserProfileModel(
            uid: userCredential.user!.uid,
            email: additionalUserInfo!.profile?['email'],
            displayName: additionalUserInfo.profile?['given_name'] +
                ' ' +
                additionalUserInfo.profile?['family_name'],
            organization: '',
          ),
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('[signInWithGoogle] ${e.toString()}');
      }
      return e.toString();
    }
  }

  Future<UserProfileModel?> updateProfile(UserProfileModel profile) async {
    User? currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection(_usersCollectionName)
            .doc(currentUser.uid)
            .set(
              profile.copyWith(uid: currentUser.uid).toJson(),
              SetOptions(merge: true),
            );
        return profile.copyWith(uid: currentUser.uid);
      } catch (e) {
        if (kDebugMode) {
          print('[updateProfile] ${e.toString()}');
        }
        return null;
      }
    } else {
      return null;
    }
  }

  Future<UserProfileModel?> getProfile({String? uid}) async {
    User? currentUser = firebaseAuth.currentUser;
    String? actualUid = uid ?? currentUser?.uid;
    if (actualUid != null) {
      try {
        return UserProfileModel.fromSnapshot(
          await FirebaseFirestore.instance
              .collection(_usersCollectionName)
              .doc(actualUid)
              .get(),
        );
      } catch (e) {
        if (kDebugMode) {
          print('[getProfile] ${e.toString()}');
        }
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    if (firebaseAuth.currentUser != null) {
      await firebaseAuth.signOut();
    }
  }
}
