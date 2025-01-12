import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/task_provider.dart';
import 'package:todolist/providers/task_view_provider.dart';
import 'package:todolist/providers/view_task_provider.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_form_field.dart';

class TaskRegistration extends StatefulWidget {
  const TaskRegistration({super.key});

  @override
  State<TaskRegistration> createState() => _TaskRegistrationState();
}

class _TaskRegistrationState extends State<TaskRegistration> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewTaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To Do Task',
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => taskProvider.logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.035),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Task Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                "What to do?",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              CustomTextFormField(
                controller: taskProvider.toDoTaskController,
                labelText: 'Task Description',
                icon: FontAwesomeIcons.penToSquare,
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                "Task Assign Date",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(height: screenHeight * 0.018),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: taskProvider.assignDateController,
                      onTap: () => taskProvider.selectDate(
                          context, taskProvider.assignDateController),
                      labelText: 'Date',
                      icon: Icons.date_range,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                    child: CustomTextFormField(
                      controller: taskProvider.assignTimeController,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          taskProvider.assignTimeController.text =
                              pickedTime.format(context);
                        }
                      },
                      labelText: 'Time',
                      icon: Icons.watch_later,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildRadioOption('Deadline:', taskProvider.options,
                  taskProvider.selectedValue2, (value) {
                taskProvider.updateSelectedValue2(value);
              }),
              SizedBox(height: screenHeight * 0.022),
              taskProvider.selectedValue2 == "Yes"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: taskProvider.deadlineDateController,
                            onTap: () => taskProvider.selectDate(
                                context, taskProvider.deadlineDateController),
                            labelText: 'Date',
                            icon: Icons.date_range,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.05),
                        Expanded(
                          child: CustomTextFormField(
                            controller: taskProvider.deadlineTimeController,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                taskProvider.deadlineTimeController.text =
                                    pickedTime.format(context);
                              }
                            },
                            labelText: 'Time',
                            icon: Icons.watch_later,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: CustomButton(
                  text: 'Submit',
                  onPressed: () {
                    taskProvider.submitTask(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
}
