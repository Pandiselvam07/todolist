import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todolist/presentation/UserPages/task_view.dart';
import 'package:todolist/providers/view_task_provider.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({super.key});

  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Provider.of<ViewTaskProvider>(context, listen: false).clearTasks();

    Provider.of<ViewTaskProvider>(context, listen: false)
        .fetchTasks()
        .then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildTaskCard(Map<String, dynamic> taskData, double screenWidth) {
    String date = taskData['taskAssignDate'] ?? 'N/A';
    String time = taskData['taskAssignTime'] ?? 'N/A';
    String toDoTask = taskData['toDoTask'] ?? 'N/A';
    String status = taskData['status'] ?? 'N/A';

    return GestureDetector(
      onTap: () {
        final userTaskData = {
          'date': taskData['taskAssignDate'] ?? 'N/A',
          'time': taskData['taskAssignTime'] ?? 'N/A',
          'createdAt': taskData['createdAt'] != null
              ? (taskData['createdAt'] as Timestamp)
                  .toDate()
                  .toString()
                  .substring(0, 10)
              : 'N/A',
          'toDoTask': taskData['toDoTask'] ?? 'N/A',
          'taskId': taskData['taskId'] ?? 'N/A',
          'userId': taskData['userId'] ?? 'N/A',
          'status': taskData['status'] ?? 'N/A',
          'taskAssignDate': taskData['taskAssignDate'] ?? 'N/A',
          'taskAssignTime': taskData['taskAssignTime'] ?? 'N/A',
          'taskDeadlineDate': taskData['taskDeadlineDate'] ?? 'N/A',
          'taskDeadlineTime': taskData['taskDeadlineTime'] ?? 'N/A',
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskViewPage(userTasks: userTaskData),
          ),
        );
      },
      child: FadeTransition(
        opacity: _animation,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.039),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.018),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notes,
                      size: screenWidth * 0.04,
                      color: const Color(0xffFF0000),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        toDoTask,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: screenWidth * 0.04,
                      color: const Color(0xffFF0000),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Date: $date',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.watch_later,
                      size: screenWidth * 0.04,
                      color: const Color(0xffFF0000),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Time: $time',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.work,
                      size: screenWidth * 0.04,
                      color: const Color(0xffFF0000),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Status: $status',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'View ToDo',
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
          decoration: const BoxDecoration(
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
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Consumer<ViewTaskProvider>(
          builder: (context, provider, child) {
            if (provider.todayTasks.isEmpty &&
                provider.tomorrowTasks.isEmpty &&
                provider.otherTasks.isEmpty) {
              return const Center(
                child: Text('No tasks for today, tomorrow, or others.'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.todayTasks.isNotEmpty) ...[
                    Text(
                      "Today's ToDo",
                      style: TextStyle(
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    ...provider.todayTasks.map((taskData) {
                      return buildTaskCard(taskData, screenWidth);
                    }).toList(),
                  ],
                  if (provider.tomorrowTasks.isNotEmpty) ...[
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "Tomorrow's ToDo",
                      style: TextStyle(
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    ...provider.tomorrowTasks.map((taskData) {
                      return buildTaskCard(taskData, screenWidth);
                    }).toList(),
                  ],
                  if (provider.otherTasks.isNotEmpty) ...[
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "Other Tasks",
                      style: TextStyle(
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    ...provider.otherTasks.map((taskData) {
                      return buildTaskCard(taskData, screenWidth);
                    }).toList(),
                  ],
                  if (provider.todayTasks.isEmpty &&
                      provider.tomorrowTasks.isEmpty &&
                      provider.otherTasks.isEmpty)
                    const Center(
                      child: Text('No tasks for today, tomorrow, or others.'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
