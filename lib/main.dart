import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Snake Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberOfSquares = 700;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(640);

  void generateNewFood() {
    food = randomNumber.nextInt(640);
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 200);
    Timer.periodic(duration, (Timer? timer) {
      updateSnake();
      if (gameOver()) {
        timer!.cancel();
        _showGameOverScreen();
      }
    });
  }

  var direction = 'down';

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 680) {
            snakePosition.add(snakePosition.last + 20 - 700);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 700);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        default:
      }
      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count++;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('GAME OVER'),
            content: Text('You\'re score: ' + snakePosition.length.toString()),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop();
                },
                child: const Text('Play Again'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 20),
                itemBuilder: (BuildContext context, int? index) {
                  if (snakePosition.contains(index!)) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  if (index == food) {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.grey[900],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ), // T
      bottomNavigationBar: Padding(
        padding:
        const EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0, top: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            GestureDetector(
              onTap: startGame,
              child: const Text(
                'start',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const Text(
              '@DirectorOfFTInc',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
