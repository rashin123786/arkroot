import 'dart:developer';

import 'package:arkroot_to_do/core/Model/to_do_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiServices {
  final listCollection = FirebaseFirestore.instance.collection("todo");
  final lengthCollection = FirebaseFirestore.instance.collection("length");
  // ===== Add Toddo===========>

  void addList(TodoModel todoModel) async {
    listCollection.add({
      "title": todoModel.title,
      "description": todoModel.description,
      "datetime": todoModel.dateTime,
      "isCheck": todoModel.isCompleted,
    });
  }

  // ======= List Todo============>
  Stream<List<TodoModel>> getTodoList() {
    return listCollection.snapshots().map((event) {
      return event.docs.map((e) {
        return TodoModel.fromjson(e.data(), e.id);
      }).toList();
    });
  }

  // ===== Update List========>
  void UpdateList(TodoModel todoModel, String documentId) async {
    listCollection.doc(documentId).update({
      "title": todoModel.title,
      "description": todoModel.description,
      "datetime": todoModel.dateTime,
      "isCheck": todoModel.isCompleted,
    });
  }

  void deleteList(String id) {
    listCollection.doc(id).delete();
  }

  void updateIsCompleted(String id, bool isCompleted) {
    listCollection.doc(id).update({
      "isCheck": isCompleted,
    });
  }
}
