import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/providers/studrepo.dart';
import '../../list_page/list_page_page.dart';
import 'scanning_page_controller.dart';

class ScanningPagePage extends GetView<ScanningPageController> {
  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.put(StudentController());

    addButton() {
      var box = GetStorage();
      var currentList = box.read('stu_list') ?? [];
      List newList = currentList;

      var data = {
        'name': controller.name.value,
        'matno': controller.matno.value,
        'id': Get.arguments['id'],
        'department': controller.department.value,
      };

        newList.add(data);
        box.write('stu_list', newList);
        Get.offAll(() => const ListPagePage(), arguments: {
          'title': Get.arguments['title'],
          'id': Get.arguments['id'],
          'date': Get.arguments['date'],
        });
      
    }

    // Uint8List bytes = base64.decode("${controller.image}");

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Obx(() {
          return Container(
            child: controller.isloading.value
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: LoadingAnimationWidget.beat(
                            color: Colors.deepPurple,
                            size: 200,
                          ),
                        ),
                        const Text(
                          'Fetching Details...',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Image.memory(
                            base64.decode(controller.image.split(',').last),
                            fit: BoxFit.contain,
                          ),
                        ),
                        //Show student details
                        const Text(
                          'STUDENT DETAILS',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),

                        // Student details card
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Table(
                              border: TableBorder.all(color: Colors.black),
                              children: [
                                TableRow(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(' NAME :',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(controller.name.value),
                                  ),
                                ]),
                                TableRow(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(' MAT NO :',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                        controller.matno.value.toUpperCase()),
                                  ),
                                ]),
                                TableRow(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(' DEPARTMENT :',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(controller.department.value),
                                  ),
                                ]),
                                TableRow(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(' PHONE NUMBER :',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(controller.phone.value),
                                  ),
                                ]),
                                // TABLE WIDGET WITH STUDENT controller
                              ]),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),

                        //cotainer button with deep purple color
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.deepPurple,
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextButton(
                              onPressed: () {
                                addButton();
                              },
                              child: const Text('ADD',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }));
  }
}
