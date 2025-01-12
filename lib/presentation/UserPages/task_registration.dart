import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todolist/presentation/authentication/login_page.dart';
import 'package:todolist/widget/custom_text_form_field.dart';
import '../../widget/custom_button.dart';

class TaskRegistration extends StatefulWidget {
  const TaskRegistration({super.key});

  @override
  State<TaskRegistration> createState() => _TaskRegistrationState();
}

class _TaskRegistrationState extends State<TaskRegistration>
    with SingleTickerProviderStateMixin {
  late TextEditingController _dateController;
  late TextEditingController _assignDateController;
  late TextEditingController _assignTimeController;
  late TextEditingController _deadlineDateController;
  late TextEditingController _deadlineTimeController;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  String? selectedValue;
  String? campPlanselectedValue;
  String? lastselectedValue;
  final List<String> _options = ['Yes', 'No'];
  String? _selectedValue;
  String? _selectedValue2;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _assignDateController = TextEditingController();
    _assignTimeController = TextEditingController();
    _deadlineDateController = TextEditingController();
    _deadlineTimeController = TextEditingController();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void _submitTask() async {
    if (_assignDateController.text.isEmpty ||
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
          const SnackBar(content: Text('User is not logged in.')),
        );
        return;
      }

      Map<String, dynamic> taskData = {
        'taskAssignDate': _assignDateController.text,
        'taskAssignTime': _assignTimeController.text,
        'toDoTask': toDoTask.text,
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

      // Clear the form
      _assignDateController.clear();
      _assignTimeController.clear();
      _deadlineDateController.clear();
      _deadlineTimeController.clear();

      setState(() {
        _selectedValue = null;
        _selectedValue2 = null;
      });
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Failed to register task: $e',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              _submitTask();
              // Add your retry logic here
              print('Retry task registration');
            },
          ),
        ),
      );
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
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

  @override
  void dispose() {
    _dateController.dispose();
    _assignDateController.dispose();
    _assignTimeController.dispose();
    _deadlineDateController.dispose();
    _deadlineTimeController.dispose();
    _controller.dispose();
    toDoTask.dispose();
    super.dispose();
  }

  final TextEditingController toDoTask = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To Do Task',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00008B),
                Color(0xFF00008B),
                Color(0xFF00008B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Task Details",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Task Assign Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: CustomTextFormField(
                            controller: _assignDateController,
                            onTap: () =>
                                _selectDate(context, _assignDateController),
                            labelText: 'Date',
                            icon: Icons.date_range,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: CustomTextFormField(
                            controller: _assignTimeController,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                _assignTimeController.text =
                                    pickedTime.format(context);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a time';
                              }
                              return null;
                            },
                            labelText: 'Time',
                            icon: Icons.watch_later,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildRadioOption('Deadline:', _options, _selectedValue2,
                      (value) {
                    setState(() {
                      _selectedValue2 = value;
                    });
                  }),
                  SizedBox(height: 20),
                  _selectedValue2 == "Yes"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: CustomTextFormField(
                                  controller: _deadlineDateController,
                                  onTap: () => _selectDate(
                                      context, _deadlineDateController),
                                  labelText: 'Date',
                                  icon: Icons.date_range,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: CustomTextFormField(
                                  controller: _deadlineTimeController,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      _deadlineTimeController.text =
                                          pickedTime.format(context);
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a time';
                                    }
                                    return null;
                                  },
                                  labelText: 'Time',
                                  icon: Icons.watch_later,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 20,
                  ),
                  ..._buildFormFields(),
                  SizedBox(height: 30),
                  // Submit Button
                  Center(
                      child: CustomButton(
                    text: 'Submit',
                    onPressed: () {
                      _submitTask();
                      toDoTask.clear();
                    },
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    List<Widget> fields = [
      _buildCustomTextFormField('What to be done ?',
          FontAwesomeIcons.diagramProject, toDoTask, context),
      SizedBox(height: 20),
    ];
    return fields;
  }

  Widget _buildCustomTextFormField(String label, IconData icon,
      TextEditingController controller, BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: label,
      icon: icon,
      onSaved: (value) {
        if (value == null || value.isEmpty) {
          _showAwesomeSnackbar(context, 'Please fill out this field');
        }
      },
    );
  }

  Widget _buildRadioOption(String label, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                ),
                Text(
                  option,
                  style: TextStyle(),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showAwesomeSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
