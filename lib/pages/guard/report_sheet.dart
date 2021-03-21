import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skatguard/dao/place.model.dart';
import 'package:skatguard/styles.dart';

class ReportSheet extends StatefulWidget {
  final PlaceInfo place;
  final TextEditingController controller;

  const ReportSheet({
    Key? key,
    required this.place,
    required this.controller,
  }) : super(key: key);
  @override
  _ReportSheetState createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
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
            widget.place.name,
            style: titleStyle,
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: widget.controller,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                  hintText: 'Введите отчет...',
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
