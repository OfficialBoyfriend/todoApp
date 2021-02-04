import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todoApp/widgets/custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final DateTime date;
  final Function onPressed;

  CustomDialog({
    Key key,
    @required this.title,
    @required this.text,
    @required this.buttonText,
    @required this.date,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 24,
            ),
            Text(text),
            SizedBox(
              height: 24,
            ),
            Text(DateFormat("yyyy-MM-dd hh:mm").format(date)),
            SizedBox(
              height: 24,
            ),
            CustomButton(
              buttonText: buttonText,
              onPressed: onPressed,
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
