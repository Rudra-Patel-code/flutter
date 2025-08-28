import 'package:flutter/material.dart';
import 'package:myapp/models/tasks.dart';
import 'package:myapp/providers/task_providers.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final TextEditingController nameCOntroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: Image.asset('assets/rdplogo.png', height: 80)),
            const Text(
              'Daily Planner',
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            focusedDay: DateTime.now(),
            firstDay: DateTime(2025),
            lastDay: DateTime(2026),
          ),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return buildAddTaskSection(nameCOntroller, () async {
                await taskProvider.addTask(nameCOntroller.text);
                nameCOntroller.clear();
              });
            },
          ),
        ],
      ),
      drawer: Drawer(),
    );
  }
}

// Build the section for adding tasks

Widget buildAddTaskSection(nameController, addTask) {
  return Container(
    decoration: BoxDecoration(color: Colors.white),
    child: Row(
      children: [
        Expanded(
          child: Container(
            child: TextField(
              maxLength: 32,
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Add Task",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        ElevatedButton(onPressed: addTask, child: Text('Add Task')),
      ],
    ),
  );
}

Widget buildTaksItem(
  List<Task> tasks,
  Function(int) removeTasks,
  Function(int, bool) updateTask,
) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tasks.length,
    itemBuilder: (context, index) {},
  );
}
