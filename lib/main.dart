import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(GuessNumberApp());

class GuessNumberApp extends StatelessWidget {
  final Map<String, WidgetBuilder> _routes = {
    "/": (context) {
      return GameScreen();
    }
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      title: "Guess Number",
      initialRoute: "/",
      routes: _routes,
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
                background: Colors.white,
                foreground: Colors.pink,
              ),
              quarterTurns: 2,
            ),
            Player(
              enabled: turn,
              onCheckCompleted: _checkDone,
              player: 2,
              number: number2,
              background: Colors.pink,
              foreground: Colors.white,
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
  final Color background;
  final Color foreground;

  Player(
      {@required this.enabled,
      @required this.onCheckCompleted,
      @required this.player,
      @required this.number,
      @required this.background,
      @required this.foreground});
}

class _PlayerState extends State<Player> {
  List<int> numbers = [null, null, null, null];
  int ind = 0;
  String message;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.enabled,
      child: Container(
        color: widget.foreground,
        child: AnimatedContainer(
          height:
              !widget.enabled ? 200 : MediaQuery.of(context).size.height - 200,
          curve: Curves.bounceOut,
          duration: Duration(seconds: 1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
              color: widget.background),
          padding: EdgeInsets.all(12.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: numbers.map<Widget>((number) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border:
                                Border.all(color: widget.foreground, width: 2)),
                        child: Center(
                          child: Text(
                            "${number ?? ' '}",
                            style: TextStyle(
                                color: widget.foreground, fontSize: 25),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "${message ?? ''}",
                    style: TextStyle(color: widget.foreground),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
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
                            numbers[ind++ % 4] = number;
                          });
                        } else {
                          setState(() {
                            numbers = [number, null, null, null];
                            ind = 1;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(color: widget.foreground)),
                        child: Center(
                            child: Text(
                          "$number",
                          style: TextStyle(
                              color: widget.foreground,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.info,
                          color: widget.foreground,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: widget.background,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: RotatedBox(
                                    quarterTurns: widget.player == 1 ? 2 : 0,
                                    child: ListView(
                                      padding: EdgeInsets.all(25.0),
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Text(
                                            "Rules",
                                            style: Theme.of(context)
                                                .textTheme
                                                .display1
                                                .copyWith(
                                                    color: widget.foreground),
                                          ),
                                        ),
                                        Text(
                                          "App has randomly selected 4 digit number for you.Your task is to find out the number."
                                          "\n\nPerfect Number : Number of correct numbers placed in correct position"
                                          "\n\nCorrect Number : Number of digits in last entered number, that are there in selected number.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline
                                              .copyWith(
                                                  color: widget.foreground),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                    Expanded(
                      child: ButtonBar(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: widget.foreground,
                              ),
                              onPressed: () {
                                if (ind > 0)
                                  setState(() {
                                    numbers[--ind] = null;
                                  });
                              }),
                          OutlineButton(
                            splashColor: widget.foreground,
                            highlightedBorderColor: widget.foreground,
                            color: widget.foreground,
                            onPressed: () {
                              setState(() {
                                numbers = [null, null, null, null];
                                ind = 0;
                              });
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(color: widget.foreground),
                            ),
                          ),
                          OutlineButton(
                            splashColor: widget.foreground,
                            highlightedBorderColor: widget.foreground,
                            color: widget.foreground,
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
                                        "Perfect Numbers $perfect | Correct Numbers $correct";
                                  });
                                }
                                widget.onCheckCompleted(false, widget.player);
                              } else {
                                setState(() {
                                  message = "Enter 4 Numbers";
                                });
                              }
                            },
                            child: Text(
                              "Check",
                              style: TextStyle(color: widget.foreground),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
