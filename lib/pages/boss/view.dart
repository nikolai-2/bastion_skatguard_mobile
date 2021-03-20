import 'package:flutter/material.dart';
import 'package:skatguard/common/user_bar.dart';
import 'package:skatguard/common/place_guard.dart';
import 'package:skatguard/pages/boss/place_sheet.dart';
import 'package:skatguard/styles.dart';

class BossPage extends StatefulWidget {
  BossPage({Key? key}) : super(key: key);

  @override
  _BossPageState createState() => _BossPageState();
}

class _BossPageState extends State<BossPage> {
  static const list = [
    'Adidas',
    'Nike',
    'Balenciaga',
    'МВидео',
    'Adidas',
  ];
  static const maxCardItems = 4;

  _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 20,
        ),
        child: PlaceSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child:
                  UserBar(name: 'Никита Ривийский', jobTitle: 'Миддл Сеньор'),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 200,
                  ),
                  itemBuilder: (ctx, i) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.all(5),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _showModalBottomSheet,
                        child: Padding(
                            padding: EdgeInsets.all(18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Галерея',
                                  style: titleStyle,
                                ),
                                SizedBox(height: 10),
                                for (var i = 0;
                                    i < maxCardItems && i < list.length;
                                    i++)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      i == maxCardItems - 1 && list.length > 4
                                          ? '${list[i]}...'
                                          : list[i],
                                      style: greyStyle,
                                    ),
                                  ),
                                SizedBox(height: 10),
                                PlaceGuard(
                                    name: 'Никита Р.', time: 'Пт 16:30 '),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModalBottomSheet,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF00B2FF),
      ),
    );
  }
}
