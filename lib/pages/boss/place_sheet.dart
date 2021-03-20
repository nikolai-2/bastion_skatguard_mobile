import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';

class PlaceSheet extends StatefulWidget {
  @override
  _PlaceSheetState createState() => _PlaceSheetState();
}

class _PlaceSheetState extends State<PlaceSheet> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        controllers.add(TextEditingController());
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  void addController() {}

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
          SizedBox(height: 5),
          Expanded(
            child: ListView(
              children: [
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
                for (final controller in controllers)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.link,
                                  size: 16,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Новая зона',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400)),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline,
                              color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              controllers.remove(controller);
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((timeStamp) {
                                controller.dispose();
                              });
                            });
                          },
                        ),
                      ],
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
                          'Отсканируйте новую зону',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            child: Material(
              color: Colors.white,
              type: MaterialType.transparency,
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          color: Color(0xFF00B2FF),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                        SizedBox(width: 25),
                        IconButton(
                          icon: Icon(Icons.person),
                          color: Color(0xFF00B2FF),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.arrow_circle_down),
                          color: Color(0xFF00B2FF),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
