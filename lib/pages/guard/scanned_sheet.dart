import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skatguard/dao/place.model.dart';
import 'package:skatguard/styles.dart';

class ScannedSheet extends StatefulWidget {
  final ZoneInfo zone;
  final TextEditingController controller;

  const ScannedSheet({
    Key? key,
    required this.zone,
    required this.controller,
  }) : super(key: key);
  @override
  _ScannedSheetState createState() => _ScannedSheetState();
}

class _ScannedSheetState extends State<ScannedSheet> {
  FocusNode focusNode = FocusNode();
  bool wasFocused = false;
  bool currentlyFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      wasFocused = true;
      if (focusNode.hasFocus != currentlyFocused) {
        setState(() => currentlyFocused = focusNode.hasFocus);
      }
    });
    Timer(Duration(seconds: 5), () {
      if (mounted && widget.controller.text.isEmpty && !wasFocused)
        Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

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
          SizedBox(height: 30),
          Text(
            widget.zone.name,
            style: titleStyle,
          ),
          SizedBox(height: 20),
          Expanded(
            flex: currentlyFocused ? 2 : 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: widget.controller,
                focusNode: focusNode,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                  hintText: 'Введите примечание...',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: LayoutBuilder(
              builder: (ctx, cnstr) => cnstr.maxHeight < 60
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Image.asset(
                          'assets/blue_ok.png',
                          height: 240,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
