import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todoApp/pages/add_event_page.dart';
import 'package:todoApp/pages/add_task_page.dart';
import 'package:todoApp/pages/event_page.dart';
import 'package:todoApp/pages/task_page.dart';
import 'package:todoApp/widgets/custom_button.dart';
import 'package:todoApp/utils/date.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 页面显示控制
  PageController _pageController = PageController();
  // 当前页面编号
  double _currentPage = 0;
  // 当前星期
  String _customWeeky = DateFormat('EEEE').format(DateTime.now());

  @override
  void initState() {
    // 添加页面监听器
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Theme.of(context).accentColor,
          ),
          Positioned(
            right: 0,
            child: Text(
              daysInMonth(DateTime.now()).toString(),
              style: TextStyle(fontSize: 200, color: Color(0x10000000)),
            ),
          ),
          _mainContent(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: _currentPage == 0 ? AddTaskPage() : AddEventPage(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            _customWeeky,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _pageNavigation(context),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: <Widget>[
              TaskPage(),
              EventPage(),
            ],
          ),
        )
      ],
    );
  }

  Widget _pageNavigation(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: CustomButton(
          onPressed: () {
            _pageController.previousPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
          },
          buttonText: "待办",
          color:
              _currentPage < 0.5 ? Theme.of(context).accentColor : Colors.white,
          textColor:
              _currentPage < 0.5 ? Colors.white : Theme.of(context).accentColor,
          borderColor: _currentPage < 0.5
              ? Colors.transparent
              : Theme.of(context).accentColor,
        )),
        SizedBox(
          width: 32,
        ),
        Expanded(
            child: CustomButton(
          onPressed: () {
            _pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
          },
          buttonText: "私语",
          color:
              _currentPage > 0.5 ? Theme.of(context).accentColor : Colors.white,
          textColor:
              _currentPage > 0.5 ? Colors.white : Theme.of(context).accentColor,
          borderColor: _currentPage > 0.5
              ? Colors.transparent
              : Theme.of(context).accentColor,
        ))
      ],
    );
  }
}
