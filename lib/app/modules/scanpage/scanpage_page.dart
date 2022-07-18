import 'package:attendee/app/modules/home/scanning_page/scanning_page_page.dart';
import 'package:attendee/app/modules/list_page/list_page_page.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/providers/studrepo.dart';
import './scanpage_controller.dart';

class ScanpagePage extends GetView<ScanpageController> {
  ScanpagePage({Key? key}) : super(key: key);

  var res = 'Scan'.obs;
  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.put(StudentController());


    Future scanCode() async {
    var rest = await FlutterBarcodeScanner.scanBarcode(
        "#493e9c", "Cancel", true, ScanMode.BARCODE);
    res.value = rest;
                  var box = GetStorage();

                  var dummy = box.read('stu_list') ?? [];
                  var seen = false;

                  for (var i = 0; i < dummy.length; i++) {
                    if (dummy[i]['matno'].toString().toLowerCase() ==
                            res.value.toLowerCase() &&
                        dummy[i]["id"].toString().toLowerCase() ==
                            Get.arguments['id'].toString().toLowerCase()) {
                      //exit loop
                      seen = true;
                      break;
                    }
                  }
                  if (seen == true) {
                    Get.snackbar(
                      'Error',
                      'Student Already Present',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  } else {
                    Get.to(() => ScanningPagePage(), arguments: {
                      'res_val': res.value,
                      'id': Get.arguments["id"],
                      'title': Get.arguments["title"],
                      'date': Get.arguments["date"]
                    });
                    controller.getDetails();
                  }
  }

    return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[200],
          body: 
          
  
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
              ),
              Center(
                  child: InkWell(
                onTap: () => scanCode(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.width * 0.45,
                    color: Colors.deepPurple,
                    child: const Center(
                      child: Text(
                        'SCAN ID',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
              Obx(() {
                return Text(
                  res.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                );
              }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.26,
              ),
              const Text('ENTER MANUALLY',
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                 
                  decoration: InputDecoration(
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: 'ENTER MATNO',
                  ),
                  onChanged: (value) {
                    res.value = value;
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                child: Container(
                  color: Colors.deepPurple,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextButton(
  
    
                    onPressed: () {
                  var box = GetStorage();

                  var dummy = box.read('stu_list') ?? [];
                  var seen = false;

                  for (var i = 0; i < dummy.length; i++) {
                    if (dummy[i]['matno'].toString().toLowerCase() ==
                            res.value.toLowerCase() &&
                        dummy[i]["id"].toString().toLowerCase() ==
                            Get.arguments['id'].toString().toLowerCase()) {
                      //exit loop
                      seen = true;
                      break;
                    }
                  }
                  if (seen == true) {
                    Get.snackbar(
                      'Error',
                      'Student Already Present',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  } else {
                    Get.to(() => ScanningPagePage(), arguments: {
                      'res_val': res.value,
                      'id': Get.arguments["id"],
                      'title': Get.arguments["title"],
                      'date': Get.arguments["date"]
                    });
                    controller.getDetails();
                  }
                },
                child: const Text('SUBMIT',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    )),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
    
  }

  //create details List with StudDetails

  
}
