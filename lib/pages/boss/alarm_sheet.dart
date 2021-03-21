import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/common/sheet_result.dart';
import 'package:skatguard/constants.dart';
import 'package:skatguard/dao/auth.model.dart';
import 'package:skatguard/dao/checkup.model.dart';
import 'package:skatguard/dao/schedule.dart';

class AlarmSheet extends StatefulWidget {
  final BuildContext rootContext;
  final List<User> guards;
  final SheetResult<List<CheckupInfo>> resultHost;
  final List<CheckupInfo> scheduleShiftPattern;
  AlarmSheet({
    Key? key,
    required this.rootContext,
    required this.guards,
    required this.resultHost,
    required this.scheduleShiftPattern,
  }) : super(key: key);

  @override
  _AlarmSheetState createState() => _AlarmSheetState();
}

class _AlarmSheetState extends State<AlarmSheet> {
  late List<CheckupInfo> info;

  @override
  void initState() {
    super.initState();
    info = [...widget.scheduleShiftPattern];
    widget.resultHost.value = info;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
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
          SizedBox(height: 15),
          Expanded(
            child: Stack(
              children: [
                if (info.length == 0)
                  Center(
                    child: Text('Добавьте расписание'),
                  )
                else
                  Positioned.fill(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: info.length,
                      itemBuilder: (ctx, i) => AlarmItem(
                        key: ValueKey('item ${info[i].id}'),
                        checkupInfo: info[i],
                        rootContext: widget.rootContext,
                        guards: widget.guards,
                        update: (c) => setState(() => info[i] = c),
                        onRemove: () async {
                          final id = info[i].id;
                          setState(() => info.remove(info[i]));
                          final dao = context.read<ScheduleDao>();
                          await dao.delete(id);
                        },
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      info.add(
                        CheckupInfo(
                          id: -1,
                          user_id: widget.guards.first.id,
                          place_id: -1,
                          date: DateTime.now().add(Duration(minutes: 30)),
                          repeatWhen: [0, 1, 2, 3, 4],
                          shiftZone: null,
                          place: null,
                          user: widget.guards.first,
                        ),
                      );
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlarmItem extends StatefulWidget {
  final CheckupInfo checkupInfo;
  final BuildContext rootContext;
  final List<User> guards;
  final VoidCallback onRemove;
  final void Function(CheckupInfo) update;

  const AlarmItem({
    Key? key,
    required this.checkupInfo,
    required this.rootContext,
    required this.guards,
    required this.onRemove,
    required this.update,
  }) : super(key: key);

  @override
  _AlarmItemState createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> with TickerProviderStateMixin {
  bool expanded = false;
  late AnimationController controller;

  bool isSwitched = true;
  bool isEnabled = false;

  Set<int> get enabledDays => widget.checkupInfo.repeatWhen.toSet();
  static const bool repeatable = true;

  TimeOfDay get currentTime =>
      TimeOfDay.fromDateTime(widget.checkupInfo.date.toLocal());
  User get guard => widget.checkupInfo.user!;

  String get timeString =>
      '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';

  void changeExpand() {
    setState(() => expanded = !expanded);
    if (expanded) {
      controller.animateTo(1);
    } else {
      controller.animateTo(0);
    }
  }

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  Future<void> changeTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    final now = DateTime.now();
    if (time != null)
      widget.update(
        widget.checkupInfo.copyWith(
          date: DateTime(
            now.year,
            now.month,
            now.day,
            time.hour,
            time.minute,
          ),
        ),
      );
  }

  Future<void> changeGuard() async {
    await showCupertinoModalPopup(
      context: widget.rootContext,
      semanticsDismissible: true,
      builder: (ctx) => Container(
        height: 250,
        child: CupertinoPicker.builder(
          backgroundColor: Colors.white,
          itemExtent: 50,
          onSelectedItemChanged: (i) => widget.update(
            widget.checkupInfo
                .copyWith(user_id: widget.guards[i].id, user: widget.guards[i]),
          ),
          scrollController: FixedExtentScrollController(
              initialItem: widget.guards.indexOf(widget.checkupInfo.user!)),
          childCount: widget.guards.length,
          itemBuilder: (ctx, i) => Center(
            child: Text(widget.guards[i].name),
          ),
        ),
      ),
    );
  }

  Widget topPart() {
    final splittedName = guard.name.split(' ');
    if (splittedName.length >= 2)
      splittedName[1] = splittedName[1].substring(0, 1) + '.';
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 25, right: 15),
              child: CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  guard.avatar_src,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeString,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    splittedName.join(' '),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 20),
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(
                    () {
                      isSwitched = value;
                    },
                  );
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 5),
              child: Text(
                () {
                  if (enabledDays.length == 7) return 'Каждый день';
                  if (enabledDays.length == 5 &&
                      enabledDays.containsAll([0, 1, 2, 3, 4])) return 'Будни';

                  final list = enabledDays.toList()..sort();
                  return list
                      .map((e) => weekdayName(e + 1))
                      .join(', ')
                      .toLowerCase();
                }(),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: RotationTransition(
                turns: Tween<double>(begin: 0, end: 3.5).animate(controller),
                child: Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 30,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget weekdayButton(String name, int index) {
    return Expanded(
      child: Center(
        child: SizedBox(
          height: 30,
          child: Container(
            color: (enabledDays.contains(index) && repeatable)
                ? Colors.blue.shade100
                : null,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: repeatable
                    ? () {
                        final days = {...enabledDays};
                        if (days.contains(index)) {
                          if (days.length == 1) {
                            return;
                          }
                          days.remove(index);
                        } else
                          days.add(index);
                        widget.update(widget.checkupInfo
                            .copyWith(repeatWhen: days.toList()));
                      }
                    : null,
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: repeatable ? Colors.black : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            changeTime();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 10, top: 10),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                timeString,
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.grey.shade100,
          child: Row(
            children: [
              weekdayButton('Пн', 0),
              weekdayButton('Вт', 1),
              weekdayButton('Ср', 2),
              weekdayButton('Чт', 3),
              weekdayButton('Пт', 4),
              weekdayButton('Сб', 5),
              weekdayButton('Вс', 6),
            ],
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextButton.icon(
            onPressed: () {
              changeGuard();
            },
            icon: Icon(
              Icons.person_outline,
              color: Colors.grey.shade600,
              size: 30,
            ),
            label: Text(
              'Сменить сотрудника',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextButton.icon(
            onPressed: () {
              widget.onRemove();
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.grey.shade600,
              size: 30,
            ),
            label: Text(
              'Удалить',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        color: Colors.white,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: changeExpand,
            child: Column(
              children: [
                topPart(),
                AnimatedSize(
                  vsync: this,
                  alignment: Alignment.topCenter,
                  duration: Duration(milliseconds: 100),
                  child: Container(
                    height: expanded ? null : 0,
                    child: bottomPart(),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
