import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/common/sheet_result.dart';
import 'package:skatguard/common/user_bar.dart';
import 'package:skatguard/common/place_guard.dart';
import 'package:skatguard/dao/auth.model.dart';
import 'package:skatguard/dao/place.dart';
import 'package:skatguard/dao/place.model.dart';
import 'package:skatguard/dao/schedule.dart';
import 'package:skatguard/dao/user.dart';
import 'package:skatguard/pages/boss/place_sheet.dart';
import 'package:skatguard/styles.dart';

class BossPage extends StatefulWidget {
  BossPage({Key? key}) : super(key: key);

  @override
  _BossPageState createState() => _BossPageState();
}

class _BossPageState extends State<BossPage> {
  static const maxCardItems = 4;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  List<ExtendedPlaceInfo>? info;
  List<User>? guards;
  Future<void> refresh() async {
    final checkupDao = context.read<PlaceDao>();
    final userDao = context.read<UserDao>();
    final list = await checkupDao.getList();
    final guards = await userDao.getByRole();
    if (mounted) {
      setState(() {
        info = list;
        this.guards = guards;
      });
    }
  }

  _showModalBottomSheet(ExtendedPlaceInfo? placeInfo) async {
    final result = SheetResult<PlaceSheetResult>();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 20,
        ),
        child: PlaceSheet(
          placeInfo: placeInfo,
          rootContext: context,
          guards: guards!,
          resultHost: result,
        ),
      ),
    );

    final placeDao = context.read<PlaceDao>();
    final val = result.value!;

    int placeId;
    if (placeInfo == null) {
      placeId = await placeDao.create(val.placeName, val.zones);
    } else {
      await placeDao.update(placeInfo.id, val.placeName, val.zones);
      placeId = placeInfo.id;
    }

    final scheduleDao = context.read<ScheduleDao>();
    final patternsById = placeInfo?.scheduleShiftPattern
            .asMap()
            .map((key, value) => MapEntry(value.id, value)) ??
        {};

    for (var i = 0; i < val.scheduleShiftPattern.length; i++) {
      final c = val.scheduleShiftPattern[i];
      if (c.id == -1) {
        final id = await scheduleDao.create(
          c.user_id,
          placeId,
          c.date,
          c.repeatWhen,
        );
        val.scheduleShiftPattern[i] =
            val.scheduleShiftPattern[i].copyWith(id: id);
      } else {
        final existed = patternsById[c.id];
        if (existed == null) continue;
        if (existed != c) {
          await scheduleDao.update(
            c.id,
            c.user_id,
            c.place_id,
            c.date,
            c.repeatWhen,
          );
        }
      }
    }

    await refresh();
  }

  Widget placeContent(ExtendedPlaceInfo placeInfo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(5),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showModalBottomSheet(placeInfo),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placeInfo.name,
                  style: titleStyle,
                ),
                SizedBox(height: 10),
                for (var i = 0;
                    i < maxCardItems && i < placeInfo.zone.length;
                    i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      i == maxCardItems - 1 && placeInfo.zone.length > 4
                          ? '${placeInfo.zone[i].name}...'
                          : placeInfo.zone[i].name,
                      style: greyStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
            ),
          ),
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
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: UserBar(jobTitle: 'Начальник охраны'),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: info == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 180,
                        ),
                        itemCount: info!.length,
                        itemBuilder: (ctx, i) => placeContent(info![i]),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModalBottomSheet(null),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF00B2FF),
      ),
    );
  }
}
