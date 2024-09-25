import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:triforce_todo_list_app/controller/task_controller.dart';
import 'package:triforce_todo_list_app/screens/EditTaskPage.dart';

class TodoList extends StatelessWidget {
  // This is 3 controllers of  textformfeild which is  holds the value  we entered

  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
// this the form KEY
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the controller with dependecy injection
    final TaskController tController = Get.put(TaskController());

    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent,
        onPressed: () {
          Get.bottomSheet(
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: taskController,
                        decoration: InputDecoration(
                          labelText: "Add Task",
                          suffixIcon: const Icon(Icons.task,
                              color: Colors.yellowAccent),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: "Description",
                          suffixIcon: const Icon(Icons.description,
                              color: Colors.green),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            dateController.text =
                                "${picked.toLocal()}".split(' ')[0];
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(
                              labelText: "Select Date",
                              suffixIcon: const Icon(Icons.date_range,
                                  color: Colors.blueAccent),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: SizedBox(
                          height: 40.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellowAccent,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                tController.addTask(
                                  taskController.text,
                                  descriptionController.text,
                                  dateController.text,
                                );

                                taskController.clear();
                                descriptionController.clear();
                                dateController.clear();
                                Get.back();

                                Get.snackbar(
                                  "Success",
                                  "Task added successfully!",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            },
                            child: Text(
                              "ADD",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: tController.todoList.length,
                itemBuilder: (context, index) {
                  final task = tController.todoList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.green, width: 2.w),
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
                              Text(
                                "Due: ${task.dueDate.isNotEmpty ? task.dueDate : "No Due Date"}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Obx(() => Text(
                                    task.isCompleted.value
                                        ? "Completed"
                                        : "Pending",
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                        leading: Obx(() => Checkbox(
                              value: task.isCompleted.value,
                              activeColor: Colors.deepOrange,
                              onChanged: (bool? value) {
                                tController.toggleTaskCompletion(index);
                              },
                            )),
                        trailing: SizedBox(
                          width: 80.w,
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  Get.defaultDialog(
                                    backgroundColor: Colors.black87,
                                    title: "Confirmation",
                                    titleStyle: TextStyle(color: Colors.white),
                                    middleText:
                                        "Are you sure you want to delete?",
                                    middleTextStyle:
                                        TextStyle(color: Colors.white),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          tController.removeTask(index);
                                          Get.back();
                                        },
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        child: Text("Yes",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: Text("No",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.yellow),
                                onPressed: () {
                                  Get.to(EditTaskPage(task: task));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
