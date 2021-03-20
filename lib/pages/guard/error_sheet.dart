import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:skatguard/styles.dart';

class ErrorSheet extends StatefulWidget {
  final bool notInGroup;

  const ErrorSheet({
    Key? key,
    this.notInGroup = false,
  }) : super(key: key);

  @override
  _ErrorSheetState createState() => _ErrorSheetState();
}

class _ErrorSheetState extends State<ErrorSheet> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
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
          SizedBox(height: 50),
          Text(
            'Ошибка сканирования',
            style: titleStyle,
          ),
          if (widget.notInGroup) ...[
            SizedBox(height: 10),
            Text(
              'Метка принадлежит другой группе',
              style: titleStyle,
            ),
          ],
          Expanded(
            flex: 1,
            child: LayoutBuilder(
              builder: (ctx, cnstr) => cnstr.maxHeight < 60
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Image.asset(
                          'assets/red_wrong.png',
                          height: 240,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
