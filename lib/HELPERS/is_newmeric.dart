class CheckNum {
  static bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }
}
