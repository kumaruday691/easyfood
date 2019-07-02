class FilterCriteria 
{
  // region Constructor
  FilterCriteria()
  {
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
  String getFormattedkeyWords(bool shouldAnd){
    return keywords.join(shouldAnd ? "AND" : "OR");
  }

}