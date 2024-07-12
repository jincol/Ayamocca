import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConnection {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully.');
    } catch (e) {
      print('Failed to initialize Firebase: $e');
    }
  }

  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userData['correo'],
        password: userData['password'],
      );
      String uid = userCredential.user!.uid;
      userData.remove('password');
      userData['seguidores'] = [];
      userData['seguidos'] = [];
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set(userData);
      print('User data saved successfully.');
      return true;
    } catch (e) {
      print('Failed to save user data: $e');
      return false;
    }
  }
}
