import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';
import 'package:remote_ad/database_helper.dart';
import 'package:remote_ad/local_notification.dart';
import 'package:remote_ad/notification.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String latitude = "";
  String longitude = "";
  double tempC = 0;
  String t = "";
  double humidity = 0;
  String hu = "";
  double hearbeat = 0;
  String h = "";
  String helpBTN = "";
  int check = 1;
  DatabaseReference latitudeRef =
      FirebaseDatabase.instance.ref().child("/latitude");
  DatabaseReference longitudeRef =
      FirebaseDatabase.instance.ref().child("/longitude");
  DatabaseReference tempCRef = FirebaseDatabase.instance.ref().child("/tempC");

  DatabaseReference humidityRef =
      FirebaseDatabase.instance.ref().child("/humidity");

  DatabaseReference hearbeatRef =
      FirebaseDatabase.instance.ref().child("/hearbeat");

  DatabaseReference helpBTNRef =
      FirebaseDatabase.instance.ref().child("/helpBTN");

  DatabaseReference toggleValueRef =
      FirebaseDatabase.instance.ref().child("/toggleValue");

  bool isToggleOn = false;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var data = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      _notifications = data;
    });
  }

  void _addNotification() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: 'Help',
      DatabaseHelper.columnSubtitle: 'I am Drowning Please Help!!!'
    };
    final id = await DatabaseHelper.instance.insert(row);
    _loadData(); // Reload data to update UI
  }

  @override
  Widget build(BuildContext context) {
    hearbeatRef.onValue.listen((Event) {
      setState(() {
        h = Event.snapshot.value.toString();
        hearbeat = double.parse(h);
      });
    });

    tempCRef.onValue.listen((Event) {
      setState(() {
        t = Event.snapshot.value.toString();
        tempC = double.parse(t);
      });
    });

    humidityRef.onValue.listen((Event) {
      setState(() {
        hu = Event.snapshot.value.toString();
        humidity = double.parse(hu);
      });
    });

    latitudeRef.onValue.listen((Event) {
      setState(() {
        latitude = Event.snapshot.value.toString();
      });
    });

    longitudeRef.onValue.listen((Event) {
      setState(() {
        longitude = Event.snapshot.value.toString();
      });
    });

    helpBTNRef.onValue.listen((Event) {
      setState(() {
        helpBTN = Event.snapshot.value.toString();

        if (helpBTN == 'No help Thanks') {
          check = 1;
        }

        if (helpBTN != 'No help Thanks' && check == 1) {
          localNotifications.showSimpleNotification(
              title: "Help Message",
              body: "Please I Need Help",
              payload: "help");
          _addNotification();

          check = 0;
        }
      });
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('IOT Based Anti drowning with remote'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Implement logout functionality, for example:
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false, // Prevent going back to the MyApp page
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => notification()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyGauge(
                      backgroundColor: Colors.grey,
                      progressColor: Colors.black,
                      label: 'Temperature Level C',
                      value: tempC, // Example value
                      size: 150, // Adjust the size
                    ),
                    MyGauge(
                      backgroundColor: Colors.grey,
                      progressColor: Colors.purple,
                      label: 'Heart Beat Data',
                      value: hearbeat, // Example value
                      size: 150, // Adjust the size
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // New Gauge
                MyGauge(
                  backgroundColor: Colors.grey,
                  progressColor: Colors.green,
                  label: 'Humidity Level',
                  value: humidity, // Example value
                  size: 150, // Adjust the size
                ),

                SizedBox(height: 20),

                // Latitude and Longitude Card
                Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latitude: $latitude',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Longitude: $longitude',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Help Card
                Card(
                  margin: EdgeInsets.all(10),
                  color: Colors.redAccent,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        '$helpBTN',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // // Toggle Button
                // Column(
                //   children: [
                //     Text(
                //       'Emergency Button', // <-- Label for Toggle Button
                //       style: TextStyle(fontSize: 15),
                //     ),
                //     SizedBox(height: 10),
                //     ToggleWidget(
                //       isToggleOn: isToggleOn,
                //       toggle: () {
                //         setState(() {
                //           isToggleOn = !isToggleOn;
                //           toggleValueRef.set(isToggleOn ? 1 : 0);
                //         });
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.purple,
                ),
                onPressed: () {
                  // Navigate to Home page (could be implemented if needed)
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.info,
                  color: Colors.purple,
                ),
                onPressed: () {
                  // Navigate to About page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyGauge extends StatelessWidget {
  final Color backgroundColor;
  final Color progressColor;
  final String label;
  final double value; // Changed from String to double
  final double size;

  const MyGauge({
    Key? key,
    required this.backgroundColor,
    required this.progressColor,
    required this.label,
    required this.value, // Changed from String to double
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12, // Adjust font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: size,
          height: size,
          child: CustomPaint(
            painter: GaugePainter(
              backgroundColor: backgroundColor,
              progressColor: progressColor,
              value: value, // Pass value as double
            ),
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final Color backgroundColor;
  final Color progressColor;
  final double value; // Changed from String to double

  GaugePainter({
    required this.backgroundColor,
    required this.progressColor,
    required this.value, // Changed from String to double
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2.5;

    final strokeWidth = 8.0; // Adjust stroke width
    final startAngle = math.pi * 5 / 6.5; // 225 degrees in radians
    final sweepAngle = math.pi * 3 / 2; // 270 degrees in radians

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final labelStyle = TextStyle(
      color: Colors.black,
      fontSize: 12, // Adjust font size
      fontWeight: FontWeight.bold,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(2), // Display value as string
        style: labelStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );

    // Calculate progress angle based on value
    final progressAngle = (value / 100) *
        math.pi *
        3 /
        2; // Example: Convert percentage to radians

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SliderWithLabel extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final String label;
  final Color? activeColor;

  const SliderWithLabel({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12), // Adjust font size
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0.0,
          max: 100,
          divisions: 100,
          label: value.toStringAsFixed(2),
          activeColor: activeColor, // Set active color
        ),
      ],
    );
  }
}

class ToggleWidget extends StatelessWidget {
  final bool isToggleOn;
  final VoidCallback toggle;

  const ToggleWidget({
    Key? key,
    required this.isToggleOn,
    required this.toggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Icon(
        isToggleOn ? Icons.toggle_on : Icons.toggle_off,
        size: 100,
        color: isToggleOn ? Colors.blue : Colors.grey,
      ),
    );
  }
}

// Placeholder About page
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Page'),
      ),
      body: Center(
        child: Text(
          'We specialize in IoT-based anti-drowning technology, leading the way in enhancing water safety through advanced machine learning solutions. Our goal is to prevent water-related accidents by integrating state-of-the-art sensors and AI algorithms into wearable devices. At our core, we strive to create a world where individuals can enjoy water activities without the risk of drowning. Our dedication to cutting-edge technology and user-focused design ensures that our products not only meet but exceed industry standards for reliability and effectiveness. Join us as we innovate to make aquatic environments safer for all.',
        ),
      ),
    );
  }
}
