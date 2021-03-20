import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:skatguard/common/date_row.dart';
import 'package:skatguard/common/user_bar.dart';
import 'package:skatguard/styles.dart';

class GuardPage extends StatefulWidget {
  @override
  _GuardPageState createState() => _GuardPageState();
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
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            SizedBox(height: 30),
            SizedBox(
              height: 60,
              child: LayoutBuilder(
                builder: (ctx, cnstr) => DateRow(
                  width: cnstr.maxWidth,
                  selectedDate: selectedDate,
                  onDateSelected: (date) => setState(() => selectedDate = date),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, i) => card(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
