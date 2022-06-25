import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'Barcode.dart';
import 'Post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AlertDialog.dart';

// class OldAdd extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

class OldAdd extends StatefulWidget {
  @override
  _OldAddState createState() => _OldAddState();
}

class _OldAddState extends State {
  _myDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Dialog!"),
        content: const Text("Text of Something"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("close"),
          )
        ],
      ),
    );
  }

  Widget _firstitemadd() {
    if (products.length != 0) {
      return addListCard(
          title: products.first.name,
          barcode: products.first.barcode,
          imgURL: products.first.imgURL,
          quantity: products.first.quantity);
    }

    return Text('スキャンを開始してください。');
  }

  List<Barcode> products = [
    // Barcode(
    //     name: 'コーラ',
    //     barcode: '4902102072618',
    //     imgURL: 'https://sm.r10s.jp/item/31/4902102073431.jpg',
    //     price: 200,
    //     quantity: 1,
    //     category: 'hello'),
  ];

  String qrCode = '0';
  String productURL = '';
  @override
  Widget build(BuildContext context) {
    // final String productURL =
    //     'https://store-project.f5.si/img/' + qrCode + '.png';
    final String productURL =
        'https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-13-pro/pht-device-16.png?220309-01';
    return Scaffold(
      appBar: AppBar(
        title: Text('バーコードスキャン'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Image(image: NetworkImage(productURL)),
                Text(
                  '$qrCode',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text('スキャン'),
                  onPressed: () => scanQrCode(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    /* ボタンがタップされた時の処理 */
                    products.insert(
                        0, (await Barcode.addProduct(4549131970258)));
                    setState(() {});
                  },
                  child: Text('テスト追加'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    print(products.length);
                  },
                  child: Text('print test'),
                ),
              ],
            ),
          ),
          //スライドウィンド
          SlidingUpPanel(
            panel: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                    child: Center(
                      child: _firstitemadd(),
                    ),
                  ),
                  Expanded(
                    child: ListView(children: [
                      for (int i = 1; i < products.length; i++) ...{
                        addListCard(
                          title: products[i].name,
                          barcode: products[i].barcode,
                          quantity: products[i].quantity,
                          imgURL: products[i].imgURL,
                        )
                      }
                    ]),
                  ),
                  //ボタン参照
                  _bottomButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //ボタン

  Widget _bottomButtons() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10.0,
      ),
      child: Row(children: [
        ElevatedButton(
          onPressed: () {
            //print('aaa');
            //_request();
            print(PostRequest.postMethod(products));
            print('hello');
          },
          child: Text('続行する'),
        ),
      ]),
    );
  }

  Future scanQrCode() async {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#EB394B',
      'キャンセル',
      false,
      ScanMode.BARCODE,
    );
    if (!mounted) return;
    //products.add(await Barcode.addProduct(this.qrCode));
    setState(() {
      this.qrCode = qrCode;
      this.productURL = qrCode;
    });

    //products.add(await Barcode.addProduct(qrCode));
    Barcode addProduct = await Barcode.addProduct(qrCode);
    if (addProduct.barcode == '-400') {
      _myDialog;
      print('aaaaa');
      showDialog(
        context: context,
        builder: (context) => CustomTextFieldDialog(
          title: 'この商品は登録されていません。',
          contentWidget: const Text('この商品を登録しますか？ Barcode:ToDo'),
          cancelActionText: 'キャンセル',
          cancelAction: () {},
          defaultActionText: '登録する',
          action: () {},
        ),
      );
      return;
    }
    print(addProduct);
    products.add(addProduct);
    setState(() {});
  }
}

Card getCard({
  required String title,
  required String barcode,
  required IconData icon,
  required Key key,
  required Function()? onPressed,
}) {
  return Card(
    key: key,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  Text(
                    barcode,
                    softWrap: true,
                  ),
                  const Divider(),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton(
                  //     //参考：https://zenn.dev/enoiu/articles/6b754d37d5a272#elevatedbutton%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6
                  //     style: ElevatedButton.styleFrom(
                  //       onPrimary: Theme.of(context).colorScheme.onPrimary,
                  //       primary: Theme.of(context).colorScheme.primary,
                  //     ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  //     onPressed: onPressed,
                  //     child: const Text("開く"),
                  //   ),
                  // )
                ],
              ),
            ),
            Text("個数"),
            Icon(Icons.cancel)
          ],
        ),
      ),
    ),
  );
}

Card addListCard({
  required String title,
  required String barcode,
  required int quantity,
  //required IconData icon,
  required String imgURL,
  //required Key key,
  //required Function()? onPressed,
}) {
  return Card(
    //key: key,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(
            //   icon,
            //   size: 50.0,
            // ),
            Container(
              width: 50,
              height: 50,
              child: Image.network(imgURL),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  Text(
                    barcode,
                    softWrap: true,
                  ),
                  const Divider(),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton(
                  //     //参考：https://zenn.dev/enoiu/articles/6b754d37d5a272#elevatedbutton%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6
                  //     style: ElevatedButton.styleFrom(
                  //       onPrimary: Theme.of(context).colorScheme.onPrimary,
                  //       primary: Theme.of(context).colorScheme.primary,
                  //     ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  //     onPressed: onPressed,
                  //     child: const Text("開く"),
                  //   ),
                  // )
                ],
              ),
            ),
            Text('${quantity} 個'),
            Icon(Icons.cancel)
          ],
        ),
      ),
    ),
  );
}
