import 'package:flutter/services.dart';
import 'package:smartblood/Model/mapmodel/mapmodel.dart';

import 'dart:convert';

class MapApi {
  Future<List<Mapdata>> fetchData() async {
    Mapdata mapParent = Mapdata();
    List<Mapdata> mapdata = [];
    final String response = await rootBundle.loadString('assets/cities.json');
    List k = await json.decode(response);
    for (var element in k) {
      mapParent = Mapdata.fromJson(element);
      mapdata.add(mapParent);
    }

    return mapdata;
  }
}
