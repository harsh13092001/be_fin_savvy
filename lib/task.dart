import "package:flutter/material.dart";
import "package:ff_navigation_bar/ff_navigation_bar.dart";
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:date_format/date_format.dart';
import "package:be_fin_savvy/service/user.dart";
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:be_fin_savvy/service/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantity_input/quantity_input.dart';
import 'commission.dart';

class Task extends StatefulWidget {
  bool addTask;
  Task(this.addTask);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  void initState() {
    super.initState();
  }

  List<String> options = <String>['Status', 'complete', 'uncomplete', 'All'];
  String Status = 'Status';

  Widget taskList() {
    if (Status != "All" && Status != "Status") {
      return StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .document(Info.user_id)
              .collection("tasks")
              .where('Status', isEqualTo: Status)
              .orderBy("date")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TaskList(
                      snapshot.data.documents[index].data["Id"],
                      snapshot.data.documents[index].data["date"],
                      snapshot.data.documents[index].data["Status"],
                    );
                  });
            } else {
              return Container();
            }
          });
    } else {
      return StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .document(Info.user_id)
              .collection("tasks")
              .orderBy("date")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TaskList(
                      snapshot.data.documents[index].data["Id"],
                      snapshot.data.documents[index].data["date"],
                      snapshot.data.documents[index].data["Status"],
                    );
                  });
            } else {
              return Container();
            }
          });
    }
  }

  @override
  int selectedIndex = 1;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('BeFinSavvy'),
          backgroundColor: Color(0xFFDB50FF),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.library_add),
            backgroundColor: Color(0xFFFF00FB),
            onPressed: () {
              setState(() {
                widget.addTask = !widget.addTask;
              });
            }),
        body: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red[500],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.pink, Colors.blue, Colors.purple]),
                      ),
                      child: Icon(
                        Icons.emoji_people_outlined,
                        size: 50,
                        color: Colors.white,
                      )),
                  Column(
                    children: [
                      Text(
                        Info.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Text("Task Menu"),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Container(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.blue),
                  fillColor: Colors.purple[300],
                ),
                value: Status,
                onChanged: (String newValue) {
                  setState(() {
                    Status = newValue;
                  });
                },
                style: const TextStyle(color: Colors.blue),
                selectedItemBuilder: (BuildContext context) {
                  return options.map((String value) {
                    return Text(
                      Status,
                      style: const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            widget.addTask
                ? Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        color: Colors.grey[350],
                        padding: EdgeInsets.only(
                            left: 2, right: 2, bottom: 5, top: 5),
                        child: Column(
                          children: [
                            taskList(),
                            AddTask(),
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        color: Colors.grey[350],
                        padding: EdgeInsets.only(
                            left: 2, right: 2, bottom: 5, top: 5),
                        child: Column(
                          children: [
                            taskList(),
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        ),
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.black,
            selectedItemBorderColor: Color(0xFFFF00FB),
            selectedItemBackgroundColor: Colors.white,
            selectedItemIconColor: Colors.black,
            selectedItemLabelColor: Colors.white,
            barHeight: 70,
            itemWidth: 53,
          ),
          selectedIndex: selectedIndex,
          onSelectTab: (index) {
            if (index == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Commission()));
            } else if (index == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Task(false)));
            }
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            FFNavigationBarItem(
              iconData: Icons.monetization_on_rounded,
              label: 'commission guider',
            ),
            FFNavigationBarItem(
              iconData: Icons.work,
              label: 'Task',
            ),
          ],
        ),
      ),
    );
  }
}

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String _setDate;
  String Status, month;
  DatabaseMethods methods = new DatabaseMethods();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _taskController = TextEditingController();
  String _StatusController = 'complete';

  void initstate() {}
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;

        _dateController.text = DateFormat.yMd().format(selectedDate);
        Status = DateFormat.y().format(selectedDate);
        month = DateFormat.M().format(selectedDate);
      });
  }

  @override
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 1),
      child: Card(
        child: ExpansionTileCard(
          initiallyExpanded: true,
          key: cardA,
          leading: CircleAvatar(
            child: Icon(Icons.note_add),
            backgroundColor: Colors.white,
          ),
          title: Text(
            "ADD Task",
            style: TextStyle(color: Colors.black),
          ),
          children: <Widget>[
            Container(
              color: Colors.purpleAccent,
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(
                  left: 2,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "New Task",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            Divider(),
            Container(
              padding: EdgeInsets.only(
                left: 2,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "task"),
              controller: _taskController,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 2,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Day",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Row(children: [
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.height / 2.5,
                  height: MediaQuery.of(context).size.width / 9,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: _dateController.text.isEmpty ? 0 : 20),
                    textAlign: TextAlign.center,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _dateController,
                    onSaved: (String val) {
                      _setDate = val;
                    },
                    decoration: InputDecoration(
                        hintText: "Day",
                        disabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.only(top: 0.0)),
                  ),
                ),
              ),
              Icon(Icons.touch_app)
            ]),
            Container(
              padding: EdgeInsets.only(
                left: 2,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ToggleSwitch(
              initialLabelIndex: 0,
              minWidth: 150,
              minHeight: 50.0,
              cornerRadius: 20.0,
              totalSwitches: 2,
              iconSize: 30.0,
              fontSize: 18,
              activeBgColors: [
                [
                  Colors.pinkAccent[100],
                  Colors.lightBlueAccent,
                  Colors.purpleAccent
                ],
                [
                  Colors.pinkAccent[100],
                  Colors.lightBlueAccent,
                  Colors.purpleAccent
                ]
              ],
              labels: [
                'Complete',
                'Uncomplete',
              ],
              onToggle: (index) {
                if (index == 0) {
                  _StatusController = "complete";
                }
                ;
                if (index == 1) {
                  _StatusController = "uncomplete";
                }
                ;
              },
            ),
            ElevatedButton(
              child: Text(
                'Add Task',
                style: TextStyle(fontSize: 17.0),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.purpleAccent))),
              ),
              onPressed: () {
                Map<String, dynamic> task = new Map<String, dynamic>();
                task = {
                  "Id": _taskController.text,
                  "date": _dateController.text,
                  "Status": _StatusController,
                };
                methods.addTask(
                    Info.user_id, Status, month, task, _taskController.text);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Task(false)));
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final String task;
  final String date;

  final String Status;
  TaskList(this.task, this.date, this.Status);
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DatabaseMethods methods = new DatabaseMethods();
  Future<void> _showMyDialog(String year, String month, String task) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(" Do you want to delete or update Task?"))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                await methods.deleteTask(Info.user_id, year, month, task);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Task(true)));

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                _showDeleteDialog(year, month, task);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(String year, String month, String task) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(" Are you sure you want to delete it?"))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                methods.deleteTask(Info.user_id, year, month, task);

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  bool ok = false;
  int simpleIntInput = 0;
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[350],
        padding: EdgeInsets.fromLTRB(2, 0, 2, 1),
        child: Card(
          child: ExpansionTileCard(
              leading: Container(
                height: 80.0,
                width: 50.0,
              ),
              title: GestureDetector(
                onTap: () {
                  String replacedate = widget.date.replaceAll("/", " ");
                  final splitDate = replacedate.split(" ");
                  String month = splitDate[0];
                  String year = splitDate[2];
                  _showDeleteDialog(year, month, widget.task);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      "Date: " + widget.date,
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                    Text(
                      "Status: " + widget.Status,
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ],
                ),
              )),
        ));
  }
}
