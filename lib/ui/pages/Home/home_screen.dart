import 'dart:developer';

import 'package:arkroot_to_do/core/provider/bottom_sheet_provider.dart';
import 'package:arkroot_to_do/core/services/api_services.dart';
import 'package:arkroot_to_do/core/services/bottom_sheet_services.dart';
import 'package:arkroot_to_do/ui/shared/widget/home_widget.dart';
import 'package:arkroot_to_do/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int documentLength = 0;
  int ys = 0;
  bool isLoading = true;
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isTap = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.4),
        child: AppBar(
          backgroundColor: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    elevation: 1,
                    child: SizedBox(
                      width: width * 0.65,
                      height: height * 0.13,
                      child: CupertinoTextField(
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: "Search...",
                        padding: const EdgeInsets.all(5),
                        prefix: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.rocket_launch_sharp,
                            color: Colors.red,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(38, 38, 38, 1),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // FirebaseFirestore.instance.collection("demo").add({
                      //   "title": "namess",
                      //   "descritption": "..............."
                      // });
                      scaffoldKey.currentState!;
                      BottomSheetServices().bottomShow(context, false);

                      // _showSheet();
                    },
                    icon: const Text(
                      "Add",
                    ),
                    label: const Icon(Icons.add_circle_outline),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1E6F9F)),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: ApiServices().getTodoList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.isEmpty
                        ? emptyList()
                        : ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              ys = snapshot.data!.length;
                              final data = snapshot.data![index];

                              return ListTile(
                                title: Text(
                                  data.title,
                                  style: TextStyle(
                                    decoration: data.isCompleted == true
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(175, 175, 175, 1),
                                      ),
                                    ),
                                    Text(
                                      data.dateTime,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(175, 175, 175, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 60,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          print("${data.documentId}");
                                          BottomSheetServices().bottomShow(
                                              context,
                                              true,
                                              data.title,
                                              data.description,
                                              data.dateTime,
                                              data.documentId);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 24,
                                        ),
                                      ),
                                      sizedBoxW10,
                                      GestureDetector(
                                        onTap: () {
                                          ApiServices()
                                              .deleteList(data.documentId!);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 24,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                leading: GestureDetector(
                                  onTap: () {
                                    if (data.isCompleted == false) {
                                      ApiServices().updateIsCompleted(
                                          data.documentId!, true);
                                      Fluttertoast.showToast(
                                          msg: "Task Completed:)",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      ApiServices().updateIsCompleted(
                                          data.documentId!, false);
                                      Fluttertoast.showToast(
                                          msg: "Task is Pending:)",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: data.isCompleted == true
                                        ? Color(0xFF1E6F9F)
                                        : Color.fromRGBO(51, 51, 51, 1),
                                  ),
                                ),
                              );
                            });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Center(
                      child: Text("Something went Wrong"),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
