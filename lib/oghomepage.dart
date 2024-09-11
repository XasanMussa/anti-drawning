import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isToggleOn = false;

  // Volume control value
  double volume = 0;
  double volume1 = 0;

  // Water quality value
  double waterQuality = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('IOT Based Anti drowning with remote '),
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
                      label: 'Water Temperature C',
                      text: '0',
                      size: 150, // Adjust the size
                    ),
                    MyGauge(
                      backgroundColor: Colors.grey,
                      progressColor: Colors.purple,
                      label: 'Heart Beat Data',
                      text: '0',
                      size: 150, // Adjust the size
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SliderWithLabel(
                  value: waterQuality,
                  onChanged: (newValue) {
                    setState(() {
                      waterQuality = newValue;
                    });
                  },
                  label: 'Water Quality',
                  activeColor: Colors.green,
                ),
                SizedBox(height: 20),
                Text(
                  'Help Button Data',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 10),
                Text(
                  'Please i need Help',
                  style: TextStyle(fontSize: 40, color: Colors.yellow),
                ),
                SizedBox(height: 20),
                // Toggle Button
                Column(
                  children: [
                    Text(
                      'Emergency Button', // <-- Label for Toggle Button
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    ToggleWidget(
                      isToggleOn: isToggleOn,
                      toggle: () {
                        setState(() {
                          isToggleOn = !isToggleOn;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Light on', // <-- Label for Light
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    LightWidget(), // <-- Display the LightWidget
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.purple,),
                onPressed: () {
                  // Navigate to Home page (could be implemented if needed)
                },
              ),
              IconButton(
                icon: Icon(Icons.info, color: Colors.purple,),
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
  final String text;
  final double size;

  const MyGauge({
    Key? key,
    required this.backgroundColor,
    required this.progressColor,
    required this.label,
    required this.text,
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
              text: text,
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
  final String text;

  GaugePainter({
    required this.backgroundColor,
    required this.progressColor,
    required this.text,
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
        text: text,
        style: labelStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );

    // Calculate progress angle based on some logic or external data source
    final progressAngle = (double.parse(text) / 255) * math.pi * 3 / 2; // Example: Convert percentage to radians

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
        size: 50,
        color: isToggleOn ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class LightWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.lightbulb_outline,
      size: 50,
      color: Colors.red, // Adjust color as needed
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
        child: Text('We specialize in IoT-based anti-drowning technology, leading the way in enhancing water safety through advanced machine learning solutions. Our goal is to prevent water-related accidents by integrating state-of-the-art sensors and AI algorithms into wearable devices. At our core, we strive to create a world where individuals can enjoy water activities without the risk of drowning. Our dedication to cutting-edge technology and user-focused design ensures that our products not only meet but exceed industry standards for reliability and effectiveness. Join us as we innovate to make aquatic environments safer for all."'),
      ),
    );
  }
}


