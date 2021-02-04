import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:todoApp/model/database.dart';
import 'package:todoApp/model/todo.dart';
import 'package:todoApp/widgets/custom_icon_decoration.dart';
import 'package:todoApp/widgets/custom_dialog.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Database provider;

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    provider = Provider.of<Database>(context);

    return StreamProvider.value(
      value: provider.getTodoByType(TodoType.TYPE_EVENT.index),
      child: Consumer<List<TodoData>>(
        builder: (context, _dataList, child) {
          if (_dataList != null && _dataList.length < 1) {
            return Center(
              child: Text(
                '暂无私语...',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }
          return _dataList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _dataList.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: Row(
                        children: <Widget>[
                          _lineStyle(context, iconSize, index, _dataList.length,
                              _dataList[index].isFinish),
                          _displayDate(_dataList[index].date),
                          _displayContent(_dataList[index]),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _displayContent(TodoData data) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
              color: Color(0x20000000),
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data.description),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '- ${data.task}',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: '删除私语',
                    text: '${data.description} - ${data.task}',
                    date: data.date,
                    buttonText: '删除',
                    onPressed: () {
                      provider.deleteTodoEntries(data.id).whenComplete(
                            () => Navigator.of(context).pop(),
                          );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _displayDate(DateTime dateTime) {
    return Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            DateFormat('hh:mm').format(dateTime),
          ),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
      decoration: CustomIconDecoration(
        iconSize: iconSize,
        lineWidth: 1,
        firstData: index == 0 ?? true,
        lastData: index == listLength - 1 ?? true,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 3), color: Color(0x20000000), blurRadius: 5)
            ]),
        child: Icon(
            //isFinish ? Icons.fiber_manual_record : Icons.radio_button_unchecked,
            Icons.radio_button_unchecked,
            size: iconSize,
            color: Theme.of(context).accentColor),
      ),
    );
  }
}
