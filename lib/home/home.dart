import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pune_india_app/Network/network.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _productList = [];
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  dynamic _deviceInfo = 0;
  Map<String, dynamic> _users ={};
  Map<String, dynamic> _jsonProductResult ={};
  bool? _configValue;


  deviceVersion()async{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final info = androidInfo.version.sdkInt;
    if(mounted){
      setState(() {
        _deviceInfo = info;
        print(_deviceInfo);
      });
    }
  }
   double _fontSize(){
    double info = 14.0;
    if(_deviceInfo > 27){
        info = 12.0;
    }else{
        info = 9.0;
    }
     return info;
  }
 Future _loadCountryJson() async {
    String data = await DefaultAssetBundle.of(context).loadString(
        "assets/model/product.json"); //for calling local json
     _jsonProductResult = jsonDecode(data);
    //print(_jsonCountryResult);
    if (_jsonProductResult.containsKey('products')) {
      setState(() {
        _productList = _jsonProductResult['products'];
      });
      //print(_jsonProductResult);
    }
  }

  double calculateDiscountedPrice(num originalPrice, num discountPercentage) {
    double discountFraction = discountPercentage / 100;
    double discountAmount = originalPrice * discountFraction;
    double newPrice = originalPrice - discountAmount;
    return double.parse(newPrice.toStringAsFixed(2));
  }




  _listeningForConfig(){
    setState(() {
      _configValue = FirebaseRemoteConfig.instance.getBool('show_discounted_price');
    });
    FirebaseRemoteConfig.instance.onConfigUpdated.listen((event) async {
      await FirebaseRemoteConfig.instance.activate();
      if(mounted!){
        setState(() {
          _configValue = FirebaseRemoteConfig.instance.getBool('show_discounted_price');
        });
      }
    });
  }
  Future _getDataFromFirestore()async{
    try{
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        Map<String, dynamic> creatorData = userDoc.data()!as Map<String, dynamic>;
        _users = creatorData;
      });
    }on FirebaseAuthException catch (e){
      print(e.code);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future<void> _updateShopDetailsInFirestore()async{
    try{
      await FirebaseFirestore.instance.
      collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid).update({
        "shopDetail": _jsonProductResult
      });
    }on FirebaseAuthException catch (e){
      print(e.code);
    }
    catch(e){
      print(e.toString());
    }

  }

  Future<void> _initializeData() async {
    await _loadCountryJson();
    await _getDataFromFirestore();
    if (_users['shopDetail'] == null || _users['shopDetail'].isEmpty) {
      await _updateShopDetailsInFirestore();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCountryJson();
    deviceVersion();
    _listeningForConfig();
    _initializeData();

  }

  @override
  void dispose() {
    FirebaseRemoteConfig.instance.onConfigUpdated.listen((event) {}).cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String cutUnwantedPart(String name) {
      if (name.length > 20) {
        return name.trim().replaceRange(30, null, '...');
      }
      return name;
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xff467dce),
        leading: const Icon(Icons.arrow_back, color: Colors.white,),
        title:const Text('Shop'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 19
        ),
        actions: [TextButton(
            onPressed: (){
              Network().signOut(context);
            },
            child: const Text('Sign out',
            style:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15
            ),
            )
        )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0,),
        child: _productList != []?
        StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: _productList.length,
            itemBuilder: (context, index){
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width*0.24,
                      //width: MediaQuery.of(context).size.width*0.39,
                      decoration:  BoxDecoration(
                          image: DecorationImage(image: NetworkImage(_productList[index]['images'][0]),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(_productList[index]['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                    ),
                    const SizedBox(height: 10,),
                    Text(cutUnwantedPart(_productList[index]['description']),),
                    const SizedBox(height: 10,),
                    _configValue != null?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (_configValue!) ...[
                          Text(
                            '\$ ${_productList[index]['price']}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: _fontSize(),
                            ),
                          ),
                          Text(
                            '\$ ${calculateDiscountedPrice(
                                _productList[index]['price'],
                                _productList[index]['discountPercentage']
                            )}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: _fontSize(),
                            ),
                          ),
                          Text(
                            '${_productList[index]['discountPercentage']}% off',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: _fontSize(),
                            ),
                          ),
                        ] else
                          Text(
                            '\$ ${_productList[index]['price']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: _fontSize(),
                            ),
                          ),
                      ],
                    ):Container(),
                  ],
                ),
              );
            },
            staggeredTileBuilder:  (context) => const StaggeredTile.fit(1)
        ):Container(),
      ),
    );
  }
}
