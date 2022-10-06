import 'package:flutter/material.dart';
import 'package:productadd/src/api/AllProduct.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Mgt extends StatefulWidget {
  const Mgt({Key? key}) : super(key: key);

  @override
  State<Mgt> createState() => _MgtState();
}

class _MgtState extends State<Mgt> {
  var data;
  Future<List> getData() async {
    String url = 'https://store-project.f5.si/database/api/all.php';
    try {
      var result = await get(Uri.parse(url));
      if (result.statusCode == 200) {
        data = json.decode(result.body);
        int length = data.length - 1;
        for (int i = 0; i < length; i++) {
          // print(data[i]['itemname']);
        }
      }
      return data;
    } catch (e) {
      print('error');
      List aa = [];
      return aa;
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品管理'),
      ),
      backgroundColor: Colors.blueGrey[300],
      body: Center(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              // return Text(snapshot[1]['itemname']);
              print(snapshot.data![1]['itemname']);
              // return Text(snapshot.data![1]['itemname']);
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return addListCard(
                      title: snapshot.data![index]['itemname'],
                      barcode: snapshot.data![index]['barnum'].toString(),
                      quantity: snapshot.data![index]['quantity'],
                      imgURL: snapshot.data![index]['imgURL'],
                      id: 1);
                },
              );
            } else {
              return Text("エラーが発生しました。", style: TextStyle(fontSize: 30));
            }
          },
        ),
      ),
    );
  }

  Card addListCard({
    required String title,
    required String barcode,
    required int quantity,
    required String imgURL,
    required int id,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 120.0),
          ///////
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  child: Row(
                    children: [
                      // 商品画像画像
                      Container(
                        width: 55,
                        height: 55,
                        child: Image.network(imgURL),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      // 商品名バーコード
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                // softWrap: false,
                              ),
                              Text(
                                barcode,
                                softWrap: true,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 個数 変更ボタン
              Align(
                alignment: Alignment.bottomCenter, //右寄せの指定
                child: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.green[50],
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${quantity}',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              // color: Colors.blue,
                              child: Text(
                                '個',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
