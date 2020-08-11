import 'dart:convert';

class Helper {
  // 传递中文参数前，先转换，fluro 不支持中文传递
  static String ParamsEncode(String originalCn) {
    StringBuffer sb = StringBuffer();
    var encoded = Utf8Encoder().convert(originalCn);
    encoded.forEach((val) => sb.write('$val,'));
    return sb.toString().substring(0, sb.length - 1).toString();
  }

  // 传递后取出参数，解析
  static String ParamsDecode(String encodedCn) {
    var decoded = encodedCn.split('[').last.split(']').first.split(',');
    var list = <int>[];
    decoded.forEach((s) => list.add(int.parse(s.trim())));
    return Utf8Decoder().convert(list);
  }
}