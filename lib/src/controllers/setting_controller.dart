import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yoori_ecommerce/src/models/config_model.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';
import 'package:yoori_ecommerce/src/data/local_data_helper.dart';

class SettingController extends GetxController {
  RxBool isToggle = false.obs;

  var box = GetStorage();
  var selectedCurrency = "".obs;
  var selectedCurrencyName = "".obs;

  PackageInfo? packageInfo;

  RxList<Currencies> curr = <Currencies>[].obs;

  int getIndex(value) {
    return curr.indexWhere(((currIndex) => currIndex.code == value));
  }

  void updateCurrency(value) {
    selectedCurrency.value = value;
  }

  void updateCurrencyName(value) {
    selectedCurrencyName.value = curr[value].name!;
  }

  void toggle() {
    isToggle.value = isToggle.value ? false : true;
  }

  void _applySelectedCurrency(String savedCode) {
    if (curr.isNotEmpty) {
      final exists = curr.any((c) => c.code == savedCode);
      selectedCurrency.value = exists ? savedCode : (curr.first.code ?? "XOF");
    } else {
      selectedCurrency.value = savedCode;
    }
    final idx = curr.isNotEmpty ? getIndex(selectedCurrency.value) : -1;
    selectedCurrencyName.value = idx >= 0 ? curr[idx].name ?? "Franc CFA" : "Franc CFA";
  }

  Future<void> _fetchAndRefreshCurrencies() async {
    try {
      final configModel = await Repository().getConfigData();
      await LocalDataHelper().saveConfigData(configModel);
      final fresh = configModel.data?.currencies ?? [];
      if (fresh.isNotEmpty) {
        curr.assignAll(fresh);
        _applySelectedCurrency(LocalDataHelper().getCurrCode() ?? "XOF");
      }
    } catch (_) {}
  }

  @override
  void onInit() async {
    final cached = LocalDataHelper().getConfigData().data?.currencies ?? [];
    curr.assignAll(cached);
    final savedCode = LocalDataHelper().getCurrCode() ?? "XOF";
    _applySelectedCurrency(savedCode);
    packageInfo = await PackageInfo.fromPlatform();
    _fetchAndRefreshCurrencies();
    super.onInit();
  }
}
