import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
              flex: 8,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 400,
                          color: Colors.white,
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.white,
                          child: Center(
                            child: Text(" 1"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.white,
                          child: Center(
                            child: Text(" 2"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.white,
                          child: Center(
                            child: Text(" 3"),
                          ),
                        ),
                        
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.white,
                          child: Center(
                            child: Text(" 1"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.white,
                          child: Center(
                            child: Text(" 2"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.white,
                          child: Center(
                            child: Text(" 3"),
                          ),
                        ),
                        
                      ],
                    ),
                  
                  ],
                ),
              )),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
