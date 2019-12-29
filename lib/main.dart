import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'double_player.dart';
import 'single_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(GuessNumberApp());
}

class GuessNumberApp extends StatelessWidget {
  final Map<String, WidgetBuilder> _routes = {
    "/": (context) {
      return SelectionScreen();
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

class SelectionScreen extends StatefulWidget {
  final List<Color> colors = [
    Colors.pink,
    Colors.blue,
    Colors.red,
    Colors.teal,
    Colors.amber,
    Colors.deepOrange,
    Colors.green
  ];

  final MaterialColor background;

  SelectionScreen({this.background});

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  MaterialColor colorSelection;

  @override
  void initState() {
    colorSelection = widget.background ?? widget.colors[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Guess Number",
          style: TextStyle(color: colorSelection, fontWeight: FontWeight.w300),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetAnimationCurve: Curves.bounceOut,
                      insetAnimationDuration: Duration(seconds: 1),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: GridView.count(
                        shrinkWrap: true,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        padding: EdgeInsets.all(20),
                        children: widget.colors.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                colorSelection = color;
                              });
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                maxRadius: 15,
                                minRadius: 5,
                                backgroundColor: color,
                              ),
                            ),
                          );
                        }).toList(),
                        crossAxisCount: 3,
                      ),
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: colorSelection,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return SinglePlayerGameScreen(colorSelection);
                  }));
                },
                splashColor: colorSelection,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: colorSelection),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Center(
                    child: Text(
                      "Single Player",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          color: colorSelection),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return DoublePlayerGameScreen(colorSelection);
                  }));
                },
                splashColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorSelection.shade700,
                            colorSelection.shade600,
                            colorSelection.shade300
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Center(
                    child: Text(
                      "Double Player",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
