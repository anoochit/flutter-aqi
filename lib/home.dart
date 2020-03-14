import 'package:aqi/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<AQIModel> readData() async {
    var url = 'http://127.0.0.1:3000/';

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return AQIModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load AQI');
      }
    } catch (e) {
      throw Exception('Failed to load AQI');
    }
  }

  Future<AQIModel> aqiData;

  @override
  void initState() {
    super.initState();
    aqiData = readData();
  }

  Color setColor(int aqi) {
    if ((aqi >= 0) && (aqi <= 50)) return Colors.green;
    if ((aqi >= 51) && (aqi <= 100)) return Colors.yellow;
    if ((aqi >= 101) && (aqi <= 150)) return Colors.yellow;
    if ((aqi >= 151) && (aqi <= 200)) return Colors.red;
    if ((aqi >= 201) && (aqi <= 300)) return Colors.purple;
    if ((aqi >= 301)) return Colors.brown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              Center(
                child: FutureBuilder<AQIModel>(
                  future: aqiData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // set color
                      return Text(snapshot.data.aQI.toString(),
                          style: TextStyle(
                              color: setColor(snapshot.data.aQI),
                              fontSize: 160,
                              fontWeight: FontWeight.w800));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
