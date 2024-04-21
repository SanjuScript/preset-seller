extension CapitalizeFirstLetterExtension on String {
  String capitalizeFirstLetterOfEachWord() {
    if (isEmpty) {
      return this;
    }
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
      return '';
    }).join(' ');
  }
}