import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController =Get.put(TaskController());
  final TextEditingController _titlecontroler =TextEditingController();
  final TextEditingController _notecontroler =TextEditingController();
  DateTime selectdate =DateTime.now();
  String starttime=DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endtime=DateFormat('hh:mm a').
  format(DateTime.now().add(const Duration(minutes: 15))).toString();
   int selectremind=5;
   List<int> remindlist =[5,10,15,20];
   String selectrepeat='None';
   List<String> repeatlist=['None','Daily','Weekly','Monthly'];

   int selectcolor=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Icon(Icons.arrow_back_ios),color: Get.isDarkMode?Colors.white:Colors.black,),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(width: 6,),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add Task",style: headingStyle,),
              InputField(title: 'Title', hint: 'Enter Your task title',
                controller: _titlecontroler,
              ),
              InputField(title: 'Note', hint: 'Enter Your note',
              controller: _notecontroler,),
              InputField(title: 'DateTime',
                hint:DateFormat.yMd().format(selectdate),
                widget: IconButton(onPressed: (){
                  _getDatefromuser();
                },
                  icon: Icon(Icons.calendar_today_outlined),color: Colors.grey,),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(title: 'Start Time',
                      hint:starttime,
                      widget: IconButton(onPressed: (){
                        _getTimefromuser(isStartTime: true);
                      },
                        icon: Icon(Icons.access_alarm_outlined),
                        color: Colors.grey,),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: InputField(title: 'End Time',
                      hint:endtime,
                      widget: IconButton(onPressed: (){
                        _getTimefromuser(isStartTime: false);
                      },
                        icon: Icon(Icons.access_alarm_outlined),
                        color: Colors.grey,),
                    ),
                  ),
                ],
              ),
              InputField(title: 'Reminder',
                  hint: '$selectremind minutes early',
                widget: DropdownButton(
                  dropdownColor: Colors.blueGrey,
                  items: remindlist.map<DropdownMenuItem<String>>(
                          (int value) => DropdownMenuItem<String>(
                            value: value.toString(),
                              child:Text('$value',style: TextStyle(
                                color: Colors.white
                              ),))).toList(),
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 30,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String ? newvalu){
                    setState(() {
                      selectremind= int.parse(newvalu!);
                    });
                  },


                ),
              ),
              InputField(title: 'Repeat',
                  hint: '$selectrepeat ',
                widget: DropdownButton(

                  dropdownColor: Colors.blueGrey,
                  items: repeatlist.map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                              child:Text(value,style: TextStyle(
                                color: Colors.white
                              ),))).toList(),
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 30,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String ? newvalu){
                    setState(() {
                      selectrepeat= newvalu!;
                    });
                  },


                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color",style: titlingStyle,),
                      Row(
                        children: List.generate(3,
                                (index) =>
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          selectcolor=index;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundColor: index==0?primaryClr:
                                          index==1?pinkClr:orangeClr,
                                          child:selectcolor==index?
                                          Icon(Icons.done,color: Colors.white):null,
                                          radius: 20,
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ],

                  ),
                  MyButton(label:'Create Task',ontap:(){
                    _validatdate();
                  },),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
_validatdate(){
    if(_titlecontroler.text.isNotEmpty && _notecontroler.text.isNotEmpty){
      _addtasktodb();
      Get.back();
    }else if(_titlecontroler.text.isEmpty || _notecontroler.text.isEmpty){
      Get.snackbar('Required', 'All fields are required',
      icon: Icon(Icons.warning_amber_rounded,color: Colors.red,),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: pinkClr,
      );
    }else{
      print("#####");
    }
}
  _addtasktodb()async{
    try{
      int value = await _taskController.addtask(
        task: Task(
          title:_titlecontroler.text,
          note: _notecontroler.text,
          date: DateFormat.yMd().format(selectdate),
          isCompleted: 0,
          startTime: starttime,
          endTime: endtime,
          color: selectcolor,
          remind: selectremind,
          repeat: selectrepeat,
        ),
      );
      print("$value");
    }catch(e){
      print("err $e");
    }

  }
  _getDatefromuser()async{
    DateTime? pickedDate = await showDatePicker(context: context,
        initialDate: selectdate,
        firstDate: DateTime(2015), lastDate:DateTime(2030) );
    if(pickedDate != null)
    setState(() {
      selectdate= pickedDate;
    });
  }
  _getTimefromuser({required bool isStartTime})async{
    TimeOfDay? picktime=await showTimePicker(
        context: context,
        initialTime: isStartTime?TimeOfDay.fromDateTime(DateTime.now()):
        TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15)))
        );
    String formatedtime =picktime!.format(context);
    if(isStartTime)
      setState(() {
        starttime= formatedtime;
      });
    else if(!isStartTime)
      setState(() {
        endtime=formatedtime;
      });
    else
      print("time time ");
  }
}
