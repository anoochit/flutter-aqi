class AQIModel {
  int aQI;
  int pM25;
  int pM1;
  int pM10;

  AQIModel({this.aQI, this.pM25, this.pM1, this.pM10});

  factory AQIModel.fromJson(Map<String, dynamic> json) {
    return AQIModel(
      aQI: json['AQI'],
      pM25: json['PM25'],
      pM1: json['PM1'],
      pM10: json['PM10'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AQI'] = this.aQI;
    data['PM25'] = this.pM25;
    data['PM1'] = this.pM1;
    data['PM10'] = this.pM10;
    return data;
  }
}
