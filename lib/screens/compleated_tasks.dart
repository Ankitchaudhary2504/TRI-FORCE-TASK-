import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triforce_todo_list_app/model/model.dart';
import 'package:triforce_todo_list_app/controller/task_controller.dart';

class CompletedTasks extends StatelessWidget {
  // I make  a list then initilize Task model
  final List<Task> completedTasks;

  const CompletedTasks({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    final TaskController tController = Get.find();

    return Scaffold(
      backgroundColor: Colors.black87,
      body: completedTasks.isEmpty
          ? Center(
              child: Text("No completed tasks",
                  style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          task.title,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.description,
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 5),
                            Text("Due: ${task.dueDate}",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 5),
                            Obx(() => Text(
                                  task.isCompleted.value
                                      ? "Completed"
                                      : "Pending",
                                  style: TextStyle(color: Colors.green),
                                )),
                          ],
                        ),
                      ),
                      trailing: Checkbox(
                        value: task.isCompleted.value,
                        onChanged: (bool? value) {
                          tController.toggleTaskCompletion(
                            tController.todoList.indexOf(task),
                          );
                        },
                        activeColor: Colors.deepOrange,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
