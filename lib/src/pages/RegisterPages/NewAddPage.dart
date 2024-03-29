import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productadd/src/api/RegisterPost.dart';
import 'package:productadd/src/api/RegisterPostImage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/services.dart';

class RegisterItemPage extends StatefulWidget {
  //const registerItemPage({Key? key}) : super(key: key);
  @override
  State<RegisterItemPage> createState() => _RegisterItemPageState();
}

class _RegisterItemPageState extends State<RegisterItemPage> {
  bool _isLoading = false;

  ///
  /// カテゴリー変更の際は
  ///[isSelectedCategoryName]と[DropdownButton]を変更してください
  ///
  List<String> isSelectedCategoryName = ["ドリンク", "おにぎり", "ぱん", "筆記用具", "その他"];

  ///
  ///
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnControllerAdd =
      RoundedLoadingButtonController();

  int count = 10;
  int? isSelectedCategory = 1;
  //barnum = 前の画面から
  //quantity = 0だよね追加だから
  var _itemname = TextEditingController();
  var _price = TextEditingController();
  File _image = File("");
  final picker = ImagePicker();
  var imgFlg = false;
  String tempimg = "https://jmva.or.jp/wp-content/uploads/2018/07/noimage.png";
  Future pictureChange() async {
    await getImage();
    // カメラキャンセルしたさいにreturn
    if (imgFlg == false) {
      _btnController.reset();
      return;
    }
    Future<String> go = RegisterImage.registerImagePost(_image);
    go.then((value) {
      if (value.contains("error")) {
        _btnController.error();
        showDialog(
          //画面外の部分を押せないようにする。
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("エラーが発生しました、"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text('写真処理中にエラーが発生しました。もう一度最初から行ってください。 $value')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // Navigator.of(context).pushNamed("/MainAddPage");
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('閉じる')),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
        return;
      }
      // print("れすぽんすこーど ${value}");
      String responsecode = value;
      tempimg = value;
      setState(() {
        // _btnController.success();
        _btnController.reset();
      });
    });
    print('LOG:カメラ撮影');
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        try {
          _image = File(pickedFile.path);
          imgFlg = true;
        } catch (e) {
          imgFlg = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final barcode = ModalRoute.of(context)?.settings.arguments;
    if (barcode == null) {}

    registerPost() {
      String item = _itemname.text;
      String category = isSelectedCategory.toString();
      String price = _price.text;
      Future<int> go = Register.registerPost(
          item, barcode.toString(), category, price, tempimg);
      go.then((value) {
        print("れすぽんすこーど ${value}");
        int responsecode = value;
        if (value == 200) {
          _btnControllerAdd.stop();
          showDialog(
            //画面外の部分を押せないようにする。
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("追加しました"),
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // Navigator.of(context).pushNamed("/MainAddPage");
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('閉じる')),
                        ],
                      )
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          _btnControllerAdd.error();
          showDialog(
            //画面外の部分を押せないようにする。
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("エラーが発生しました、"),
                children: [
                  Column(
                    children: [
                      Column(
                        children: [Text('現在登録することができません。errorcode{$value}')],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // Navigator.of(context).pushNamed("/MainAddPage");
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('閉じる')),
                        ],
                      )
                    ],
                  ),
                ],
              );
            },
          );
        }
      });

      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => registerItemPage()));
      print('LOG:RegisterPage続行');
    }

    print(barcode);
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品登録'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Image.network(tempimg),
                  ),
                  Text('画像の読み込みには時間がかかります。'),
                  RoundedLoadingButton(
                      child: Text('商品写真を撮影',
                          style: TextStyle(fontSize: 23, color: Colors.white)),
                      controller: _btnController,
                      color: Colors.green,
                      width: 200,
                      onPressed: () {
                        pictureChange();
                      }),
                  Text(
                    'コード : ${barcode}',
                    style: TextStyle(fontSize: 20),
                  ),

                  /// 商品名

                  TextField(
                      controller: _itemname,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.edit),
                        labelText: '商品名',
                      )),

                  /// 価格

                  TextField(
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      // keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _price,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.currency_yen),
                        labelText: '販売価格',
                      )),

                  /// カテゴリー

                  Text('カテゴリー'),
                  // TextField(
                  //   // controller: TextEditingController(text: '${quantity}'),
                  //   keyboardType: TextInputType.numberWithOptions(
                  //       signed: true, decimal: true),
                  //   controller: _category,
                  // ),
                  DropdownButton(
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    items: const [
                      DropdownMenuItem(
                        child: Text('ドリンク'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text('おにぎり'),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text('パン'),
                        value: 3,
                      ),
                      DropdownMenuItem(
                        child: Text('筆記用具'),
                        value: 4,
                      ),
                      DropdownMenuItem(
                        child: Text('その他'),
                        value: 5,
                      ),
                    ],
                    //6
                    onChanged: (int? value) {
                      print(value);
                      setState(() {
                        isSelectedCategory = value;
                      });
                    },
                    //7
                    value: isSelectedCategory,
                  ),

                  ///https://flutter.keicode.com/basics/textcontroller.php
                  ///

                  ElevatedButton(
                      child: Text(
                        "登録確認",
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: () {
                        if (_itemname.text == '' || _price.text == '') {
                          print('null');
                          showDialog(
                            //画面外の部分を押せないようにする。
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("商品名または価格が入力されていません。"),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('閉じる')),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        showDialog(
                          //画面外の部分を押せないようにする。
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text("以下の商品を登録します。"),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Image.network(tempimg),
                                      Row(
                                        children: [
                                          const Text('商品名：',
                                              style: TextStyle(fontSize: 14)),
                                          Flexible(
                                            child: Text(
                                              _itemname.text,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text('コード:',
                                              style: TextStyle(fontSize: 14)),
                                          Text(barcode.toString(),
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('カテゴリー：',
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              isSelectedCategoryName[
                                                  isSelectedCategory! - 1],
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('価格設定：',
                                              style: TextStyle(fontSize: 14)),
                                          Text("¥" + _price.text,
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('閉じる')),
                                          // ElevatedButton(
                                          //     onPressed: () {
                                          //       registerPost();
                                          //     },
                                          //     child: Text('登録')),
                                          RoundedLoadingButton(
                                              child: Text('登録',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white)),
                                              controller: _btnControllerAdd,
                                              color: Colors.green,
                                              width: 100,
                                              onPressed: () {
                                                _isLoading = true;
                                                registerPost();
                                              }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ],
              ),
            ),
            if (_isLoading)
              const Opacity(
                opacity: 0.7,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                ),
              ),
            if (_isLoading) const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
