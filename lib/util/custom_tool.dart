///工具类
class CustomTool {
  ///判断是否是数字
  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
