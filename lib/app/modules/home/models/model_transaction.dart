class TransactionModel {
  List<TransactionData>? listData;

  TransactionModel(
      {this.listData,
      required int rowid,
      required String name,
      required String description,
      required double amount});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['list_data'] != null) {
      listData = <TransactionData>[];
      json['list_data'].forEach((v) {
        listData?.add(TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (listData != null) {
      data['list_data'] = listData?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionData {
  int? rowid;
  String? name;
  String? description;
  double? amount;

  TransactionData({this.rowid, this.name, this.description, this.amount});

  TransactionData.fromJson(Map<String, dynamic> json) {
    rowid = json['rowid'];
    name = json['Name'];
    description = json['Description'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rowid'] = rowid;
    data['Name'] = name;
    data['Description'] = description;
    data['Amount'] = amount;
    return data;
  }
}
