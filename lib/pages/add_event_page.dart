import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:todoApp/model/database.dart';
import 'package:todoApp/model/todo.dart';
import 'package:todoApp/widgets/custom_date_time_picker.dart';
import 'package:todoApp/widgets/custom_modal_action_button.dart';
import 'package:todoApp/widgets/custom_textfield.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _textTaskNameControler = TextEditingController();
  final _textTaskDescriptionControler = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();

  // 选择日期
  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(Duration(days: -365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (datepick != null)
      setState(() {
        _selectedDateTime = DateTime(
          datepick.year,
          datepick.month,
          datepick.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
  }

  // 选择时间
  Future _pickTime() async {
    TimeOfDay timepick = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timepick != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          timepick.hour,
          timepick.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Database>(context);
    _textTaskNameControler.clear();
    _textTaskDescriptionControler.clear();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
              child: Text(
            "新增私语",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          SizedBox(
            height: 24,
          ),
          CustomTextField(
            labelText: '输入来源',
            controller: _textTaskNameControler,
          ),
          SizedBox(height: 12),
          CustomTextField(
            labelText: '输入内容',
            controller: _textTaskDescriptionControler,
          ),
          /*TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            minLines: 1,
            controller: _textTaskDescriptionControler,
          ),*/
          SizedBox(height: 12),
          CustomDateTimePicker(
            icon: Icons.date_range,
            onPressed: _pickDate,
            value: DateFormat('EEEE yyyy-MM-dd').format(_selectedDateTime),
          ),
          CustomDateTimePicker(
            icon: Icons.access_time,
            onPressed: _pickTime,
            value: DateFormat('a hh:mm').format(_selectedDateTime),
          ),
          SizedBox(
            height: 24,
          ),
          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () {
              /*_textTaskDescriptionControler.text
                  .split('\n')
                  .forEach((String value) {
                provider
                    .insertTodoEntries(
                      TodoData(
                        date: _selectedDateTime,
                        time: DateTime.now(),
                        isFinish: false,
                        task: '抖音',
                        description: value,
                        todoType: TodoType.TYPE_EVENT.index,
                        id: null,
                      ),
                    )
                    .whenComplete(() => debugPrint('ok'));
              });*/
              if (_textTaskNameControler.text == "" ||
                  _textTaskDescriptionControler.text == "") {
                print('找不到数据');
              } else {
                provider
                    .insertTodoEntries(
                      TodoData(
                        date: _selectedDateTime,
                        time: DateTime.now(),
                        isFinish: false,
                        task: _textTaskNameControler.text,
                        description: _textTaskDescriptionControler.text,
                        todoType: TodoType.TYPE_EVENT.index,
                        id: null,
                      ),
                    )
                    .whenComplete(() => Navigator.of(context).pop());
              }
            },
          )
        ],
      ),
    );
  }
}
