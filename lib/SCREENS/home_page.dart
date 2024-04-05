import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/FUNCTIONS/profile_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/SCREENS/lightroom_presets/presets_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catogory List'),
      ),
      body: GridView.builder(
        itemCount: 2,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PresetListPage()));
              },
              child: Container(
                height: size.height * .06,
                width: size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border:
                      Border.all(color: Colors.black.withOpacity(.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: getColor("#dddddd").withOpacity(.5),
                        offset: const Offset(2, -2),
                        blurRadius: 15,
                        spreadRadius: .1),
                    BoxShadow(
                        color: getColor("#dddddd").withOpacity(.5),
                        offset: const Offset(-2, 2),
                        blurRadius: 15,
                        spreadRadius: .1),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'rounder',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.add),
                    Text(
                      "Presets",
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'rounder',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
