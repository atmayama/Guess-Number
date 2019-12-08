import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(GuessNumberApp());

class GuessNumberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      title: "Guess Number",
      initialRoute: "/",
      routes: {
        "/": (context) {
          return GameScreen();
        }
      },
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool turn = true;
  List<int> number1 = [null, null, null, null],
      number2 = [null, null, null, null];

  @override
  void initState() {
    super.initState();
    Random r = Random();
    for (var i = 0; i < 4; ++i) {
      number1[i] = r.nextInt(9);
      number2[i] = r.nextInt(9);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RotatedBox(
              child: Player(
                enabled: !turn,
                onCheckCompleted: _checkDone,
                player: 1,
                number: number1,
              ),
              quarterTurns: 2,
            ),
            Player(
              enabled: turn,
              onCheckCompleted: _checkDone,
              player: 2,
              number: number1,
            )
          ],
        ),
      ),
    );
  }

  _checkDone(bool won, int player) {
    if (!won)
      setState(() {
        turn = !turn;
      });
    else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Container(
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 2,
                      child: Text(player == 2 ? "You Lost" : "You Won"),
                    ),
                    RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(player == 1 ? "You Lost" : "You Won")
                  ],
                ),
              ),
            );
          });
    }
  }
}

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
  final bool enabled;
  final Function(bool, int) onCheckCompleted;
  final int player;
  final List<int> number;

  Player(
      {@required this.enabled,
      @required this.onCheckCompleted,
      @required this.player,
      @required this.number});
}

class _PlayerState extends State<Player> {
  List<int> numbers = [null, null, null, null];
  int ind = 0;
  String message;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.enabled,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 12.0),
          height: MediaQuery.of(context).size.height *
              (widget.enabled ? 0.55 : 0.40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(color: Colors.black38, width: 2.0)),
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: numbers.map<Widget>((number) {
                  return Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Text(
                        "${number ?? '-'}",
                        style: TextStyle(
                            color: widget.player == 1
                                ? Colors.blueAccent
                                : Colors.green),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Text("${message ?? ''}"),
              GridView.count(
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                shrinkWrap: true,
                crossAxisCount: 5,
                children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((number) {
                  return InkWell(
                    onTap: () {
                      if (ind < 4) {
                        setState(() {
                          numbers[ind++] = number;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: widget.player == 1
                                  ? [Colors.blueAccent, Colors.lightBlue]
                                  : [Colors.green, Colors.lightGreen])),
                      child: Center(
                          child: Text(
                        "$number",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  );
                }).toList(),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text("<"),
                    onPressed: () {
                      if (ind > 0)
                        setState(() {
                          numbers[--ind] = null;
                        });
                    },
                  ),
                  OutlineButton(
                    color: Colors.blue,
                    onPressed: () {
                      if (ind == 4) {
                        int perfect = 0, correct = 0;
                        for (var i = 0; i < 4; ++i) {
                          if (widget.number[i] == numbers[i]) perfect++;
                        }
                        List<int> temp1 = List.from(widget.number);
                        List<int> temp2 = List.from(numbers);
                        while (temp2.isNotEmpty) {
                          if (temp1.contains(temp2[0])) {
                            correct++;
                            temp1.remove(temp2[0]);
                          }
                          temp2.removeAt(0);
                        }
                        if (perfect == 4) {
                          setState(() {
                            message = "Winner";
                            numbers = [null, null, null, null];
                            ind = 0;
                          });
                          widget.onCheckCompleted(true, widget.player);
                          return;
                        } else {
                          setState(() {
                            message =
                                "Perfect Numers $perfect | Correct Numbers $correct";
                            numbers = [null, null, null, null];
                            ind = 0;
                          });
                        }
                        widget.onCheckCompleted(false, widget.player);
                      } else {
                        setState(() {
                          message = "Enter 4 Numbers";
                        });
                      }
                    },
                    child: Text("Check"),
                  )
                ],
              )
            ],
          ),
        ),
        opacity: widget.enabled ? 1.0 : 0.2,
      ),
    );
  }
}
