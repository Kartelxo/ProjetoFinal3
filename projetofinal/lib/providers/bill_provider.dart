import 'package:riverpod/riverpod.dart';
import '../models/bill.dart';

class BillNotifier extends Notifier<List<Bill>> {
  @override
  List<Bill> build() => [];

  void addBill(Bill bill) {
    state = [...state, bill];
  }

  void updateBill(int index, Bill bill) {
    state = [...state];
    state[index] = bill;
  }
}

final billsProvider = NotifierProvider<BillNotifier, List<Bill>>(() => BillNotifier());