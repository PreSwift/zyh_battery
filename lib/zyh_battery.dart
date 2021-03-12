library zyh_battery;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZYHBatteryView extends StatefulWidget {
  final double electricQuantity;
  final double width;
  final double height;
  final bool isCharging;
  final bool showText;
  final TextStyle textStyle;

  ZYHBatteryView({Key key, this.electricQuantity, this.width = 27, this.height = 12, this.showText = true, this.isCharging = false, this.textStyle = const TextStyle(fontSize: 12, color: Colors.white)}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ZYHBatteryViewState();
  }
}

class _ZYHBatteryViewState extends State<ZYHBatteryView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showText) {
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text((widget.electricQuantity * 100).toInt().toString() + '%', style: widget.textStyle,),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: CustomPaint(size: Size(widget.width, widget.height), painter: BatteryViewPainter(widget.electricQuantity, widget.isCharging)),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: CustomPaint(size: Size(widget.width, widget.height), painter: BatteryViewPainter(widget.electricQuantity, widget.isCharging)),
      );
    }
  }
}

class BatteryViewPainter extends CustomPainter {
  bool isCharging;
  double electricQuantity;
  Paint mPaint;
  double mStrokeWidth = 1.0;
  double mPaintStrokeWidth = 1.5;

  BatteryViewPainter(electricQuantity, isCharging) {
    this.electricQuantity = electricQuantity;
    this.isCharging = isCharging;
    mPaint = Paint()..strokeWidth = mPaintStrokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //电池框位置
    double batteryLeft = 0;
    double batteryTop = 0;
    double batteryRight = size.width - size.width / 15 - mStrokeWidth;
    double batteryBottom = size.height;

    //电池头部位置
    double batteryHeadLeft = batteryRight + mStrokeWidth;
    double batteryHeadTop = size.height / 4;
    double batteryHeadRight = size.width;
    double batteryHeadBottom = batteryHeadTop + (size.height / 2);

    //电量位置
    double electricQuantityTotalWidth = batteryRight - 4 * mStrokeWidth; //电池减去边框减去头部剩下的宽度
    double electricQuantityLeft = 2 * mStrokeWidth;
    double electricQuantityTop = mStrokeWidth * 2;
    double electricQuantityRight = 2 * mStrokeWidth + electricQuantityTotalWidth * (isCharging ? 1 : electricQuantity);
    double electricQuantityBottom = size.height - 2 * mStrokeWidth;

    mPaint.color = Color(0x80ffffff);
    mPaint.style = PaintingStyle.stroke;
    //画电池框
    canvas.drawRRect(RRect.fromLTRBR(batteryLeft, batteryTop, batteryRight, batteryBottom, Radius.circular(mStrokeWidth)), mPaint);

    mPaint.style = PaintingStyle.fill;
    //画电池头部
    canvas.drawRRect(RRect.fromLTRBR(batteryHeadLeft, batteryHeadTop, batteryHeadRight, batteryHeadBottom, Radius.circular(mStrokeWidth)), mPaint);

    mPaint.style = PaintingStyle.fill;
    if (isCharging) {
      mPaint.color = Colors.green;
    } else {
      mPaint.color = Colors.white;
    }
    //画电池电量
    canvas.drawRRect(RRect.fromLTRBR(electricQuantityLeft, electricQuantityTop, electricQuantityRight, electricQuantityBottom, Radius.circular(mStrokeWidth)), mPaint);

    //画充电小闪现
    if (isCharging) {
      mPaint.style = PaintingStyle.fill;
      mPaint.color = Colors.white;
      Path path = new Path()..moveTo(size.width / 2 + 2, -2);
      path.lineTo(size.width / 2 - 6, size.height / 2 + size.height / 8);
      path.lineTo(size.width / 2 + 1, size.height / 2 + size.height / 8);
      path.lineTo(size.width / 2 - 2, size.height + 2);
      path.lineTo(size.width / 2 + 6, size.height / 2 - size.height / 8);
      path.lineTo(size.width / 2 - 1, size.height / 2 - size.height / 8);
      path.lineTo(size.width / 2 + 2, -2);
      canvas.drawPath(path, mPaint);
    }
  }

  @override
  bool shouldRepaint(BatteryViewPainter other) {
    return true;
  }
}