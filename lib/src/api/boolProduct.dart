import 'package:http/http.dart';
import 'package:productadd/main.dart';

Future<bool?> boolProduct(_barcode) async {
  String url = apiURL + 'productName.php?barcode=$_barcode';
  try {
    var result = await get(Uri.parse(url));
    if (result.statusCode == 200) {
      return true;
      // 登録なされていない商品
    } else if (result.statusCode == 400) {
      return false;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    print('error');
    return null;
  }
}
