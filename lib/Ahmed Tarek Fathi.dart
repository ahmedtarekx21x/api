import 'package:flutter/material.dart';
import 'User_Model.dart';
import 'package:dio/dio.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TheScreen(),
    );
  }
}
class TheScreen extends StatefulWidget {
  @override
  State<TheScreen> createState() => _TheScreenState();
}

class _TheScreenState extends State<TheScreen> {
  Dio dio = Dio();
  String url = "https://fakestoreapi.com/products";
  List<dynamic> itemList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<List<dynamic>> getData() async {
    Response response = await dio.get(url);
    print(response.statusCode);
    print(response.data);
    itemList =
        response.data.map((product) => UserModel.fromJson(product)).toList();
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(





                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  itemList[index].title,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                height: 200,
                                width: 200,
                                child: Image(
                                  height: 300,
                                  width: 300,
                                  image: NetworkImage(itemList[index].image),
                                ),
                              ),
                              Text(itemList[index].rating.toString()),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "${itemList[index].price.toString()}\$",
                                    style: TextStyle(fontSize: 30),

                                  )),
                              TextButton(onPressed: (){}, child: Text("Buy Now",style: TextStyle(fontSize: 25),))
                            ],

                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(child: Icon(Icons.error_outline));
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
