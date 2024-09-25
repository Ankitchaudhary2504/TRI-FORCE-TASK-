import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triforce_todo_list_app/model/model.dart';

class TaskController extends GetxController {
  // This is the todoList as List all added tasks are store in this List Index-wise
  var todoList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTodoList(); // Load existing tasks on initialization
  }

  void addTask(String title, String description, String dueDate) {
    todoList
        .add(Task(title: title, description: description, dueDate: dueDate));
    _saveTodoList();
  }

// Logic of check - Uncheck
  void toggleTaskCompletion(int index) {
    // the logic for if task complete then it show on completeed tab
    // if not completed show on panding tab
    todoList[index].isCompleted.value =
        !todoList[index].isCompleted.value; // Use .value to toggle
    _saveTodoList();
  }

// Logic of Remove task from list index -wise
  void removeTask(int index) {
    todoList.removeAt(index);
    _saveTodoList();
  }

  Future<void> _saveTodoList() async {
    final prefs = await SharedPreferences.getInstance();

    // I make jsonString variable which is add dynamic data in todoList List
    final String jsonString =
        jsonEncode(todoList.map((task) => task.toJson()).toList());
    // Then i define KEY and Value
    await prefs.setString('todoList', jsonString);
  }

  Future<void> loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    // This jsonString variable GetSting from KEY that we define
    final String? jsonString = prefs.getString('todoList');
    //this condetion for checking jsonString is not null
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      todoList.assignAll(jsonList.map((json) => Task.fromJson(json)).toList());
    }
  }

//  this Logic fore which is stored task already in list  that task will be  Updating
  void updateTask(Task task, String title, String description, String dueDate) {
    task.title = title;
    task.description = description;
    task.dueDate = dueDate;
    _saveTodoList();
    // After the save  task the reload the task
    loadTodoList();
  }
}
