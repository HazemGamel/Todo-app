import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
 final Tasklist = <Task>[].obs;

 Future<int> addtask({Task? task}){
 return DBHelper.insert(task);

 }
  GetTasks()async{
   final List<Map<String, dynamic>> tasks = await DBHelper.qeury();
   Tasklist.assignAll(tasks.map((e) => Task.fromjson(e)).toList());

  }
  void delettask(Task task)async{
   await DBHelper.delete(task);
   GetTasks();
  }
  void deleteAllTasks()async{
  await DBHelper.deleteAllTasks();
  GetTasks();
  }

  void marktaskcomplet(int id)async{
   await DBHelper.update(id);
   GetTasks();
  }

}
