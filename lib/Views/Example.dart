//import 'dart:async';
//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class Example extends StatefulWidget {
//  @override
//  _ExampleState createState() => new _ExampleState();
//}
//
//class _ExampleState extends State<Example> with TickerProviderStateMixin {
//
//  AnimationController _animationController;
//  double animationDuration = 0.0;
//  int totalItems = 10;
//
//  Timer timer;
//  int i = 0;
//
//  timerMEthod(){
//    i += 1;
//    setState(() {
//
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    final int totalDuration = 4000;
//    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => timerMEthod());
//
//    _animationController = AnimationController(
//        vsync: this,
//        duration: new Duration(milliseconds: totalDuration)
//    );
//    animationDuration = totalDuration/(100*(totalDuration/totalItems));
//    _animationController.forward();
//  }
//
//  FlutterLogoStyle _logoStyle = FlutterLogoStyle.markOnly;
//
//  @override
//  void dispose() {
//    _animationController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("hello"),
//        ),
//        // ListView Builder
//        body: ListView.builder(
//          itemCount: totalItems,
//          itemBuilder: (BuildContext context, int index) {
//            return new Item(index: index, animationController: _animationController, duration: animationDuration, i: i,);
//          },
//        ));
//  }
//}
//
//class Item extends StatefulWidget {
//
//  final int index;
//  final AnimationController animationController;
//  final double duration;
//  final int i;
//
//  Item({this.index, this.animationController, this.duration, this.i});
//
//  @override
//  _ItemState createState() => _ItemState();
//}
//
//class _ItemState extends State<Item> {
//  Animation _animation;
//  double start;
//  double end;
//  int i;
//
//  @override
//  void initState() {
//    super.initState();
//    start = (widget.duration * widget.index ).toDouble();
//    end = start + widget.duration;
//    print("START $start , end $end");
//    i = widget.i;
//    _animation = Tween<double>(
//      begin: 0.0,
//      end: 1.0,
//    ).animate(
//      CurvedAnimation(
//        parent: widget.animationController,
//        curve: Interval(
//          start,
//          end,
//          curve: Curves.easeIn,
//        ),
//      ),
//    )..addListener((){
//      setState(() {
//      });
//    });
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Opacity(
//      opacity: _animation.value,
//      child: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: new Text("New Sample Item ${widget.index} : ${widget.i}"),
//      ),
//    );
//  }
//}