import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double itemHeight = 240.0;
double scrollOffset = 0.0;
List<Color> listColors = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 20; i++) {
      listColors.add(
        Colors.primaries[Random().nextInt(Colors.primaries.length)].shade200,
      );
    }
    scrollController.addListener(() {
      setState(() {
        scrollOffset = scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Sliver Animation"),
              background: Container(
                color: Colors.redAccent,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: itemHeight * 0.2,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final actuaHeight = itemHeight * 0.8;
              double indexOffset = index * actuaHeight;
              double defenrece = scrollOffset - indexOffset;
              bool isFirst = defenrece > 0 && defenrece < itemHeight + 50;
              var percent = 1.0;
              if (isFirst) {
                percent = (1 - defenrece / actuaHeight).clamp(0.0, 1.0);
              }

              return Align(
                heightFactor: 0.8,
                child: Transform.scale(
                  alignment: Alignment.bottomCenter,
                  scale: percent + (1 - percent) * 0.7,
                  child: Opacity(
                    opacity: percent,
                    child: Container(
                      height: itemHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: listColors[index]),
                    ),
                  ),
                ),
              );
            }, childCount: listColors.length),
          )
        ],
      ),
    );
  }
}
