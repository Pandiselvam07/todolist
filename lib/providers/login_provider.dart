import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/view_task_provider.dart';
import 'package:todolist/widget/bottom_nav_bar.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      setErrorMessage("Email ID and password are required.");
      return;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Provider.of<ViewTaskProvider>(context, listen: false).clearTasks();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        setErrorMessage("User document not found. Contact support.");
      }
    } on FirebaseAuthException catch (e) {
      setErrorMessage(e.message);
    } catch (e) {
      setErrorMessage("An unexpected error occurred. Please try again.");
    } finally {
      setLoading(false);
    }
  }
}
