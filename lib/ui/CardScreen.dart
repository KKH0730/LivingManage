import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../AppColors.dart';

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double _angle = 0;
  double _gradientBegin = -1.6;
  double _gradientEnd = 1;


  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      // lowerBound: 1,
      // upperBound: 1.5,
      // value: 1,
      duration: const Duration(milliseconds: 300),
    );
  }

//https://velog.io/@locked/Flutter-%EA%B7%B8%EB%9D%BC%EB%8D%B0%EC%9D%B4%EC%85%98%EC%9C%BC%EB%A1%9C-%EB%A7%8C%EB%93%A4%EC%96%B4%EB%B3%B4%EB%8A%94-%EA%B4%91%EC%9B%90-%ED%9A%A8%EA%B3%BC
  @override
  Widget build(BuildContext context) {
    Animation<double> animation1 = Tween(begin: -1.6, end: 1.4).animate(animationController);
    Animation<double> animation2 = Tween(begin: -0.5, end: 0.5).animate(animationController);

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTapDown: (detail) => setState(() {
            double degree = 45 * math.pi / 180;
            _angle = degree;
            _gradientEnd = -1;
            animationController.forward();
          }),
          onTapUp: (detail) => setState(() {
            _angle = 0;
            _gradientEnd = 1;
            animationController.reverse();
          }),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: _angle),
            duration: const Duration(milliseconds: 300),
            builder: (BuildContext con, double val, _) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(val),
                child: Transform.rotate(
                  angle: 355 * math.pi / 180,
                  child: AnimatedBuilder(
                    animation: animation1,
                    builder: (context, widget) {
                      return Container(
                        height: 350,
                        width: 230,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            gradient: RadialGradient(
                                radius: 1.8,
                                colors: const [Colors.white, Colors.red],
                                stops: const [0, 10],
                                center: Alignment(animation1.value, animation2.value)
                            )
                        ),
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            const Text(
                              '@toss',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
