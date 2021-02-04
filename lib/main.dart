import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'dart:io';
//import 'package:flutter/services.dart';

import 'package:todoApp/model/database.dart';
import 'package:todoApp/pages/home_page.dart';

void main() {
  Intl.defaultLocale = 'zh_CN';
  initializeDateFormatting();

  /*
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
  */

  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Database>(
          create: (_) => Database(),
        )
      ],
      child: MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: 'Todo',
        theme: ThemeData(primarySwatch: Colors.pink, fontFamily: "Montserrat"),
        home: HomePage(),
      ),
    );
  }
}
