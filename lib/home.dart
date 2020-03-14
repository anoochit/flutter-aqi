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

  Widget cardBox(IconData icon, String title, String unit, String value) {
    return Card(
        child: Container(
            width: ((MediaQuery.of(context).size.width - 18) - 18) / 3.03,
            padding: const EdgeInsets.all(8),
            child: (value != null)
                ? Column(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Row(children: <Widget>[
                          Icon(icon),
                          SizedBox(width: 8),
                          Text(title)
                        ])),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w500),
                      ),
                    )
                  ])
                : Column(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Row(children: <Widget>[
                          Icon(icon),
                          SizedBox(width: 8),
                          Text(title)
                        ])),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    )
                  ])));
  }

  Widget cardBigBox(IconData icon, String title, String unit, String value) {
    return Card(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 220,
            padding: const EdgeInsets.all(8),
            child: (value != null)
                ? Column(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Row(children: <Widget>[
                          Icon(icon),
                          SizedBox(width: 8),
                          Text(
                            title,
                          )
                        ])),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 120, fontWeight: FontWeight.w500),
                      ),
                    )
                  ])
                : Column(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Row(children: <Widget>[
                          Icon(icon),
                          SizedBox(width: 8),
                          Text(title)
                        ])),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    )
                  ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<AQIModel>(
            future: aqiData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                  children: <Widget>[
                    cardBigBox(Icons.insert_chart, "AQI", "",
                        snapshot.data.aQI.toString()),
                    cardBox(Icons.insert_chart, "PM1", "",
                        snapshot.data.pM1.toString()),
                    cardBox(Icons.insert_chart, "PM2.5", "",
                        snapshot.data.pM25.toString()),
                    cardBox(Icons.insert_chart, "PM10", "",
                        snapshot.data.pM10.toString()),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
