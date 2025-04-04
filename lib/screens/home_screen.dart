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
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    widget.taskService.checkDeadlineTasks(); // Cek deadline saat init
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.taskService.getTask();
    setState(() => _tasks = tasks);
  }

  Future<void> _addTask() async {
    final newTask = await showDialog<Task>(
      context: context,
      builder: (context) => AddTaskDialog(),
    );

    if (newTask != null) {
      await widget.taskService.addTask(newTask);
      _loadTasks(); // Refresh list
    }
  }

  Future<void> _updateTask(Task task) async {
    final updatedTask = await showDialog<Task>(
      context: context,
      builder: (context) => AddTaskDialog(task: task),
    );

    if (updatedTask != null) {
      await widget.taskService.updateTask(updatedTask);
      _loadTasks(); // Refresh list
    }
  }

  Future<void> _deleteTask(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Confirm deletion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      )
    );

    if (confirmed == true) {
      await widget.taskService.deleteTask(id);
      _loadTasks();
    }
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
                  final task = _tasks[index];
                  return TaskItem(
                    task: task,
                    onEdit: () async {
                      final updateTask = await showDialog<Task>(
                        context: context,
                        builder: (context) => AddTaskDialog(task: task),
                      );
                      if (updateTask != null) {
                        await widget.taskService.updateTask(updateTask);
                        _loadTasks();
                      }
                    },
                    onDelete: () async {
                      await widget.taskService.deleteTask(task.id!);
                      _loadTasks();
                    },
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
