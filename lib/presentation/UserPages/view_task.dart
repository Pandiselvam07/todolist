import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/presentation/UserPages/task_view.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({super.key});

  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String loggedInUserId;

  @override
  void initState() {
    super.initState();

    loggedInUserId = FirebaseAuth.instance.currentUser!.uid;

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String tomorrowDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().add(const Duration(days: 1)));

  Widget buildTaskCard(Map<String, dynamic> taskData, double screenWidth) {
    String date = taskData['taskAssignDate'] ?? 'N/A';
    String time = taskData['taskAssignTime'] ?? 'N/A';
    String toDoTask = taskData['toDoTask'] ?? 'N/A';

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
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'View ToDo',
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
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(loggedInUserId)
              .collection('tasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitCubeGrid(
                  color: Color(0xffFF0000),
                  size: 50.0,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No To-Do found.'));
            }

            final tasks = snapshot.data!.docs;

            List<Widget> todayTasks = [];
            List<Widget> tomorrowTasks = [];
            List<Widget> otherTasks = [];

            for (var task in tasks) {
              final taskData = task.data() as Map<String, dynamic>;
              String date = taskData['taskAssignDate'] ?? 'N/A';

              if (date == todayDate) {
                todayTasks.add(buildTaskCard(taskData, screenWidth));
              } else if (date == tomorrowDate) {
                tomorrowTasks.add(buildTaskCard(taskData, screenWidth));
              } else {
                otherTasks.add(buildTaskCard(taskData, screenWidth));
              }
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todayTasks.isNotEmpty) ...[
                    const Text(
                      "Today's ToDo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...todayTasks,
                  ],
                  if (tomorrowTasks.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Tomorrow's ToDo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...tomorrowTasks,
                  ],
                  if (otherTasks.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Other Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...otherTasks,
                  ],
                  if (todayTasks.isEmpty &&
                      tomorrowTasks.isEmpty &&
                      otherTasks.isEmpty)
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
