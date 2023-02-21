// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartblood/Model/mapmodel/mapmodel.dart';
import 'package:smartblood/firebase/backend/backend.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(this.data, this.mobileno, {super.key});
  List<Mapdata> data;
  String? mobileno;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Mapdata> filter = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      filter = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: const Color(0xFF7E82DF).withOpacity(0.3),
        statusBarIconBrightness: Brightness.light));
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    print(value);
                    search(value, widget.data);
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder()),
                ),
              ),
              filter.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: filter.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                SvgPicture.asset("assets/svg/location.svg"),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Fetch.updateLocation(
                                          widget.mobileno.toString(),
                                          filter[index].city.toString(),
                                          filter[index].admin_name.toString(),
                                          context);
                                    },
                                    child: Text(
                                        '${filter[index].city.toString()}\t,\t${filter[index].admin_name}',
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ]),
                            );
                          }),
                    )
                  : const Text("No data Found")
            ],
          ),
        ),
      ),
    );
  }

  search(String name, List<Mapdata> cities) {
    List<Mapdata> results = [];
    if (name.isEmpty) {
      results = cities;
    } else {
      results = cities
          .where((element) =>
              element.city!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    setState(() {
      filter = results;
    });
  }
}
