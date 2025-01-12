import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/presentation/authentication/login_page.dart';
import 'package:todolist/providers/view_task_provider.dart';

class TaskProvider with ChangeNotifier {
  TextEditingController _assignDateController = TextEditingController();
  TextEditingController _assignTimeController = TextEditingController();
  TextEditingController _deadlineDateController = TextEditingController();
  TextEditingController _deadlineTimeController = TextEditingController();
  TextEditingController _toDoTaskController = TextEditingController();

  TextEditingController get assignDateController => _assignDateController;
  TextEditingController get assignTimeController => _assignTimeController;
  TextEditingController get deadlineDateController => _deadlineDateController;
  TextEditingController get deadlineTimeController => _deadlineTimeController;
  TextEditingController get toDoTaskController => _toDoTaskController;

  String? _selectedValue;
  String? _selectedValue2;
  final List<String> _options = ['Yes', 'No'];

  String? get selectedValue => _selectedValue;
  String? get selectedValue2 => _selectedValue2;
  List<String> get options => _options;

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      notifyListeners();
    }
  }

  Future<void> submitTask(BuildContext context) async {
    if (_toDoTaskController.text.isEmpty ||
        _assignDateController.text.isEmpty ||
        _assignTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please fill out all required fields.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),
        );
        return;
      }

      Map<String, dynamic> taskData = {
        'taskAssignDate': _assignDateController.text,
        'taskAssignTime': _assignTimeController.text,
        'toDoTask': _toDoTaskController.text, // Added the "What to do?" field
        'taskDeadlineDate': _deadlineDateController.text,
        'taskDeadlineTime': _deadlineTimeController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': currentUser.uid,
      };

      DocumentReference taskRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('tasks')
          .add(taskData);

      await taskRef.update({
        'taskId': taskRef.id,
      });
      await Provider.of<ViewTaskProvider>(context, listen: false).fetchTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Task registered successfully!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Task registration Failed!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void clearForm() {
    _assignDateController.clear();
    _assignTimeController.clear();
    _deadlineDateController.clear();
    _deadlineTimeController.clear();
    _toDoTaskController.clear();
    _selectedValue = null;
    _selectedValue2 = null;
    notifyListeners();
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Provider.of<ViewTaskProvider>(context, listen: false).clearTasks();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Successfully logged out!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Error logging out: $e',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void updateSelectedValue(String? value) {
    _selectedValue = value;
    notifyListeners();
  }

  void updateSelectedValue2(String? value) {
    _selectedValue2 = value;
    notifyListeners();
  }
}
