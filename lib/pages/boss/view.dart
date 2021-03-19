import 'package:flutter/material.dart';

class BossPage extends StatefulWidget {
  BossPage({Key? key}) : super(key: key);

  @override
  _BossPageState createState() => _BossPageState();
}

class _BossPageState extends State<BossPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              color: Color(0xFF00B2FF),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://www.liga.net/images/general/2019/02/14/20190214174619-9721.png',
                        ),
                      ),
                      Text(
                        'Жмышенко Валерий Альбертович',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF00B2FF),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new), label: 'Игорь лох'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined), label: 'Вадик лох'),
        ],
      ),
    );
  }
}
