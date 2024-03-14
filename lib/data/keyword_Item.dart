class KeywordItem {
  String title;
  bool active;
  int index;
  int storeSrno;

  KeywordItem({required this.title, required this.active, required this.index,required this.storeSrno});

  // Convert Item to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'active': active,
      'index': index,
      'storeSrno': storeSrno,
    };
  }

  // Create Item from JSON
  factory KeywordItem.fromJson(Map<String, dynamic> json) {
    return KeywordItem(
      title: json['title'],
      active: json['active'],
      index: json['index'],
      storeSrno: json['storeSrno'],
    );
  }
}
