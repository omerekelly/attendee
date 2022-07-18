import 'package:flutter/material.dart';

class AttendBar extends StatelessWidget {
  //create constructors

  final VoidCallback? buttonClick;

  const AttendBar({Key? key, required this.buttonClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(child: Image.asset('assets/b.jpeg', height: 80)),
              const SizedBox(
                width: 95,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.deepPurple,
                  child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () {
                        buttonClick?.call();
                      }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
