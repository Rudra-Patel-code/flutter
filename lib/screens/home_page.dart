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
  // input controller for the add task button
  final TextEditingController nameCOntroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  // ui components to display in the screen
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
          // scrollable to avoid overflow
          Expanded(
            child: SingleChildScrollView(
              child: TableCalendar(
                calendarFormat: CalendarFormat.month,
                focusedDay: DateTime.now(),
                firstDay: DateTime(2025),
                lastDay: DateTime(2026),
              ),
            ),
          ),
          // list all the tasks
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return buildTaksItem(
                taskProvider.tasks,
                taskProvider.removeTask,
                taskProvider.updateTask,
              );
            },
          ),
          // addin task section
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
        // input field for adding tasks
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
        // button to submit button
        ElevatedButton(onPressed: addTask, child: Text('Add Task')),
      ],
    ),
  );
}

// widget to render the list of tasks

Widget buildTaksItem(
  List<Task> tasks,
  Function(int) removeTasks,
  Function(int, bool) updateTask,
) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];
      final isEven = index % 2 == 0;

      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // alternate bg color for tasks list
          tileColor: isEven ? Colors.blue : Colors.green,
          // conditional to render the checked button if task is completed
          leading: Icon(
            task.completed ? Icons.check_circle : Icons.circle_outlined,
          ),
          title: Text(
            task.name,

            // conditional to render the line through if the task is completed
            style: TextStyle(
              decoration: task.completed ? TextDecoration.lineThrough : null,
              fontSize: 22,
            ),
          ),
          trailing: Row(
            // added to avoid the overflow
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: task.completed,
                onChanged: (value) => {updateTask(index, value!)},
              ),
              IconButton(
                onPressed: () => removeTasks(index),
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      );
    },
  );
}
