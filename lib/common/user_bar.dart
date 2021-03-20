import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/service/user_manager.dart';

class UserBar extends StatelessWidget {
  final String jobTitle;
  final ImageProvider? image;

  const UserBar({
    Key? key,
    required this.jobTitle,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        context.watch<UserManager>().currentUser.valueWrapper?.value.user!;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 3),
                Text(
                  jobTitle,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  user!.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(user.avatar_src),
          ),
          onTap: () => context.read<UserManager>().logOut(),
        ),
      ],
    );
  }
}
