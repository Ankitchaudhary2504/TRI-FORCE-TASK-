import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triforce_todo_list_app/model/model.dart';
import 'package:triforce_todo_list_app/controller/task_controller.dart';

class PendingTasks extends StatelessWidget {
  // I make  a list then initilize Task model
  final List<Task> pendingTasks;

  const PendingTasks({super.key, required this.pendingTasks});

  @override
  Widget build(BuildContext context) {
    // depandecy injection
    final TaskController tController = Get.find();

    return Scaffold(
      backgroundColor: Colors.black87,
      body: pendingTasks.isEmpty
          ? const Center(
              child: Text("No pending tasks",
                  style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: pendingTasks.length,
              itemBuilder: (context, index) {
                final task = pendingTasks[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.green, width: 2),
                      color: Colors.grey[850],
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          task.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.description,
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 5),
                            Text("Due: ${task.dueDate}",
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 5),
                            Obx(() => Text(
                                  task.isCompleted.value
                                      ? "Completed"
                                      : "Pending",
                                  style: TextStyle(
                                      color: task.isCompleted.value
                                          ? Colors.green
                                          : Colors.red),
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
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
