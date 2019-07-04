class FilterCriteria {
  // region Constructor
  FilterCriteria() {
    radiusCovered = 10000.0;
    keywords = [];
    openNow = true;
    maxPriceLevel = 4.0;
  }

  // region Properties
  double radiusCovered;
  List<String> keywords;
  bool openNow;
  double maxPriceLevel;

  // region Public Methods

  void copyFrom(Map<String, dynamic> criteriaMap) {
    this.radiusCovered = criteriaMap["radius"];
    this.keywords = (criteriaMap["keywords"] as String).split("|");
    this.openNow = criteriaMap["isOpen"] == "yes";
    this.maxPriceLevel = criteriaMap["maxPrice"];
  }

  String getFormattedkeyWords(bool shouldAnd) {
    List<String> filteredKeywords = keywords.where((f) => f.isNotEmpty).toList();
    return filteredKeywords.join(shouldAnd ? " AND " : " OR ", );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> criteriaMap = new Map<String, dynamic>();
    criteriaMap["radius"] = this.radiusCovered;
    criteriaMap["keywords"] = keywords.join("|");
    criteriaMap["isOpen"] = openNow ? "yes" : "no";
    criteriaMap["maxPrice"] = maxPriceLevel;
    return criteriaMap;
  }
}
