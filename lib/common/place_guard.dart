import 'package:flutter/material.dart';

class PlaceGuard extends StatelessWidget {
  final String name;
  final String time;
  final ImageProvider? image;

  const PlaceGuard({
    Key? key,
    required this.name,
    required this.time,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Color(0xBEBEBEBE),
                ),
              ),
              Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Color(0xBEBEBEBE)),
                  ),
                  Icon(
                    Icons.flip_camera_android_sharp,
                    size: 14,
                    color: Color(0xBEBEBEBE),
                  ),
                ],
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 14,
        ),
      ],
    );
  }
}
