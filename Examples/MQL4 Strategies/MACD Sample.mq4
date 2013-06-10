<metadata>
437fdde23e4645288ee21c3c5e28c5a099eb3043fc95600fa5cb102db7958bba76580838684abb9b680d5d338dee157ac6a21970a6c88becc0fdd6f498ed5521ea8c2a077048c2e0d0effec01a26600df69999fd8df86d019bfe7656483ebedb10624c3ffd94731c5d33ebd6ffdd7d4cdcf2fbcba6844c724f73553bc3a29bf630554d73cc8182c3a7e4f7b3eacac4977312513c7202620e5c39d1ed557a224c533281ecef8a80be5c60a4d094edc5b54c29c4fabeed5723493bd2b3ed993b5e3c5b7b0297aba58aa0d4007986f6c8ad4d73c7fb660a94f5bdd3a9ce6712640536515d387e40cb86feafafe3a195bf83aa85a6cafb9a86e8a2c5d3a63a5b395ec7a29ca28eb2563737429bef1f77d8b786f4e5db0b4a1663b2c69ef68ee12b59dbe7c8e7b0d1760306727a12c2ad0577556b1b2766056609b0dd7d0d86e7a2ccd9a094aa11525f30761baadaa3c20f61c6bfbb87bf90b0d3f7985f32cbbbec8d89e739403e00e0dcb0d3375887eae28f91f4553bbfcb691ad7e9516df6d984e79cf3117cacc17e1bcaa4c4b04d3e330d192513702d429aeaf881aad8b4dd5f38036b02765320a39d240c490adef76848fcbfaec1563baede6f0ec9a70f766e5282adc4a7b0df6c1c166fd2a08ee750376a0286f2c4b75c6229159afe6f0e6f1b385ddd92c8ae30733e4c5e3bbbda9ce8ea831679345adce24775675ed3fd4d7ccbf9c1ef0f3de9d9c8f8f9c1fbc7e6c9e98d89e8ee9a7c191e51f3957132cdbfd6b37e1ff581127b97f86c023b054d71a9cc8df5e797b0f424457105a4c19ca2c3f30b3a46681525f0c11a341222ab9bf9c9d2e3d8e44c63fa9fb8c0e696a9ed2647ee9a4b2e6856e7dbf282e38285f69ae9bccb630c70024d29efd1b884a887562696f7572464175b2c630c8ffd1b7fc5fbd8e4dfb06015691dd0a0a5d07f0b615ff3a888adfaaa84d6246b82c52371f6b73d701f3aa8f57b277320057184f63f5e285c593cc0a7f59c1a7fb3c0663aa79b81ae365983f6a5d11d6dacd93d49c7f93d01c7a2f8804524b7d9fcb0dbba5f31d5b2605eebbba3d167080357a9db1273dcb8d0b5b2c028644928006eb9de93e61273690e42272d11e1cefa9f324af7969ef0b6fa4425137d97f0ecd2b884d8aae58010768de8522060050668f09332570e7dbc822418c4b67c1985e3b4d1e092a7c2f698d3b0afcab789f2a94461431346146a25a7e05f0d7031105da481b9e46c30451583e2d3b0ef84dcbd86e16e0b097a93cffe933d4cea86a692537d7c0c4a29ff9285b978575022dcb94721b3d66715b0d5650bbcdfe287bb851925301f73015732e385660373014520630d6704d3b6d6a56e5085b97c157b15e88ce881c5a6b2d397e3f19ed1a3652ab2c202769af3640bf59bddae92b27201e68383f3cbaa01732a4b2753690c4479280a4e08e584d9b5ec9f1e7b4a685967fdc12f002148e7895c38dbb2c2a1e4850f7bbad51c6e400f7f0f80f4ea83315e3f51c6b51c22675b7d0ec5a0bbc9513811745e2df6c89cda7b1a80ecfa892346310da38c3a49fe9b17654128adc8bccf6f51182485f7117497e3a8fc10696414e1841826276386e92c596f0d345845200a363f1066146e0b9ce892c6126bfd8d2e4b19273d01ef82caab9fe7b5f7492899eb2251480a88e9cba83f546d534777fec29cb33b5692f3f189dd9f8dec720047346b29046537547f1482bcd9e5ef8ad6b80b6a4a28d7bb9ffaa7e60468fe9b5f2d4e3a8ffc360844020c6d1b7793e0d9bca79b684750351e7016776604c7ab5f3a4100224ee782f082d6a26714112f566a1b7e5e305c3d4e2cfa961e7b98db264bcdb9b4c6374e9fa1a5e39dfca9c5c3b0e683ab9758771174deb07b1a23410a661e7bc28197fae39796e46019b7891a26a8cdf29ce2835f3d5539d1b46c254e201f6b9be9d4b5d2b0d5b4780a6b554402e988bcd08efd6e0ba09c96b9dcb90a648feeb4d6c3af7015c9802d431165d2a05d3c4a28b3d235474779bb875877a3ce1d7233577d08aac60663ae906c55643e1d6786a19ece08d1124a8c47
</metadata>
//+------------------------------------------------------------------+
//|                                                  MACD Sample.mq4 |
//|                      Copyright _ 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+

extern double TakeProfit = 500;
extern double Lots = 0.1;
extern double TrailingStop = 300;
extern double MACDOpenLevel=30;
extern double MACDCloseLevel=20;
extern double MATrendPeriod=26;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double MacdCurrent, MacdPrevious, SignalCurrent;
   double SignalPrevious, MaCurrent, MaPrevious;
   int cnt, ticket, total;
// initial data checks
// it is important to make sure that the expert works with a normal
// chart and the user did not make any mistakes setting external 
// variables (Lots, StopLoss, TakeProfit, 
// TrailingStop) in our case, we check TakeProfit
// on a chart of less than 100 bars
   if(Bars<100)
     {
      Print("bars less than 100");
      return(0);  
     }
   if(TakeProfit<10)
     {
      Print("TakeProfit less than 10");
      return(0);  // check TakeProfit
     }
// to simplify the coding and speed up access
// data are put into internal variables
   MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   MaCurrent=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,0);
   MaPrevious=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,1);

   total=OrdersTotal();
   if(total<1) 
     {
      // no opened orders identified
      if(AccountFreeMargin()<(1000*Lots))
        {
         Print("We have no money. Free Margin = ", AccountFreeMargin());
         return(0);  
        }
      // check for long position (BUY) possibility
      if(MacdCurrent<0 && MacdCurrent>SignalCurrent && MacdPrevious<SignalPrevious &&
         MathAbs(MacdCurrent)>(MACDOpenLevel*Point) && MaCurrent>MaPrevious)
        {
         ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*Point,"macd sample",16384,0,Green);
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
           }
         else Print("Error opening BUY order : ",GetLastError()); 
         return(0); 
        }
      // check for short position (SELL) possibility
      if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious && 
         MacdCurrent>(MACDOpenLevel*Point) && MaCurrent<MaPrevious)
        {
         ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit*Point,"macd sample",16384,0,Red);
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
           }
         else Print("Error opening SELL order : ",GetLastError()); 
         return(0); 
        }
      return(0);
     }
   // it is important to enter the market correctly, 
   // but it is more important to exit it correctly...   
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&   // check for opened position 
         OrderSymbol()==Symbol())  // check for symbol
        {
         if(OrderType()==OP_BUY)   // long position is opened
           {
            // should it be closed?
            if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious &&
               MacdCurrent>(MACDCloseLevel*Point))
                {
                 OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet); // close position
                 return(0); // exit
                }
            // check for trailing stop
            if(TrailingStop>0)  
              {                 
               if(Bid-OrderOpenPrice()>Point*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-Point*TrailingStop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green);
                     return(0);
                    }
                 }
              }
           }
         else // go to short position
           {
            // should it be closed?
            if(MacdCurrent<0 && MacdCurrent>SignalCurrent &&
               MacdPrevious<SignalPrevious && MathAbs(MacdCurrent)>(MACDCloseLevel*Point))
              {
               OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet); // close position
               return(0); // exit
              }
            // check for trailing stop
            if(TrailingStop>0)  
              {                 
               if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red);
                     return(0);
                    }
                 }
              }
           }
        }
     }
   return(0);
  }
// the end.