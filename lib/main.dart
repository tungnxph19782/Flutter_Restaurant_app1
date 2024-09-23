import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

var bannerItems = ["Burger", "Cheese Chilly", "Noodles", "Pizza"];
var bannerImage = [
  "images/burger.jpg",
  "images/cheesechilly.jpg",
  "images/noodles.jpg",
  "images/pizza.jpg"
];


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    Future<List<Widget>> createList() async {
      List<Widget> items = [];
      String dataString = await DefaultAssetBundle.of(context).loadString("assets/data.json");
      List<dynamic> dataJSON = jsonDecode(dataString);

      dataJSON.forEach((object) {

        String finalString = "";
        List<dynamic> dataList = object["placeItems"];
        dataList.forEach((item) {
          finalString = finalString + item + " | ";
        });

        items.add(Padding(padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 5,
                ),

              ]
            ),
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(object["placeImage"],width: 80,height: 80,fit: BoxFit.cover,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(object["placeName"]),
                        Padding(
                          padding: const EdgeInsets.only(top: 2,bottom: 2),
                          child: Text(finalString,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          ),
                        ),
                        Text("Min Order : ${object["minOrder"]}",style: TextStyle(fontSize: 12,color: Colors.black54),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        );
      });
      return items;
    }
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(onPressed: () {}, icon: Icon(Icons.menu),),
                      Text("Foodies",style: TextStyle(fontSize: 25),),
                      IconButton(onPressed: () {}, icon: Icon(Icons.person)),
                    ],
                  ),
                ),
                BannerWidgetArea(),
          Container(
            child: FutureBuilder<List<Widget>>(
              initialData: <Widget>[Text("")], // Cung cấp dữ liệu ban đầu để tránh lỗi null
              future: createList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Hiển thị CircularProgressIndicator khi đang tải dữ liệu
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Hiển thị thông báo lỗi nếu có lỗi xảy ra
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // Hiển thị ListView với dữ liệu từ snapshot
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: snapshot.data ?? [], // Sử dụng danh sách trống nếu snapshot.data là null
                    ),
                  );
                } else {
                  // Hiển thị thông báo nếu không có dữ liệu
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black12,
        onPressed: () {},
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}

class BannerWidgetArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    PageController controller = PageController(viewportFraction: 0.8, initialPage: 1);

    List<Widget> banners = [];

    for(int x = 0 ; x < bannerItems.length ; x++){
      var bannerView = Padding(
          padding: EdgeInsets.all(10.0),
           child:  Container(
              child: Stack(
              fit: StackFit.expand,
              children:<Widget> [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow : [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4.0,4.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: Image.asset(
                    bannerImage[x],
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent,Colors.black54]
                      ),

                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bannerItems[x],
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "More than 40% of",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      );
        banners.add(bannerView);
    }

    return Container(
    height: screenWidth*9/16,
    width: screenWidth,
    child: PageView(
    controller: controller,
    scrollDirection: Axis.horizontal,
    children: banners,
    ),
    );
  }
}

