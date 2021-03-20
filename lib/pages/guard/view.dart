import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:skatguard/common/date_row.dart';
import 'package:skatguard/common/user_bar.dart';
import 'package:skatguard/pages/guard/scanned_sheet.dart';
import 'package:skatguard/styles.dart';

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

  Widget card() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Галерея',
                  style: titleStyle,
                ),
                Spacer(),
                Text('18:30'),
              ],
            ),
            SizedBox(height: 6),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final s in ['Adidas', 'Nike', 'Balenciaga', 'МВидео'])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      s,
                      style: greyStyle,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool bottomSheetShowed = false;
  void showBottomSheet() async {
    if (bottomSheetShowed) return;
    bottomSheetShowed = true;
    try {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => ScannedSheet(),
      );
    } finally {
      bottomSheetShowed = false;
    }
  }

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        print(tag);
        showBottomSheet();
      },
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
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
                maxHeight: 120,
                minHeight: 120,
                child: GestureDetector(
                  onTap: () => showBottomSheet(),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: UserBar(
                            name: 'Береговский Илья',
                            jobTitle: 'Начальник охраны',
                          ),
                        ),
                      ],
                    ),
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
                            onDateSelected: (date) =>
                                setState(() => selectedDate = date),
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
            SliverList(delegate: SliverChildBuilderDelegate((ctx, i) => card()))
          ],
        ),
      ),
    );
  }
}
