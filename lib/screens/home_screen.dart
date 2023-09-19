import 'dart:developer';

import 'package:assignment_test/models/data_model.dart';
import 'package:assignment_test/providers/data_provider.dart';
import 'package:assignment_test/screens/audiorec_screen.dart';
import 'package:assignment_test/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Utils/utils.dart';
import '../auth/google_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 

  get() async {
    final ref = Provider.of<DataProvider>(context, listen: false);
    await ref.fetchData();
  }


handleOffline()async{
    bool isOnline = await Utils().hasNetwork();
    if(!isOnline){
       final ref = Provider.of<DataProvider>(context, listen: false);
       ref.fetchDataOffline();
    }
}
 @override
  void initState() {
     get();
     handleOffline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DataModel> dataModelList= Provider.of<DataProvider>(context).list;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [

              ElevatedButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>Record_audio_screen()));
              }, child: Text("Record"))
            ],
            automaticallyImplyLeading: false,
            title: const Text("Home", style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: dataModelList.length,
              itemBuilder: (ctx, index) => Card(
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                      title: Text(dataModelList[index].title!),
                      subtitle: Text(dataModelList[index].subTitle!),
                    ),
              ))),
    );
  }
}
