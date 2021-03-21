import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/common/date_row.dart';
import 'package:skatguard/common/user_bar.dart';
import 'package:skatguard/dao/checkup.dart';
import 'package:skatguard/dao/checkup.model.dart';
import 'package:skatguard/dao/place.model.dart';
import 'package:skatguard/pages/guard/error_sheet.dart';
import 'package:skatguard/service/nfc.dart';
import 'package:skatguard/service/nfc_service.dart';
import 'package:skatguard/styles.dart';

import 'report_sheet.dart';
import 'scanned_sheet.dart';

class GuardPage extends StatefulWidget {
  @override
  _GuardPageState createState() => _GuardPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _GuardPageState extends State<GuardPage> {
  DateTime selectedDate = DateTime.now();
  List<PlaceInfo> reportsSent = [];

  Widget card(CheckupInfo info) {
    final place = info.place!;
    final time = timeToCurrentDay(info.date);
    final completed = info.shiftZone!.map((e) => e.zone_id).toSet().length >=
        info.place!.zone.length;

    final inProgress = !completed && time.isBefore(DateTime.now());
    final shifts = [...info.shiftZone!];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20)
            .copyWith(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  place.name,
                  style: titleStyle.copyWith(),
                ),
                SizedBox(width: 6),
                if (completed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: SvgPicture.asset(
                      'assets/checkout_ok.svg',
                      height: 14,
                    ),
                  )
                else if (inProgress)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: SvgPicture.asset(
                      'assets/checkout_in_progress.svg',
                      height: 14,
                    ),
                  ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    '${time.hour}:${time.minute}',
                    style: TextStyle(
                      color: () {
                        if (completed) return Color(0xFF02CD98);
                        if (inProgress) return Color(0xFFFFC700);
                        return null;
                      }(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final zone in place.zone)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Builder(
                      builder: (ctx) {
                        final shift = info.shiftZone!
                            .cast<ShiftZone?>()
                            .firstWhere((e) => e!.zone_id == zone.id,
                                orElse: () => null);
                        shifts.remove(shift);
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  zone.name,
                                  style: greyStyle,
                                ),
                                SizedBox(width: 5),
                                if (shift != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: SvgPicture.asset(
                                      'assets/zone_ok.svg',
                                      height: 8,
                                    ),
                                  ),
                              ],
                            ),
                            if (shift != null && shift.comment.isNotEmpty)
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  shift.comment,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.grey.shade400),
                                ),
                              ),
                            SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                  ),
                if (completed) ...[
                  SizedBox(height: 2),
                  SizedBox(
                    height: 32,
                    child: Center(
                      child: TextButton(
                        onPressed: reportsSent.contains(place)
                            ? null
                            : () {
                                showReportBottomSheet(place);
                                reportsSent.add(place);
                                setState(() {});
                              },
                        child: Text('Сформировать отчет'),
                      ),
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  bool bottomSheetShowed = false;
  Future<String?> showBottomSheet(ZoneInfo zone) async {
    if (bottomSheetShowed) return null;
    bottomSheetShowed = true;
    final controller = TextEditingController();
    try {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => ScannedSheet(
          controller: controller,
          zone: zone,
        ),
      );
      final text = controller.text;
      if (text.isNotEmpty) {
        return text;
      }
    } finally {
      bottomSheetShowed = false;
    }
    return null;
  }

  Future<void> showErrorSheet([bool notInTime = false]) async {
    if (bottomSheetShowed) return null;
    bottomSheetShowed = true;
    try {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => ErrorSheet(
          notInGroup: notInTime,
        ),
      );
    } finally {
      bottomSheetShowed = false;
    }
    return null;
  }

  Future<String?> showReportBottomSheet(PlaceInfo place) async {
    if (bottomSheetShowed) return null;
    bottomSheetShowed = true;
    final controller = TextEditingController();
    try {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => ReportSheet(
          controller: controller,
          place: place,
        ),
      );
      final text = controller.text;
      if (text.isNotEmpty) {
        return text;
      }
    } finally {
      bottomSheetShowed = false;
    }
    return null;
  }

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    refresh();
    subscription = context.read<NfcService>().onTag.listen(onNfc);
  }

  DateTime timeToCurrentDay(DateTime source) {
    final now = selectedDate;
    return DateTime(now.year, now.month, now.day, source.toLocal().hour,
        source.toLocal().minute);
  }

  Future<void> onNfc(NfcTag tag) async {
    final info = this.info;
    if (info == null || bottomSheetShowed) return;
    final id = nfcToId(tag);
    ZoneInfo? foundZone;
    CheckupInfo? checkupInfo;
    bool outdated = false;
    final dao = context.read<CheckupDao>();
    for (final i in info) {
      final currentDateWithTime = timeToCurrentDay(i.date);
      for (final z in i.place!.zone) {
        if (z.id == id) {
          checkupInfo = i;
          foundZone = z;
          outdated = currentDateWithTime.isAfter(DateTime.now());
          break;
        }
        if (foundZone != null) break;
      }
    }
    if (foundZone == null || checkupInfo == null) {
      await showErrorSheet();
      return;
    }
    if (outdated) {
      await showErrorSheet(true);
      return;
    }
    final comment = await showBottomSheet(foundZone);
    await dao.checked(checkupInfo.id, foundZone.id, comment ?? '');
    refresh();
  }

  List<CheckupInfo>? info;

  Future<void> refresh() async {
    final checkupDao = context.read<CheckupDao>();
    final list = await checkupDao.getList(selectedDate);
    if (mounted) {
      setState(() => info = list);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: _SliverAppBarDelegate(
                maxHeight: 110,
                minHeight: 110,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: UserBar(
                          jobTitle: 'Охранник',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                maxHeight: 76,
                minHeight: 76,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        child: LayoutBuilder(
                          builder: (ctx, cnstr) => DateRow(
                            width: cnstr.maxWidth,
                            selectedDate: selectedDate,
                            onDateSelected: (date) {
                              setState(() => selectedDate = date);
                              refresh();
                            },
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        color: Theme.of(context).canvasColor,
                        height: 2,
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (info == null)
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => card(info![i]),
                  childCount: info!.length,
                ),
              )
          ],
        ),
      ),
    );
  }
}
