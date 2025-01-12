import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/task_provider.dart';
import 'package:todolist/providers/task_view_provider.dart';
import 'package:todolist/widget/custom_button.dart';

class TaskViewPage extends StatefulWidget {
  final Map<String, dynamic> userTasks;

  TaskViewPage({required this.userTasks});

  @override
  _TaskViewPageState createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeInAnimation;

  bool isEditing = false;
  TextEditingController toDoTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    toDoTaskController.text = widget.userTasks['toDoTask'].toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    toDoTaskController.dispose();
    super.dispose();
  }

  void deleteTask() async {
    var taskId = widget.userTasks['taskId'];

    if (taskId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task ID is missing')),
      );
      return;
    }

    try {
      await Provider.of<TaskViewProvider>(context, listen: false)
          .deleteTask(taskId, context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Task Deleted successfully!',
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
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  void updateTask() async {
    var taskId = widget.userTasks['taskId'];

    if (taskId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task ID is missing')),
      );
      return;
    }

    try {
      await Provider.of<TaskViewProvider>(context, listen: false)
          .updateTask(taskId, toDoTaskController.text, context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Task Updated successfully!',
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
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          'ToDoList Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.05,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.022),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "TO-DO-List",
                      style: TextStyle(
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    isEditing
                        ? TextField(
                            controller: toDoTaskController,
                            decoration: InputDecoration(
                              hintText: 'Edit Task...',
                              border: OutlineInputBorder(),
                            ),
                            autofocus: true,
                          )
                        : Text(
                            widget.userTasks['toDoTask'].toString(),
                            style: TextStyle(
                              fontSize: screenWidth * 0.046,
                              color: Colors.black54,
                            ),
                          ),
                    SizedBox(height: screenHeight * 0.015),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Task Assign Date",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.048,
                              ),
                            ),
                            Text(
                              "Task Deadline Date",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.048,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  widget.userTasks['taskAssignDate']!
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  widget.userTasks['taskDeadlineDate']!
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  widget.userTasks['taskAssignTime']!
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  widget.userTasks['taskDeadlineTime']!
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: screenWidth * 0.12,
            right: screenWidth * 0.12,
            bottom: screenHeight * 0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.3,
              height: screenHeight * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                    if (!isEditing) {
                      updateTask();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  isEditing ? 'Save' : 'Edit',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.3,
              height: screenHeight * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  deleteTask();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
