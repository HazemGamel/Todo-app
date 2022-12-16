import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task,{Key? key}) : super(key: key);
 final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:
      getProportionateScreenWidth(SizeConfig.orientation==Orientation.landscape? 4:20),
      ),
      width: SizeConfig.orientation==Orientation.landscape?SizeConfig.screenWidth/2:SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom:getProportionateScreenHeight(12), ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _showcolor(task.color),
        ),
        child: Row(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(task.title!,style:GoogleFonts.lato(
                   textStyle: TextStyle(
                     fontSize: 24,
                     fontWeight: FontWeight.bold,
                     color:Colors.white,
                   ),
                 ),),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.access_alarm,color: Colors.grey,size: 18,),
                      SizedBox(width: 12,),
                      Text('${task.startTime} - ${task.endTime}',
                        style:GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            color: Colors.grey[100],
                          ),
                        ),),
                      SizedBox(height: 20,),
                    ],
                  ),
                  Text(task.note!,style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey[100],
                    ),
                  ),),
                ],
              ),
            ),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(quarterTurns: 3,
              child: Text(task.isCompleted==0?'TODO':'Completed',style:
              GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color:Colors.white,
                ),
              ),),),
          ],
        ),
      ),
    );
  }

  _showcolor(int? color) {
    switch(color){
      case 0:
        return primaryClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return primaryClr;
    }
  }
}
