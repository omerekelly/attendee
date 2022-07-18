import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/studModel.dart';

class StudentController extends GetxController {
  var isloading = true.obs;
  var isaction = true.obs;
  var isdisplayed = false.obs;
  var name = ''.obs;
  var matno = ''.obs;
  var phone = ''.obs;
  var department = ''.obs;
  var email = ''.obs;
  var faculty = ''.obs;
  var address = ''.obs;
  var image = ''.obs;

  showActions() {
    isaction.value = !isaction.value;
    isdisplayed.value = !isdisplayed.value;
  }

  Future getDetails() async {
    isloading.value = true;
    var url =
        'https://biuapiv1.herokuapp.com/details?matno=${Get.arguments["res_val"]}';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'matno': Get.arguments['res_val'].toString(),
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar(
        'Student Details',
        'Successfully fetched details',
        icon: const Icon(Icons.check),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      StudDetails details = StudDetails.fromJson(json.decode(response.body));
      name.value = details.name;
      matno.value = details.matNo;
      email.value = details.email;
      department.value = details.department;
      faculty.value = details.faculty;
      phone.value = details.phone;
      image.value = details.image;
      address.value = details.address;
      isloading.value = false;
    } else if (response.statusCode == 404) {
      Get.back();
      print(Get.arguments['res_val']);
      Get.snackbar('Error', 'Invalid Mat Number',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
