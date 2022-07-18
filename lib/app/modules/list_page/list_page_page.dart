import 'dart:io';

import 'package:attendee/app/core/config/config.dart';
import 'package:attendee/app/modules/scanpage/scanpage_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Stack;

import '../../core/widgets/appbar.dart';
import '../../data/providers/studrepo.dart';
import '../home/home_page.dart';

class ListPagePage extends StatefulWidget {
  const ListPagePage({Key? key}) : super(key: key);

  @override
  State<ListPagePage> createState() => _ListPagePageState();
}

class _ListPagePageState extends State<ListPagePage> {
  var box = GetStorage();

  var list = [];

  getStudents() {
    var newlist = box.read('stu_list') ?? [];

    for (var i = 0; i < newlist.length; i++) {
      var data = {
        'name': newlist[i]['name'],
        'matno': newlist[i]['matno'],
        'id': newlist[i]['id'],
        "deleteid": i,
        'department': newlist[i]['department'],
      };

      if (newlist[i]['id'] == Get.arguments['id']) {
        setState(() {
          list.add(data);
        });
      }
    }
  }

  deleteStudent(int deleteID) {
    var anewlist = box.read('stu_list');
    anewlist.removeAt(deleteID);
    box.write('stu_list', anewlist);

    setState(() {
      list.removeWhere((item) => item["deleteid"] == deleteID);
      setState(() {});
    });
  }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.put(StudentController());
    bool displayAction = false;
    var isaction = true;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: size.height * Config.AppBarSpace,
            ),
            AttendBar(buttonClick: () {
              Get.to(() => ScanpagePage(), arguments: {
                'id': Get.arguments['id'],
                'title': Get.arguments['title'],
                'date': Get.arguments['date'],
              });
            }),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Get.arguments['title'].toString().toUpperCase(),
                    style: const TextStyle(fontSize: 30),
                  ),
                  Text(
                    Get.arguments['date'],
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {},
                    onLongPress: () {
                      Get.dialog(AlertDialog(
                        title: const Text("Delete"),
                        content: const Text(
                            "Are you sure you want to delete this student?"),
                        actions: [
                          FlatButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              deleteStudent(list[index]["deleteid"]);
                              Get.back();
                            },
                          ),
                          FlatButton(
                            child: const Text("No"),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ],
                      ));
                    },
                    selectedTileColor: Colors.deepPurple,
                    leading: Text((index + 1).toString()),
                    title: Text(list[index]["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${list[index]["name"]} | ${list[index]["matno"].toString().toUpperCase()}',
                    ));
              },
              itemCount: list.length,
            )),
          ],
        ),
        //two floatingaction buttons at the bottom of the page
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Obx(() {
          return Stack(
            children: [
              Positioned(
                bottom: 140,
                right: 0,
                child: AnimatedOpacity(
                  opacity: controller.isdisplayed.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.deepPurple,
                    onPressed: () {
                      controller.isdisplayed.value ? exportListToExcel() : null;
                    },
                    child:

                        // Icon(Icons.file_download),
                        const Icon(Icons.file_download),
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                right: 0,
                child: AnimatedOpacity(
                  opacity: controller.isdisplayed.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.deepPurple,
                    onPressed: () {
                      controller.isdisplayed.value
                          ? Get.to(() => const HomePage())
                          : null;
                    },
                    child:

                        // Icon(Icons.file_download),
                        const Icon(Icons.home),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.deepPurple,
                  onPressed: () {
                    controller.showActions();
                  },
                  child: controller.isaction.value
                      ? const Icon(Icons.add)
                      : const Icon(Icons.close),
                ),
              ),
            ],
          );
        }));
  }

// get ios document directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // get android external storage directory
  Future<String> get _localPath_android async {
    final directory2 = await getExternalStorageDirectory();

    return directory2!.path;
  }

  exportListToExcel() async {
    //check if permission is granted to write to external storage
    if (await Permission.storage.request().isGranted) {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Name');
      sheet.getRangeByName('B1').setText('Matriculation Number');
      sheet.getRangeByName('C1').setText('Department');

      for (var i = 0; i < list.length; i++) {
        sheet.getRangeByName('A${i + 2}').setText(list[i]["name"]);
        sheet
            .getRangeByName('B${i + 2}')
            .setText(list[i]["matno"].toString().toUpperCase());
        sheet.getRangeByName('C${i + 2}').setText(list[i]["department"]);
      }
      final List<int> bytes = workbook.saveAsStream();

      String pathz;
      if (Platform.isIOS) {
        pathz = await _localPath;
      } else {
        pathz = await _localPath_android;
      }
      try {
        File("$pathz/${Get.arguments["title"]}-${Get.arguments["date"]}.xlsx")
            .writeAsBytes(bytes);
      } catch (e) {
        print(e);
      }
      Get.snackbar(
        'Success',
        'List exported to Excel',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check),
      );
//Dispose the workbook.
      workbook.dispose();
    } else {
      Permission.storage.request();
    }
  }
}
