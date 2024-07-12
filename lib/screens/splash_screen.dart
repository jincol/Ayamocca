import 'package:flutter/material.dart';
import 'package:ayamocca/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3500),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          /*Positioned.fill(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
            ),
          ),*/
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 150),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo.png',
                  height: 150,
                  width: 150,
                ),
              ),
              SizedBox(height: 120),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Text(
                  'Ayamocca\nImportaciones',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 50),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                  );
                },
              ),
              //SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  //@override
  Widget build22(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            height: 150,
            width: 150,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              'UClink',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}