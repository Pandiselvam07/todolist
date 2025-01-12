import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/view_task_provider.dart';

class TaskViewProvider with ChangeNotifier {
  Future<void> deleteTask(String taskId, BuildContext context) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw 'User not logged in';
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('tasks')
          .doc(taskId)
          .delete();

      await Provider.of<ViewTaskProvider>(context, listen: false).fetchTasks();

      notifyListeners();
    } catch (e) {
      throw 'Failed to delete task: $e';
    }
  }

  Future<void> updateTask(
      String taskId, String newTask, BuildContext context) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw 'User not logged in';
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('tasks')
          .doc(taskId)
          .update({
        'toDoTask': newTask,
      });
      await Provider.of<ViewTaskProvider>(context, listen: false).fetchTasks();

      notifyListeners();
    } catch (e) {
      throw 'Failed to update task: $e';
    }
  }
}
