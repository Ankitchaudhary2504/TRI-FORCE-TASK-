import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triforce_todo_list_app/controller/task_controller.dart';
import 'package:triforce_todo_list_app/model/model.dart';

class EditTaskPage extends StatelessWidget {
  final Task task;

  EditTaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TaskController tController = Get.find();
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);
    final TextEditingController dueDateController =
        TextEditingController(text: task.dueDate);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          "Edit Task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    // Format and display the selected date
                    dueDateController.text =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: dueDateController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Due Date",
                      labelStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      suffixIcon:
                          const Icon(Icons.date_range, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onPressed: () {
                    tController.updateTask(
                      task,
                      titleController.text,
                      descriptionController.text,
                      dueDateController.text,
                    );
                    Get.back(result: true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
