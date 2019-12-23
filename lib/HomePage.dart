import 'package:architech1/Login%20Screen/loginPageController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import 'Firebase.dart';
import 'User.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _setCheckedDay(String uid, DateTime time) {
    setState(() {
      Firebase().saveData(uid, time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "İşe Geldim mi?",
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Firebase().logOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return new LoginPage();
                },
              ), (_) => false);
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: Builder(builder: (context) => _date(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _neverSatisfied(DateTime.now()),
        child: Icon(Icons.check),
      ),
    );
  }

  Future<void> _neverSatisfied(DateTime time) async {
    String weekDay;
    switch (time.weekday) {
      case 1:
        weekDay = "Pazartesi";
        break;
      case 2:
        weekDay = "Salı";
        break;
      case 3:
        weekDay = "Çarşamba";
        break;
      case 4:
        weekDay = "Perşembe";
        break;
      case 5:
        weekDay = "Cuma";
        break;
      case 6:
        weekDay = "Cumartesi";
        break;
      case 7:
        weekDay = "Pazar";
        break;

        break;
      default:
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "${time.day}-${time.month}-${time.year} $weekDay Günü İşe Geldiniz Mi?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Evet'),
              onPressed: () {
                _setCheckedDay(user.uid, time);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _date(BuildContext context) {
    return StreamBuilder(
        stream: Stream.fromFuture(Firebase().getDocumentSnapShot(user.uid)),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            Firebase().setDataFromSnapShot(snapShot.data);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CalendarCarousel<Event>(
                      firstDayOfWeek: 1,
                      weekendTextStyle: TextStyle(
                        color: Colors.red,
                      ),
                      thisMonthDayBorderColor: Colors.grey,
                      customDayBuilder: (
                        bool isSelectable,
                        int index,
                        bool isSelectedDay,
                        bool isToday,
                        bool isPrevMonthDay,
                        TextStyle textStyle,
                        bool isNextMonthDay,
                        bool isThisMonthDay,
                        DateTime day,
                      ) {
                        var isCheck = -1;
                        user.dates.forEach((date, mounts) {
                          if (date.month == day.month) {
                            mounts.forEach((dayIndex, value) {
                              if (day.day == dayIndex) {
                                isCheck = value ? 1 : 0;
                              }
                            });
                          }
                        });

                        if (isCheck == 1) {
                          return Center(
                            child: Container(
                              color: isPrevMonthDay
                                  ? Colors.green[200]
                                  : isNextMonthDay
                                      ? Colors.green[200]
                                      : Colors.green[400],
                              child: Center(child: Text(day.day.toString())),
                            ),
                          );
                        } else if (isCheck == 0) {
                          return Center(
                            child: Container(
                              color: isPrevMonthDay
                                  ? Colors.red[200]
                                  : isNextMonthDay
                                      ? Colors.red[200]
                                      : Colors.red[400],
                              child: Center(child: Text(day.day.toString())),
                            ),
                          );
                        } else {
                          return null;
                        }
                      },
                      weekFormat: false,
                      daysHaveCircularBorder: false,
                      onDayLongPressed: (day) {
                        var now = DateTime.now();
                        if ((day.month == now.month && day.day <= now.day) ||
                            day.month < now.month) {
                          _neverSatisfied(day);
                        } else {
                          final snackBar = SnackBar(
                              duration: Duration(seconds: 1),
                              content:
                                  Text('Günümüzden İleri Bir Tarih Seçtiniz'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.cyan,
                strokeWidth: 5,
              )),
            );
          }
        });
  }
}
