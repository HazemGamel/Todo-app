import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';
class DBHelper {
  static Database? _db;
  static const int _verision = 5;
  static const String _tableName='tasks';

 static Future<void> initdb()async{
    if(_db != null){
      return;
    }else{
      try{
        String _path= await getDatabasesPath()+'task.db';
        print("in database path");
        _db=await openDatabase(_path,version: _verision,
        onCreate: (Database db,int version)async{
       await  db.execute('CREATE TABLE $_tableName('
           'id INTEGER PRIMARY KEY AUTOINCREMENT,'
           'title STRING,note STRING,date STRING,'
           'startTime STRING,endTime STRING,'
           'remind INTEGER,repeat STRING,'
           'color INTEGER,'
           'isCompleted INTEGER)',
        );
        }
        );
        print("database created");
      }catch(e){
       print("error is $e");
      }
    }
  }

  static Future<int> insert(Task? task)async{
   print("insert fun");
   return await _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task task)async{
    print("delete fun");
    return await _db!.delete(_tableName,where:'id = ?',whereArgs: [task.id]);
  }
  static Future<int> deleteAllTasks()async{
    print("delete all fun");
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String,dynamic>>> qeury()async{
    print("query fun");
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id)async{
    print("update fun");
    return await _db!.rawUpdate('''
    UPDATE tasks 
    SET isCompleted = ?
    WHERE id = ?
    ''',[1,id]);
  }


}
