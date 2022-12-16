import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload, }) : super(key: key);
  final String payload ;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  String _payload='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload=widget.payload;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Get.back(),
          icon: Icon(Icons.arrow_back_ios,color:Get.isDarkMode? Colors.white:darkGreyClr ,),),
        elevation: 0.0,
       backgroundColor: context.theme.backgroundColor,
        title: Text(_payload.toString().split('|')[0],
        style: TextStyle(color: Get.isDarkMode? Colors.white:darkGreyClr),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Text("Hello ,Hazem",style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.w600,
                color: Get.isDarkMode?Colors.white:darkGreyClr),),
                SizedBox(height: 10,),
                Text("You have a new reminder",
                  style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Get.isDarkMode? Colors.grey[200]:darkGreyClr),),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(child:Container(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryClr,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.text_format,color: Colors.white,size: 30,),
                        SizedBox(width: 15,),
                        Text("Title",
                          style: TextStyle(color: Colors.white,fontSize: 30),),

                      ],
                    ),
                    SizedBox(height: 15,),
                    Text(_payload.toString().split('|')[0],
                      style: TextStyle(
                    color: Colors.white,fontSize: 20),),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.description,
                          color: Colors.white,size: 30,),
                        SizedBox(width: 15,),
                        Text("Description",
                          style: TextStyle(color: Colors.white,fontSize: 30),),

                      ],
                    ),
                    SizedBox(height: 15,),
                    Text(_payload.toString().split('|')[1],
                      style: TextStyle(
                          color: Colors.white,fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                          color: Colors.white,size: 30,),
                        SizedBox(width: 15,),
                        Text("Date",
                          style: TextStyle(color: Colors.white,fontSize: 30),),

                      ],
                    ),
                    SizedBox(height: 15,),
                    Text("10:20",
                      style: TextStyle(
                          color: Colors.white,fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            )),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
