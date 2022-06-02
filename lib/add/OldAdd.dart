import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  String qrCode = '0';
  String productURL = '';
  @override
  Widget build(BuildContext context) {
    final String productURL =
        'https://store-project.f5.si/img/' + qrCode + '.png';
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
                Image(image: NetworkImage(productURL)),
                Text(
                  '$qrCode',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text('スキャン'),
                  onPressed: () => scanQrCode(),
                ),
                SizedBox(height: 10),
                Text('個数 X個 ＋'),
              ],
            ),
          ),
          //スライドウィンド
          SlidingUpPanel(
            panel: Column(
              children: [
                getCard(
                  title: "商品１",
                  description: "00000000000000",
                  icon: Icons.cake_outlined,
                  key: const Key("product-1"),
                  onPressed: () {
                    // Navigator.of(context).pushNamed("/camera");
                  },
                ),
                getCard(
                  title: "商品2",
                  description: "00000000000000",
                  icon: Icons.cake_outlined,
                  key: const Key("product-2"),
                  onPressed: () {
                    // Navigator.of(context).pushNamed("/camera");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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

    setState(() {
      this.qrCode = qrCode;
      this.productURL = qrCode;
    });
  }
}

Card getCard({
  required String title,
  required String description,
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
                    description,
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
