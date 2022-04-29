import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/databaseclass.dart';
import 'package:notes_app/main.dart';
import 'package:sqflite/sqflite.dart';

class createnotepg extends StatefulWidget {
  @override
  _createnotepgState createState() => _createnotepgState();
}

class _createnotepgState extends State<createnotepg> {
  String time1 = "";
  String date = "";

  TextEditingController title = TextEditingController();
  TextEditingController notes = TextEditingController();

  Database? db;
  bool apploadstatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      apploadstatus = true;
    });

    getdata();
  }

  getdata() {
    Databasehelper().Getdatabase().then((value) {
      db = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double theheight = MediaQuery.of(context).size.height;
    double thewidth = MediaQuery.of(context).size.width;
    double statusbarheight = MediaQuery.of(context).padding.top;
    double navigatorbarheight = MediaQuery.of(context).padding.bottom;
    double appbarheight = kToolbarHeight;
    double thebodyheight =
        theheight - statusbarheight - appbarheight - navigatorbarheight;
    return apploadstatus
        ? WillPopScope(
            onWillPop: onbackpop,
            child: Scaffold(
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: AlignmentDirectional.topEnd,
                      height: thebodyheight * 0.1,
                      child: FlatButton(
                          onPressed: () {
                            String notetitle = title.text;
                            String enternote = notes.text;

                            Databasehelper()
                                .insertdata(notetitle, enternote, db!)
                                .then((value) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return firstpage();
                                },
                              ));
                            });
                          },
                          child: Text("Save")),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        controller: title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: "Enter Title",
                        ),
                      ),
                    ),
                    Container(
                      height: thebodyheight * 0.7,
                      // margin: EdgeInsets.all(5),
                      child: TextField(
                        maxLines: 15,
                        controller: notes,
                        decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Enter Notes"),
                      ),
                    ),
                    Container(
                      child: FlatButton.icon(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                    data: ThemeData.dark(), child: child!);
                              },
                            ).then((value) {
                              date =
                                  "${value!.year.toString()}/${value.month.toString()}/${value.day.toString()}";
                            });
                          },
                          icon: Icon(Icons.date_range),
                          label: Text("${date}")),
                    ),
                    Container(
                        child: FlatButton.icon(
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!);
                                },
                              ).then((value) {
                                setState(() {
                                  time1 =
                                      "${value!.hour.toString()} : ${value.minute.toString()}";
                                });
                              });
                            },
                            icon: Icon(Icons.access_time),
                            label: Text("$time1"))),
                  ],
                ),
              )),
            ),
          )
        : Center(
            child: CircularProgressIndicator(
            color: Colors.black,
          ));
  }

  Future<bool> onbackpop() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Save note"),
          content: Text("Are you sure save this note?"),
          actions: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      onPressed: () {

                        Navigator.pop(context);

                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return firstpage();
                          },
                        ));
                      },
                      child: Text("Yes")),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"))
                ],
              ),
            )
          ],
        );
      },
    );
    return Future.value(true);
  }
}
