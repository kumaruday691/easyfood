class FilterCriteria 
{
  // region Constructor
  FilterCriteria()
  {
    radiusCovered = 15000;
    keyword = "";
    openNow = true;
    minPriceLevel = 0;
    maxPriceLevel = 4;
  }

  // region Properties
  int radiusCovered;
  String keyword;
  bool openNow;
  int minPriceLevel;
  int maxPriceLevel;

}