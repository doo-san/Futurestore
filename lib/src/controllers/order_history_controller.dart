import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/data/local_data_helper.dart';
import 'package:yoori_ecommerce/src/models/order_list_model.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';

class OrderHistoryController extends GetxController {
  var isLoading = true.obs;
  OrderListModel orderListModel = OrderListModel();

  Future getOrderList() async {
    orderListModel = await Repository().getOrderList();
    isLoading.value = false;
  }

  Future getGuestOrderList({String? trxId}) async {
    orderListModel = await Repository().getGuestOrderList(trxId: trxId!);
    isLoading.value = false;
  }

  // Supprime une facture non payée puis rafraîchit la liste.
  Future<Map<String, dynamic>> deleteOrder(int orderId) async {
    final result = await Repository().deleteOrder(orderId);
    if (result['success'] == true) {
      isLoading.value = true;
      await getOrderList();
    }
    return result;
  }

  @override
  void onInit() {
    if(LocalDataHelper().getUserToken() != null){
      getOrderList();
    } else{
      getGuestOrderList(trxId: LocalDataHelper().getCartTrxId());
    }
    super.onInit();
  }
}
