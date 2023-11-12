import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../pages/home_pages.dart';

class SplassScreen extends StatefulWidget {
  const SplassScreen({super.key});

  @override
  State<SplassScreen> createState() => _SplassScreenState();
}

class _SplassScreenState extends State<SplassScreen> {
   void initState(){
     super.initState();
     setState(() {

     });
     Timer(Duration(seconds:7), () {
       Navigator.of(context).pushAndRemoveUntil(
         MaterialPageRoute(builder: (context) => HomePage()),
             (route) => false,
       );

     });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Center(
          child: Stack(

            children: [

              Lottie.asset('assets/images/node.json'),
              Padding(
                padding: const EdgeInsets.only(left: 130),
                child: Text('NOTE  2.0',style: TextStyle(
                    color: Colors.indigo,fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,fontSize: 25
                ),),
              ),


            ],
          ),
        ),
      )
    );
  }
}
