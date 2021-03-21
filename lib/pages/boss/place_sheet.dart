import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

import 'package:skatguard/common/sheet_result.dart';
import 'package:skatguard/dao/auth.model.dart';
import 'package:skatguard/dao/checkup.model.dart';
import 'package:skatguard/dao/place.model.dart';
import 'package:skatguard/pages/boss/alarm_sheet.dart';
import 'package:skatguard/service/nfc.dart';
import 'package:skatguard/service/nfc_service.dart';

class ZoneDto {
  String name;
  String id;

  ZoneDto(this.name, this.id);
}

class PlaceSheetResult {
  List<CheckupInfo> scheduleShiftPattern;
  List<ZoneDto> zones;
  String placeName;

  PlaceSheetResult({
    required this.scheduleShiftPattern,
    required this.zones,
    required this.placeName,
  });
}

class PlaceSheet extends StatefulWidget {
  final ExtendedPlaceInfo? placeInfo;
  final BuildContext rootContext;
  final List<User> guards;
  final SheetResult<PlaceSheetResult> resultHost;

  PlaceSheet({
    Key? key,
    required this.placeInfo,
    required this.rootContext,
    required this.guards,
    required this.resultHost,
  }) : super(key: key);

  @override
  _PlaceSheetState createState() => _PlaceSheetState();
}

class _PlaceSheetState extends State<PlaceSheet> {
  List<TextEditingController> controllers = [];
  TextEditingController titleController = TextEditingController();
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    widget.resultHost.value = PlaceSheetResult(
      scheduleShiftPattern: [...(widget.placeInfo?.scheduleShiftPattern ?? [])],
      placeName: widget.placeInfo?.name ?? '',
      zones: widget.placeInfo?.zone
              .map(
                (e) => ZoneDto(e.name, e.id),
              )
              .toList() ??
          <ZoneDto>[],
    );

    titleController.text = widget.resultHost.value?.placeName ?? '';
    for (final zone in widget.resultHost.value?.zones ?? <ZoneDto>[]) {
      controllers.add(TextEditingController(text: zone.name));
    }
    subscription = context.read<NfcService>().onTag.listen(addTag);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> _showModalBottomSheet() async {
    final result = SheetResult<List<CheckupInfo>>();
    await showModalBottomSheet<void>(
      context: widget.rootContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(widget.rootContext).viewPadding.top + 20,
        ),
        child: AlarmSheet(
          scheduleShiftPattern: widget.resultHost.value!.scheduleShiftPattern,
          rootContext: widget.rootContext,
          guards: widget.guards,
          resultHost: result,
        ),
      ),
    );
    widget.resultHost.value!.scheduleShiftPattern = result.value!;
  }

  Future<void> addTag(NfcTag tag) async {
    widget.resultHost.value!.zones = List.unmodifiable(
        [...widget.resultHost.value!.zones, ZoneDto('', nfcToId(tag))]);
    controllers.add(TextEditingController());
    setState(() {});
  }

  Widget zoneRow(TextEditingController controller, ZoneDto zone) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (s) => zone.name = s,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.link,
                    size: 16,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Новая зона',
                  hintStyle: TextStyle(color: Colors.grey.shade400)),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
            onPressed: () {
              setState(() {
                controllers.remove(controller);
                widget.resultHost.value!.zones = List.unmodifiable([
                  ...widget.resultHost.value!.zones.where((z) => z != zone)
                ]);
                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  controller.dispose();
                });
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    controller: titleController,
                    onChanged: (s) => widget.resultHost.value!.placeName = s,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Введите название объекта...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                for (var i = 0; i < controllers.length; i++)
                  zoneRow(controllers[i], widget.resultHost.value!.zones[i]),
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
                          onPressed: _showModalBottomSheet,
                        ),
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
