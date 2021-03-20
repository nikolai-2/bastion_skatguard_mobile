import 'package:flutter/material.dart';

class UserBar extends StatelessWidget {
  final String name;
  final String jobTitle;
  final ImageProvider? image;

  const UserBar({
    Key? key,
    required this.name,
    required this.jobTitle,
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
                jobTitle,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        Spacer(),
        CircleAvatar(),
      ],
    );
  }
}
