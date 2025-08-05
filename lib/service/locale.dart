import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyLocalizations {
  final Locale locale;

  MyLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'StockList': 'StockList',
      'AddStock': 'AddStock',
      'EnterStockID':'EnterStockID',
      'Date':'Date',
      'Open':'Open',
      'Close':'Close',
      'Low':'Low',
      "Today's Closing":"Today's Closing",
      "Cancel":"Cancel",
      "ErrorText":"Stock Data about this stockID is not found, please enter a valid stockID!"
      ,"Add":"Add",
      "Delete":"Delete",
      "Are you sure deleting":"Are you sure deleting",
      "DeleteStockID":"DeleteStockID",
    },
    'zh': {
      'StockList': '股票清單',
      'AddStock': '新增股票',
      'EnterStockID':'輸入股票代碼',
      'Date':'日期',
      'Open':'開盤',
      'Close':'收盤',
      'Low':'最低',
      'High':'最高',
      "Today's Closing":"當日收盤",
      "Cancel":"取消",
      "ErrorText":"查無關於此代碼的股價資訊，請輸入有效的代碼!",
      "Add":"新增",
      "Are you sure deleting":"確定要刪除",
      "Delete":"刪除",
      "DeleteStockID":"刪除股票",
    },
  };
  String _t(String key) => _localizedValues[locale.languageCode]?[key] ?? key;

  String get stockList => _t('StockList');
  String get addStock => _t('AddStock');
  String get enterStockID => _t('EnterStockID');
  String get date => _t('Date');
  String get open => _t('Open');
  String get close => _t('Close');
  String get low => _t('Low');
  String get high => _t('High');
  String get todaysClosing => _t("Today's Closing");
  String get cancel => _t("Cancel");
  String get errortext => _t("ErrorText");
  String get add => _t("Add");
  String get delete => _t("Delete");
  String get areyousuredeleting => _t("Are you sure deleting");
  String get deleteStockID => _t("DeleteStockID");

  static const LocalizationsDelegate<MyLocalizations> delegate = _MyLocalizationsDelegate();
  static MyLocalizations of(BuildContext context) {  
    return Localizations.of<MyLocalizations>(context, MyLocalizations)!;
  }
}
class _MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);
   
  @override
  Future<MyLocalizations> load(Locale locale) async {
    return MyLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<MyLocalizations> old) => false;
}