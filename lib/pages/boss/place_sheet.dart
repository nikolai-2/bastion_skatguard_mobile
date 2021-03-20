import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skatguard/styles.dart';

class PlaceSheet extends StatefulWidget {
  @override
  _PlaceSheetState createState() => _PlaceSheetState();
}

class _PlaceSheetState extends State<PlaceSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          SvgPicture.asset(
            'assets/arrow_down.svg',
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: TextField(
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Введите название объекта...',
                  hintStyle: TextStyle(color: Colors.grey.shade400)),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.circle),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Новая зона',
                  hintStyle: TextStyle(color: Colors.grey.shade400)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_right_alt,
                  color: Colors.grey.shade400,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Отсканируйте новую зону ',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 70,
            child: Material(
              color: Colors.white,
              type: MaterialType.transparency,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          color: Color(0xFF00B2FF),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.person),
                          color: Color(0xFF00B2FF),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.arrow_circle_up_outlined),
                          color: Color(0xFF00B2FF),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
