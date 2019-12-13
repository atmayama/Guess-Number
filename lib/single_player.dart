import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guess_number/main.dart';

class SinglePlayerGameScreen extends StatefulWidget {
  final MaterialColor colorSelection;

  SinglePlayerGameScreen(this.colorSelection);

  @override
  _SinglePlayerGameScreenState createState() => _SinglePlayerGameScreenState();
}

class _SinglePlayerGameScreenState extends State<SinglePlayerGameScreen> {
  Color background = Colors.white;
  List<int> numbers = [null, null, null, null];

  String message = "";
  int ind = 0;

  @override
  void initState() {
    _setNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        iconTheme: IconThemeData(color: widget.colorSelection),
        elevation: 0,
        leading: Switch(
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white24,
            activeColor: widget.colorSelection,
            value: background == Colors.white ? true : false,
            onChanged: (light) {
              if (!light) {
                background = Colors.black87;
              } else {
                background = Colors.white;
              }
              setState(() {});
            }),
        centerTitle: true,
        title: Text(
          "Guess Number",
          style: TextStyle(
              color: widget.colorSelection,
              fontSize: 25,
              fontWeight: FontWeight.w300),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  numbers = [null, null, null, null];
                  ind = 0;
                  message = '';
                  _setNumber();
                });
              }),
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        child: ListView(
                          padding: EdgeInsets.all(25.0),
                          shrinkWrap: true,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                "Rules",
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(color: widget.colorSelection),
                              ),
                            ),
                            Text(
                              "App has randomly selected 4 digit number for you.Your task is to find out the number."
                              "\n\nPerfect Number : Number of correct numbers placed in correct position"
                              "\n\nCorrect Number : Number of digits in last entered number, that are there in selected number.",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline
                                  .copyWith(color: widget.colorSelection),
                            ),
                          ],
                        ),
                      );
                    });
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(color: background),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: numbers.map((number) {
                return Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      border:
                          Border.all(color: widget.colorSelection, width: 2)),
                  child: Center(
                    child: Text(
                      number == null ? "  " : number.toString(),
                      style:
                          TextStyle(color: widget.colorSelection, fontSize: 20),
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                message,
                style: TextStyle(color: widget.colorSelection),
              ),
            ),
            Spacer(),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((number) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (ind < 4) {
                        numbers[ind++] = number;
                      } else {
                        ind = 1;
                        numbers = [number, null, null, null];
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        border: Border.all(color: widget.colorSelection)),
                    child: Center(
                        child: Text(
                      number.toString(),
                      style:
                          TextStyle(color: widget.colorSelection, fontSize: 25),
                    )),
                  ),
                );
              }).toList(),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return SelectionScreen(
                        background: widget.colorSelection,
                      );
                    }));
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: widget.colorSelection,
                  ),
                ),
                Expanded(
                  child: ButtonBar(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: widget.colorSelection,
                          ),
                          onPressed: () {
                            setState(() {
                              if (ind > 0) {
                                numbers[--ind] = null;
                              }
                            });
                          }),
                      OutlineButton(
                        highlightedBorderColor: widget.colorSelection,
                        child: Text(
                          "Check",
                          style: TextStyle(color: widget.colorSelection),
                        ),
                        onPressed: () {
                          if (ind != 4) {
                            setState(() {
                              message = "Enter 4 Digits";
                            });
                            return;
                          }
                          int perfectNumbers = 0;
                          for (var i = 0; i < 4; ++i) {
                            if (setNumber[i] == numbers[i]) {
                              perfectNumbers++;
                            }
                          }
                          if (perfectNumbers == 4) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0))),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: Text(
                                              "You Won",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: widget.colorSelection),
                                            ),
                                          ),
                                          ButtonBar(
                                            children: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return SelectionScreen(
                                                        background: widget
                                                            .colorSelection,
                                                      );
                                                    }));
                                                  },
                                                  child: Text(
                                                    "EXIT",
                                                    style: TextStyle(
                                                        color: widget
                                                            .colorSelection),
                                                  )),
                                              RaisedButton(
                                                color: widget.colorSelection,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  numbers = [
                                                    null,
                                                    null,
                                                    null,
                                                    null
                                                  ];
                                                  ind = 0;
                                                  _setNumber();
                                                },
                                                child: Text(
                                                  "RETRY",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            return;
                          }
                          int correctNumbers = 0;
                          List<int> temp = List.from(numbers);
                          for (var i = 0; i < 4; ++i) {
                            if (temp.contains(setNumber[i])) {
                              correctNumbers++;
                              temp.remove(setNumber[i]);
                            }
                          }
                          setState(() {
                            message =
                                "Perfect Numbers = $perfectNumbers  |  Correct Numbers = $correctNumbers";
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<int> setNumber = [null, null, null, null];

  void _setNumber() {
    var rand = Random();
    for (var i = 0; i < 4; ++i) {
      setNumber[i] = rand.nextInt(9);
    }
  }
}
