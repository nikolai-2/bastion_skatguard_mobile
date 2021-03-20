import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class DateRow extends StatefulWidget {
  final double width;
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const DateRow({
    Key? key,
    required this.width,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  late DateTime startDate;

  String weekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Пн';
      case 2:
        return 'Вт';
      case 3:
        return 'Ср';
      case 4:
        return 'Чт';
      case 5:
        return 'Пт';
      case 6:
        return 'Сб';
      case 7:
        return 'Вс';
      default:
        throw Exception('weekday must be > 0 && < 8');
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().add(Duration(days: -DateTime.now().weekday + 1));
  }

  @override
  Widget build(BuildContext context) {
    return InfiniteListView.builder(
      physics: PageScrollPhysics(),
      itemBuilder: (ctx, i) {
        final date = startDate.add(Duration(days: i));
        final isCurrentDate = date.day == widget.selectedDate.day &&
            date.month == widget.selectedDate.month &&
            date.year == widget.selectedDate.year;
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            widget.onDateSelected(date);
          },
          child: Column(
            children: [
              Text(
                weekdayName(
                  date.weekday,
                ),
              ),
              SizedBox(height: 3),
              Expanded(
                child: Container(
                  width: 35,
                  decoration: BoxDecoration(
                    color:
                        isCurrentDate ? Theme.of(context).primaryColor : null,
                    borderRadius:
                        isCurrentDate ? BorderRadius.circular(10) : null,
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: isCurrentDate
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemExtent: widget.width / 7,
      scrollDirection: Axis.horizontal,
    );
  }
}
