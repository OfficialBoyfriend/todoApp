import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todoApp/model/database.dart';
import 'package:todoApp/model/todo.dart';
import 'package:todoApp/widgets/custom_dialog.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Database provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Database>(context);

    return StreamProvider.value(
      value: provider.getTodoByType(TodoType.TYPE_TASK.index),
      child: Consumer<List<TodoData>>(
        builder: (context, _dataList, child) {
          if (_dataList != null && _dataList.length < 1) {
            return Center(
              child: Text(
                '暂无待办...',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }
          return _dataList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    return _dataList[index].isFinish
                        ? _taskComplete(_dataList[index])
                        : _taskUncomplete(_dataList[index]);
                  },
                );
        },
      ),
    );
  }

  // 未完成任务
  Widget _taskUncomplete(TodoData data) {
    return _dialogLayout(
      data: data,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_unchecked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            Expanded(
              child: Text(
                data.task,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 已完成任务
  Widget _taskComplete(TodoData data) {
    return _dialogLayout(
      data: data,
      child: Container(
        foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.radio_button_checked,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              SizedBox(
                width: 28,
              ),
              Text(data.task)
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogLayout({@required TodoData data, @required Widget child}) {
    return InkWell(
      onTap: data.isFinish
          ? null
          : () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: '完成待办',
                    text: data.task,
                    date: data.date,
                    buttonText: '完成',
                    onPressed: () {
                      provider.completeTodoEntries(data.id).whenComplete(
                            () => Navigator.of(context).pop(),
                          );
                    },
                  );
                },
              );
            },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: '删除待办',
              text: data.task,
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
      child: child,
    );
  }
}
