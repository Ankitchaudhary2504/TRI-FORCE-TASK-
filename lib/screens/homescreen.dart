import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triforce_todo_list_app/controller/task_controller.dart';
import 'package:triforce_todo_list_app/screens/add_task.dart';
import 'package:triforce_todo_list_app/screens/compleated_tasks.dart';

import 'package:triforce_todo_list_app/screens/pandding_taks.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController tController = Get.put(TaskController());

    return DefaultTabController(
      animationDuration: const Duration(seconds: 1),
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Get.to(() => SearchPage());
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white,
            tabs: [
              const Tab(text: "ALL"),
              Tab(text: "Completed"),
              Tab(text: "Pending"),
            ],
          ),
          backgroundColor: Colors.black26,
          title: const Center(child: Text("ToDo List")),
          foregroundColor: Colors.white,
        ),
        body: TabBarView(
          children: [
            TodoList(),
            Obx(() {
              return CompletedTasks(
                completedTasks: tController.todoList
                    // If Task completed then its show on  complete tab
                    .where((task) => task.isCompleted.value)
                    .toList(),
              );
            }),
            Obx(() {
              final pendingTasks = tController.todoList
                  // If Task is not completed then its show on  pending tab
                  .where((task) => !task.isCompleted.value)
                  .toList();
              return PendingTasks(pendingTasks: pendingTasks);
            }),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TaskController tController = Get.find();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          "Search Tasks",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search tasks...",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final searchText = searchController.text.toLowerCase();
              final filteredTasks = tController.todoList
                  .where(
                      (task) => task.title.toLowerCase().contains(searchText))
                  .toList();

              return filteredTasks.isEmpty
                  ? const Center(
                      child: Text("No tasks found",
                          style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
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
                              trailing: Text("Due: ${task.dueDate}",
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task.description,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    const SizedBox(height: 5),
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
