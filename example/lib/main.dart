import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:zyh_battery/zyh_battery.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Battery _battery = Battery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.black87,
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: _battery.batteryLevel.asStream(),
                builder: (context, batteryLevel) {
                  if (batteryLevel.hasData) {
                    return StreamBuilder<BatteryState>(
                        stream: _battery.onBatteryStateChanged,
                        builder: (context, batteryState) {
                          return ZYHBatteryView(
                            width: 22,
                            height: 9,
                            electricQuantity: (batteryLevel.data) / 100,
                            isCharging: batteryState.data == BatteryState.charging,
                          );
                        }
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
