import 'dart:developer';

import 'package:arkroot_to_do/core/Model/to_do_model.dart';
import 'package:arkroot_to_do/core/provider/bottom_sheet_provider.dart';
import 'package:arkroot_to_do/core/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BottomSheetServices {
  // ========== Show Bottom Sheet ===============>

  void bottomShow(BuildContext context, bool isEdit,
      [String? title,
      String? description,
      String? dateTime,
      String? documentId]) {
    TextEditingController titleController =
        TextEditingController(text: isEdit == true ? title : '');
    TextEditingController descriptionController =
        TextEditingController(text: isEdit == true ? description : '');
    final bottomProvider =
        Provider.of<BottomSheetController>(context, listen: false);
    if (isEdit == true) {
      bottomProvider.formattedDate = dateTime!;
      log(bottomProvider.formattedDate!);
    }

    final height = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: height * 0.7,
            decoration: BoxDecoration(color: Color.fromRGBO(38, 38, 38, 1)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit == true ? "Edit Task" : "Add Task",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: 'Title...',
                          border: OutlineInputBorder(borderSide: BorderSide())),
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Description...',
                        border: OutlineInputBorder(borderSide: BorderSide())),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => showDate(context, bottomProvider),
                          icon: Icon(
                            Icons.timer,
                          )),
                      Consumer<BottomSheetController>(
                          builder: (context, value, child) {
                        if (isEdit == false) {
                          bottomProvider.formattedDate =
                              DateFormat('dd MMMM yyyy')
                                  .format(bottomProvider.dateTime);
                        } else {}
                        return Text(bottomProvider.formattedDate.toString());
                      }),
                      Spacer(),
                      IconButton(
                          onPressed: () async {
                            TodoModel todoModel = await TodoModel(
                              dateTime: bottomProvider.formattedDate!,
                              description: descriptionController.text,
                              title: titleController.text,
                              isCompleted: false,
                            );
                            isEdit == true
                                ? ApiServices()
                                    .UpdateList(todoModel, documentId!)
                                : ApiServices().addList(todoModel);
                            titleController.clear();
                            descriptionController.clear();
                            Fluttertoast.showToast(
                                msg: "Task Added Successfully:)",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          icon: Icon(Icons.send))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
    );
  }

// ===============Show Date================>

  void showDate(context, BottomSheetController bottomSheetController) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2025))
        .then((value) {
      log(value.toString());
      bottomSheetController.updateDate(value!);
    });
  }
}
