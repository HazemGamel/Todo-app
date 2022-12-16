

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
import 'package:todo/ui/widgets/task_tile.dart';

import '../size_config.dart';
import '../theme.dart';
import 'add_task_page.dart';
import 'package:todo/models/task.dart';
import 'package:notification_permissions/notification_permissions.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController =Get.put(TaskController());
  DateTime selecttime =DateTime.now();
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    //_taskController.GetTasks()!;
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar:AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(onPressed: (){
          ThemeServices().switchmode();
         // NotifyHelper().displayNotification(title: 'Hello ', body: "Hazem");
          //notifyHelper.schedualnot();
        },icon:Get.isDarkMode? Icon(Icons.wb_sunny_outlined):Icon(Icons.nightlight_round),
          iconSize: 30,
          color: Get.isDarkMode?Colors.white:Colors.black,),
        actions: [
          IconButton(
              icon: Icon(Icons.cleaning_services_outlined,
                color:Get.isDarkMode?Colors.white:Colors.black,size: 30,),
              onPressed: (){
                //notifyHelper.cancelAllNotification();
                _taskController.deleteAllTasks();
                Get.snackbar('Deleted', 'All Your Notes are Deleted',
                  icon: Icon(Icons.done,color: Colors.green,),
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.white,
                  colorText: Colors.green,
                );
                },

              ),
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(width: 6,),
        ],
      ),
      body: Column(children:[
             _addtaskpar(),
             _addDatepar(),
        SizedBox(height: 10,),
        _showtasks(),
      ]
        , ),
    );
  }
  _addtaskpar(){
    return Container(
      margin: EdgeInsets.only(left: 20,right: 10,top: 10,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(DateFormat.yMMMMd().format(DateTime.now()).toString(),
                 style: titlingStyle,),
              Text("Today",style: headingStyle,)
            ],
          ),
          MyButton(label: '+ Add Task', ontap:()async{
          await  Get.to(AddTaskPage());
          _taskController.GetTasks();
          }),
        ],
      ),
    );
  }
  _addDatepar(){
    return Container(
      margin: EdgeInsets.only(left: 20,top: 6),
      child: DatePicker(
        DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
       dateTextStyle: GoogleFonts.lato(
         textStyle: TextStyle(
           fontSize: 20,
           fontWeight: FontWeight.w600,
           color: Colors.grey,
         ),
       ),
        dayTextStyle:GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ) ,
        monthTextStyle:GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:Colors.grey,
          ),
        ) ,

        initialSelectedDate: DateTime.now(),
        width: 50,
        height: 100,
        onDateChange: (timenow){
          setState(() {
            selecttime = timenow;
          });
        },
      ),
    );
  }
  Future<void> _onrefresh()async{
   await _taskController.GetTasks();
  }
  _showtasks(){
    return Expanded(
      child:Obx((){
        if(_taskController.Tasklist.isEmpty){
          return _notaskmsg();
        }else{
          return  RefreshIndicator(
            onRefresh:_onrefresh ,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation==Orientation.landscape?
              Axis.horizontal:Axis.vertical,
              itemBuilder:(context,index){
                var task =_taskController.Tasklist[index];
                if( task.repeat == 'Daily'||
                    task.date==DateFormat.yMd().format(selecttime)||
                    (task.repeat=='Weekly' && selecttime.difference(DateFormat.yMd().parse(task.date!)).inDays %7==0)
                ||(task.repeat=='Monthly' && DateFormat.yMd().parse(task.date!).day == selecttime.day)
                ){
                  var hour=task.startTime.toString().split(':')[0];
                  var minutes=task.startTime.toString().split(':')[1];
                  print("hour is $hour");
                  print("minutes is $minutes");

                  DateTime  date=DateFormat.jm().parse(task.startTime.toString());
                  var mytime = DateFormat('HH:mm').format(date);
                  print("date is $date");
                  print("mytime is $mytime");
                  notifyHelper.scheduledNotification(
                      int.parse(mytime.toString().split(":")[0]),
                      int.parse(mytime.toString().split(":")[1]),
                      task);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: (){
                            _showbuttomsheet(context,
                                task
                            );
                          },
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                }else{
                  return Container();
                }
              },
              itemCount: _taskController.Tasklist.length,
            ),
          );
        }
      }),
    );

//    return Expanded(
//        child: GestureDetector(
//          onTap: (){
//            _showbuttomsheet(context,
//                Task(
//                  title: 'Hazem',
//                  note: 'hello Hazem',
//                  startTime: '20:30',
//                  endTime: '2:8',
//                  color: 1,
//                  isCompleted: 1,
//                )
//            );
//          },
//          child: TaskTile(Task(
//            title: 'Hazem',
//            note: 'hello Hazem',
//            startTime: '20:30',
//            endTime: '2:8',
//            color: 1,
//            isCompleted: 1,
//          )),
//        ),
//    );
  }

  _notaskmsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onrefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction:SizeConfig.orientation==Orientation.landscape?
                Axis.horizontal:Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation ==Orientation.landscape?
                  SizedBox(height: 6,):SizedBox(height: 120,),
                  SvgPicture.asset('images/task.svg',
                    height: 100,
                    color: primaryClr.withOpacity(0.5),
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                    child: Text("You do not have any task yet!\n add new tasks to make your days productive",
                    style: subtitleStyle,
                    textAlign: TextAlign.center,),
                  ),
                  SizeConfig.orientation ==Orientation.landscape?
                  SizedBox(height: 120,):SizedBox(height: 200,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

 _showbuttomsheet(BuildContext context,Task task){
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation==Orientation.landscape)?
          (task.isCompleted==1?
              SizeConfig.screenHeight*0.6:
              SizeConfig.screenHeight*0.8
          ):(task.isCompleted==1?
          SizeConfig.screenHeight*0.30:
          SizeConfig.screenHeight*0.39
          ),
          color: Get.isDarkMode?darkGreyClr:Colors.white,
          child: Column(
            children: [
              Flexible(child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
                ),
              ),
              ),
              SizedBox(height: 20,),
              task.isCompleted==1?Container():
                  _buildbottomsheet(
                      label: 'Task Completed',
                      ontap: (){
                       // notifyHelper.cancelNotification(task);
                        _taskController.marktaskcomplet(task.id!);
                        Get.back();
                      },
                      clr: pinkClr),
              SizedBox(height: 20,),
              _buildbottomsheet(
                  label: 'Delete Task',
                  ontap: (){
                   // notifyHelper.cancelNotification(task);
                    _taskController.delettask(task);
                    Get.back();
                  },
                  clr: pinkClr),
              SizedBox(height: 20,),
              _buildbottomsheet(
                  label: 'Cancle',
                  ontap: (){
                    Get.back();
                  },
                  clr: primaryClr),
            ],
          ),
        ),
      ),
    );
 }

  _buildbottomsheet({
    required String label,
    required Function() ontap,
    required Color clr,
    bool isClose =false,
  }){
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 55,
        width: SizeConfig.screenWidth *0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: isClose? Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr,
          ),
          color: isClose?Colors.transparent:clr,
        ),
        child: Center(
          child: Text(label,
            style: isClose?titlingStyle:titlingStyle.copyWith(color: Colors.white),),
        ),
      ),
    );
  }
}
