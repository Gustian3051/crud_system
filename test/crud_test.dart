import 'package:flutter_test/flutter_test.dart';
import 'package:crud_system/helpers/database_helper.dart';
import 'package:crud_system/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper dbHelper;

  setUp(() async {
    // Initialize sqflite_common_ffi for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Inisialisasi database in-memory untuk testing
    dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db.delete('tasks');
  });

  test('Insert and retrieve tasks', () async {
    final task = Task(title: 'Test Task', isCompleted: false);
    await dbHelper.insertTask(task);
    final tasks = await dbHelper.getTasks();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Test Task');
    expect(tasks.first.isCompleted, false);
  });

  test('Update a task', () async {
    final id = await dbHelper.insertTask(Task(title: 'Test Task'));

    final updatedTask = Task(id: id, title: 'Updated Task', isCompleted: true);
    await dbHelper.updateTask(updatedTask);

    final tasks = await dbHelper.getTasks();
    final updated = tasks.firstWhere((t) => t.id == id);

    expect(updated.title, 'Updated Task');
    expect(updated.isCompleted, true);
  });

  test('Delete a task', () async {
    final id = await dbHelper.insertTask(Task(title: 'To be deleted'));
    final deleted = await dbHelper.deleteTask(id);
    final tasks = await dbHelper.getTasks();

    expect(deleted, 1);
    expect(tasks.any((t) => t.id == id), false);
  });

  test('Check deadline', () async {
    final deadline = DateTime.now().subtract(Duration(days: 1));
    final id = await dbHelper.insertTask(
      Task(title: 'Deadline Task', deadline: deadline),
    );

    final tasks = await dbHelper.getTasks();
    final task = tasks.firstWhere((t) => t.id == id);

    expect(task.deadline != null, true);
    expect(task.deadline!.isBefore(DateTime.now()), true);
  });
}
