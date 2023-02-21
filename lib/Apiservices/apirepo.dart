import 'package:smartblood/Apiservices/mapapi.dart';
import 'package:smartblood/Model/mapmodel/mapmodel.dart';

class ApiRepository {
  final _provider = MapApi();

  Future<List<Mapdata>> fetchData() {
    return _provider.fetchData();
  }
}
