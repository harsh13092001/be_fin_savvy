import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  addTask(String userid, String year, String month, taskmap, String task)async{
    await Firestore.instance.collection("users").document(userid).collection("tasks").document("${task}_${year}_${month}").setData(taskmap);
  }
  deleteTask(String userid, String year, String month, String task)async{
      print(month);
    await Firestore.instance.collection("users").document(userid).collection("tasks").document("${task}_${year}_${month}").delete();

  }
  updateTask(String userid, String year, String month, task)async{
    print(month);
    await Firestore.instance.collection("users").document(userid).collection("tasks").document("task_${year}_${month}").delete();
    await Firestore.instance.collection("users").document(userid).collection("tasks").document("task_${year}_${month}").setData(task);

  }
  addNetSales(var sales,String userid)async{
    await Firestore.instance.collection("users").document(userid).setData({"net sales":sales});

  }
}