import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/widgets/appbar.dart';
import '../list_page/list_page_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  var box = GetStorage();



  var list = [];

  readNotes() {
    list = box.read('att_list') ?? [];
  }

  @override
  void initState() {
    readNotes();
    super.initState();
  }

  checkID() {
    if (box.read('cat_idtrack') == null) {
      box.write('cat_idtrack', 1);
      return box.read('cat_idtrack');
    } else {
      var c = box.read('cat_idtrack') + 1;
      box.write('cat_idtrack', c);
      return box.read('cat_idtrack');
    }

    // var currentid = box.read('cat_idtrack') + 1 ?? box.write('cat_idtrack', 1);
  }

  addtolist(String title) {
    if (title.isNotEmpty) {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      setState(() {
        readNotes();
        list.add({
          'id': checkID(),
          'title': title,
          'date': date.toString().replaceAll("00:00:00.000", ""),
        });
        box.write('att_list', list);
        Get.snackbar('Succesful', 'New Attendance Added');
        _titleController.text = '';
      });
    } else {
      Get.snackbar('Error', 'Please Enter Title');
    }
  }

  addnew() {
    list.add({
      'title': 'Title 2',
      'date': 'Tuesday, March 1st',
    });
  }

  addnewPop() {
    Get.dialog(
      AlertDialog(
        title: const Text('Add New'),
        content: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
          ),
        ),
        actions: [
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          FlatButton(
            child: const Text('Add'),
            onPressed: () {
              addtolist(
                _titleController.text,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          AttendBar(buttonClick: () {
            addnewPop();
          }),
          // addnew();
          // (() => Get.to((ScanpagePage())))),
          SizedBox(
            height: size.height * 0.05,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: (() => Get.to(() => const ListPagePage(), arguments: {
                      'id': list[index]['id'],
                      'title': list[index]['title'],
                      'date': list[index]['date'],
                    })),
                onLongPress: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete'),
                      content: const Text('Are you sure you want to delete this attendance?'),
                      actions: [
                        FlatButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        FlatButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            setState(() {
                              list.removeAt(index);
                              box.write('att_list', list);
                              Get.back();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
                
                trailing: const Icon(Icons.arrow_forward),
                title: Text(list[index]["title"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(list[index]["date"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          ))
        ],
      ),
    );
  }
}
