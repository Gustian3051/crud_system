import 'package:crud_system/helpers/database_helper.dart';
import 'package:crud_system/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:crud_system/components/add_task_dialog.dart';
import 'package:crud_system/components/task_item.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  final TaskService taskService;

  const HomeScreen({super.key, required this.taskService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _dbHelper.getTasks();
    setState(() => _tasks = tasks);

    final now = DateTime.now();
    for (var task in tasks) {
      if (task.deadline != null && task.deadline!.isBefore(now) && !task.isCompleted) {
        await _notificationService.showMissedDeadlineNotification(task.title);
      }
    }
  }

  Future<void> _addTask() async {
    final newTask = await showDialog<Task>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );

    if (newTask != null) {
      await _dbHelper.insertTask(newTask);
      await _notificationService.showNotification(
        title: 'Task Created',
        body: 'Task "${newTask.title}" has been added.',
      );
      _loadTasks(); // Refresh list
    }
  }

  Future<void> _editTask(Task task) async {
    final updatedTask = await showDialog<Task>(
      context: context,
      builder: (_) => AddTaskDialog(task: task),
    );

    if (updatedTask != null) {
      await _dbHelper.updateTask(updatedTask);
      await _notificationService.showUpdateNotification(updatedTask.title);
      _loadTasks(); // Refresh list
    }
  }

  Future<void> _deleteTask(Task task) async {
    await _dbHelper.deleteTask(task.id!);
    await _notificationService.showDeleteNotification(task.title);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body:
          _tasks.isEmpty
              ? const Center(child: Text('No tasks yet!'))
              : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    task: _tasks[index],
                    onEdit: _editTask,
                    onDelete: _deleteTask,
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
