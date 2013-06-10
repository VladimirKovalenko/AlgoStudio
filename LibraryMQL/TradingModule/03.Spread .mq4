int start()                                     
  {
   int spread1=MarketInfo(Symbol(),MODE_SPREAD);
   int digits=MarketInfo(Symbol(),MODE_DIGITS);
   int mult=MathPow(10,digits);
//   int spread2=(Ask-Bid)*mult;
   int spread2=MathRound((Ask-Bid)*mult);
   if(spread1!=spread2){
   Print(Bid,"    ", Ask,"   ",spread1,"   ",spread2,"    ",spread1-spread2);
   }
   return;
  }