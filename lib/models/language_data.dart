class LanguageData {
  final String flag;
  final String name;
  final String languageCode;

  LanguageData(this.flag, this.name, this.languageCode);

  static List<LanguageData> languageList() {
    return <LanguageData>[
      LanguageData("๐ซ๐ท", "Franรงais", 'fr'),
      LanguageData("๐ธ๐ฆ", "ุงูููุนูุฑูุจููููุฉูโ", "ar"),
    ];
  }
}