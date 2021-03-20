import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlarmSheet extends StatefulWidget {
  AlarmSheet({Key? key}) : super(key: key);

  @override
  _AlarmSheetState createState() => _AlarmSheetState();
}

class _AlarmSheetState extends State<AlarmSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                itemBuilder: (ctx, i) => AlarmItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlarmItem extends StatefulWidget {
  @override
  _AlarmItemState createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> with TickerProviderStateMixin {
  bool expanded = false;
  late AnimationController controller;

  bool isSwitched = false;
  bool isEnabled = false;

  void changeExpand() {
    setState(() => expanded = !expanded);
    if (expanded) {
      controller.animateTo(1);
    } else {
      controller.animateTo(0);
    }
  }

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  Widget topPart() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 25, right: 15),
              child: CircleAvatar(
                radius: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '11:30',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Жмышенко В.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 20),
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(
                    () {
                      isSwitched = value;
                    },
                  );
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 15),
              child: Text(
                'Каждый день',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: RotationTransition(
                turns: Tween<double>(begin: 0, end: 3.5).animate(controller),
                child: Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 30,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 10),
          child: Text(
            '11:30',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                ),
                onPressed: () {},
                child: Text(
                  'Пн',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                ),
                onPressed: () {},
                child: Text(
                  'Вт',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                ),
                onPressed: () {},
                child: Text(
                  'Ср',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                ),
                onPressed: () {},
                child: Text(
                  'Чт',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                ),
                onPressed: () {},
                child: Text(
                  'Пт',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                ),
                onPressed: () {},
                child: Text(
                  'Сб',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                ),
                onPressed: () {},
                child: Text(
                  'Вс',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.grey.shade600,
                  size: 30,
                ),
                label: Text(
                  'Сменить сотрудника',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check_box_outlined,
                    color: Colors.grey.shade600,
                    size: 30,
                  ),
                  label: Text(
                    'Повтор',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outline,
              color: Colors.grey.shade600,
              size: 30,
            ),
            label: Text(
              'Удалить',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        color: Colors.white,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: changeExpand,
            child: Column(
              children: [
                topPart(),
                AnimatedSize(
                  vsync: this,
                  alignment: Alignment.topCenter,
                  duration: Duration(milliseconds: 100),
                  child: Container(
                    height: expanded ? null : 0,
                    child: bottomPart(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
