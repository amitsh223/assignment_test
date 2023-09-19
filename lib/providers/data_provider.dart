import 'dart:convert';
import 'dart:developer';

import 'package:assignment_test/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Utils/utils.dart';

class DataProvider with ChangeNotifier {
  List<DataModel> _dataList = [];
  List<DataModel> list = [];

  fetchData() async {
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        _dataList = [];
        var dir = await getApplicationDocumentsDirectory();
        Hive.init(dir.path);
        Box box = await Hive.openBox("apiData");
        box.put("apiData", jsonDecode(response.body));
        final data = jsonDecode(response.body) as List;
        for (var element in data) {
          _dataList.add(DataModel(
              id: element['id'],
              subTitle: element['body'],
              title: element['title']));
        }
        setData();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  fetchDataOffline() async {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      Box box = await Hive.openBox("apiData");
      final data = box.get("apiData");
      _dataList=[];
      for (var element in data) {
        _dataList.add(DataModel(
            id: element['id'],
            subTitle: element['body'],
            title: element['title']));
      }
      setData();
  }

  setData() {
    list = _dataList;
    notifyListeners();
  }
}
