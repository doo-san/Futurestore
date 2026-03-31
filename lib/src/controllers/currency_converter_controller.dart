import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:yoori_ecommerce/src/data/local_data_helper.dart';
import 'package:yoori_ecommerce/src/models/config_model.dart';

class CurrencyConverterController extends GetxController implements GetxService {
  late String appCurrencyCode;
  late String appCurrencySymbol;
  late String currencySymbolFormat;
  late String decimalSeparator;
  late String numberOfDecimals;
  late int currencyIndex;
  double exchangeRate = 1.0;

  // Formateur FCFA : séparateur de milliers = espace (locale fr_FR), 0 décimale
  static final _fcfaFormat = NumberFormat('#,##0', 'fr_FR');

  @override
  void onInit() {
    fetchCurrencyData();
    super.onInit();
  }

  void fetchCurrencyData() {
    ConfigModel data = LocalDataHelper().getConfigData();
    // Défaut XOF car l'application est déployée en zone FCFA
    appCurrencyCode = LocalDataHelper().getCurrCode() ?? 'XOF';

    final currencies = data.data?.currencies;
    final currencyConfig = data.data?.currencyConfig;

    if (currencies != null && currencies.isNotEmpty) {
      currencyIndex = currencies.indexWhere((c) => c.code == appCurrencyCode);
      if (currencyIndex == -1) currencyIndex = 0;
      appCurrencySymbol = currencies[currencyIndex].symbol ?? _defaultSymbol();
      final rate = currencies[currencyIndex].exchangeRate;
      exchangeRate = rate != null ? double.tryParse(rate.toString()) ?? 1.0 : 1.0;
    } else {
      currencyIndex = 0;
      appCurrencySymbol = _defaultSymbol();
      exchangeRate = 1.0;
    }

    currencySymbolFormat = currencyConfig?.currencySymbolFormat ?? 'amount_symbol';
    decimalSeparator = currencyConfig?.decimalSeparator ?? '.';
    numberOfDecimals = currencyConfig?.noOfDecimals ?? '2';
  }

  /// Symbole par défaut selon le code devise (sans config backend).
  String _defaultSymbol() {
    switch (appCurrencyCode) {
      case 'XOF':
        return 'FCFA';
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      default:
        return appCurrencyCode;
    }
  }

  String convertCurrency(dynamic price) {
    final amount = double.tryParse(price.toString()) ?? 0.0;
    final convertedAmount = appCurrencyCode == 'USD' ? amount : amount * exchangeRate;

    // ── Format FCFA (XOF) ────────────────────────────────────────────────────
    // Règle : entier, séparateur de milliers = espace insécable, symbole à droite
    // Exemples : 130000 → "130 000 FCFA"  |  45000 → "45 000 FCFA"
    if (appCurrencyCode == 'XOF') {
      return '${_fcfaFormat.format(convertedAmount.round())} FCFA';
    }

    // ── Autres devises : comportement générique ──────────────────────────────
    final formatter = MoneyFormatter(
      amount: convertedAmount,
      settings: MoneyFormatterSettings(
        symbol: appCurrencySymbol,
        thousandSeparator: decimalSeparator == '.' ? ',' : '.',
        decimalSeparator: decimalSeparator,
        symbolAndNumberSeparator: symbolNumberSeparator(),
        fractionDigits: int.parse(numberOfDecimals),
      ),
    );
    return symblePosition() == 'right'
        ? formatter.output.symbolOnRight
        : formatter.output.symbolOnLeft;
  }

  String symbolNumberSeparator() {
    return (currencySymbolFormat == 'amount_symbol' ||
            currencySymbolFormat == 'symbol_amount')
        ? ''
        : ' ';
  }

  String symblePosition() {
    return (currencySymbolFormat == 'amount_symbol' ||
            currencySymbolFormat == 'amount__symbol')
        ? 'right'
        : 'left';
  }
}
