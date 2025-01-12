import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ViewTaskProvider with ChangeNotifier {
  String loggedInUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<Map<String, dynamic>> todayTasks = [];
  List<Map<String, dynamic>> tomorrowTasks = [];
  List<Map<String, dynamic>> otherTasks = [];

  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String tomorrowDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().add(const Duration(days: 1)));

  ViewTaskProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loggedInUserId = user.uid;
        fetchTasks();
      } else {
        loggedInUserId = '';
        clearTasks();
      }
    });
  }

  Future<void> fetchTasks() async {
    try {
      clearTasks();
      if (loggedInUserId.isEmpty) return;

      final tasksSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('tasks')
          .where('userId', isEqualTo: loggedInUserId)
          .get();

      List<Map<String, dynamic>> fetchedTodayTasks = [];
      List<Map<String, dynamic>> fetchedTomorrowTasks = [];
      List<Map<String, dynamic>> fetchedOtherTasks = [];

      for (var task in tasksSnapshot.docs) {
        final taskData = task.data();
        String date = taskData['taskAssignDate'] ?? 'N/A';

        if (date == todayDate) {
          fetchedTodayTasks.add(taskData);
        } else if (date == tomorrowDate) {
          fetchedTomorrowTasks.add(taskData);
        } else {
          fetchedOtherTasks.add(taskData);
        }
      }

      todayTasks = fetchedTodayTasks;
      tomorrowTasks = fetchedTomorrowTasks;
      otherTasks = fetchedOtherTasks;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void clearTasks() {
    todayTasks.clear();
    tomorrowTasks.clear();
    otherTasks.clear();
    notifyListeners();
  }

  void updateUser(String userId) {
    if (loggedInUserId != userId) {
      loggedInUserId = userId;
      clearTasks();
      fetchTasks();
      notifyListeners();
    }
  }
}
