import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Helper with ChangeNotifier {
  String _selected = 'Egypt';
  static List<String> _Con;

  void Startmain() async {
    _Con = await getcountires();
  }

  String get selected => _selected;

  void setCountry(String c) {
    _selected = c;
    notifyListeners();
  }

  List get con {
    return _Con;
  }

  Future<List<String>> getcountires() async {
    Response response =
        await Dio().get('https://coronavirus-19-api.herokuapp.com/countries');
    List<Map> Ma = (response.data as List).cast();
    List<String> countries = [];
    Ma.forEach((element) {
      element.forEach((key, value) {
        if (key == "country" && value != "Total:" && value != '') {
          countries.add(value);
        }
      });
    });
    return countries;
  }

  Future<List<int>> ByAll() async {
    Response response =
    await Dio().get('https://coronavirus-19-api.herokuapp.com/countries/world');
    return [
      response.data['cases'],
      response.data['deaths'],
      response.data['recovered'],
      response.data['todayCases'],
      response.data['todayDeaths'],
      response.data['active'],
    ]; }

  Future<List<int>> ByCounty() async {
    Response aa = await Dio()
        .get('https://coronavirus-19-api.herokuapp.com/countries/$_selected');
    Map aaaa = aa.data;
    return [
      aaaa['cases'],
      aaaa['deaths'],
      aaaa['recovered'],
      aaaa['todayCases'],
      aaaa['todayDeaths'],
      aaaa['active'],
    ];
  }
}
