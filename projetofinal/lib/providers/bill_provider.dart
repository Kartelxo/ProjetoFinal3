import 'package:riverpod/riverpod.dart';
import '../models/bill.dart';

class BillNotifier extends Notifier<List<Bill>> {
  @override
  List<Bill> build() => [];

  void addBill(Bill bill) => state = [...state, bill];

  void updateBill(int index, Bill bill) {
    state = [for (int i = 0; i < state.length; i++) i == index ? bill : state[i]];
  }
}

final billsProvider = NotifierProvider<BillNotifier, List<Bill>>(() => BillNotifier());
