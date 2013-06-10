#include <stdlib.mqh>


//+------------------------------------------------------------------+
// -- Indicator Parameters
//+------------------------------------------------------------------+
extern string _s1 = "-----  Indicator Parameters  -------------------";
extern int pMACD_1 = 18; 
extern int pMACD_2 = 35; 
extern int pMACD_3 = 25; 
extern int pMACD_4 = 2; 
extern int pMACD_5 = 2; 
extern int pMACD_6 = 26; 
extern int pMACD_7 = 18; 
extern int pMACD_8 = 35; 
extern int pMACD_9 = 25; 
extern int pMACD_10 = 2; 
extern int pMACD_11 = 2; 
extern int pMACD_12 = 26; 


//+------------------------------------------------------------------+
// -- SL/PT Parameters
//+------------------------------------------------------------------+
extern string __s2 = "-----  SL/PT Parameters  ----------------------";
extern int LongStopLoss = 40;
extern int LongProfitTarget = 30;
extern int ShortStopLoss = 40;
extern int ShortProfitTarget = 30;

extern double MinimumSLPT = 15;
extern double MaximumSLPT = 50;


//+------------------------------------------------------------------+
// -- Move to Break Even Parameters
//+------------------------------------------------------------------+
extern string __s3 = "-----  Move to Break Even Parameters  ---------";
extern int LongBreakEvenAtPipsProfit = 0;
extern int ShortBreakEvenAtPipsProfit = 0;


//+------------------------------------------------------------------+
// -- Trailing Stop Parameters
//+------------------------------------------------------------------+
extern string __s4 = "-----  Trailing Stop Parameters  --------------";
extern int LongTrailingStopPips = 0;
extern int ShortTrailingStopPips = 0;

int LongExpirationAfterBars = 0;
int ShortExpirationAfterBars = 0;


//+------------------------------------------------------------------+
// -- Money Management Parameters
//+------------------------------------------------------------------+
extern string __s6 = "-----  Money Management Parameters  -----------";
extern bool UseMoneyManagement = false;
extern double Lots = 0.1;
extern int LotsDecimals = 2;
extern double RiskInPercent = 2.0;
extern double MaximumLots = 0.5;


//+------------------------------------------------------------------+
// -- Trading Logic Settings
//+------------------------------------------------------------------+
extern string __s7 = "-----  Trading Logic Settings  ----------------";
extern bool LimitTradingToRange = false;
extern string TradingRangeFrom = "08:00";
extern string TradingRangeTo = "16:00";
extern bool ExitAtEndOfDayOrRange = false;
extern bool ExitPendingEndOfDayOrRange = false;
extern int MaxTradesPerDay = 0; // 0 means unlimited
extern string FridayEndOfTrading = ""; 
extern bool EnterOnlyOncePerBar = false; // 0 means unlimited

//+------------------------------------------------------------------+
// -- Trading Date Parameters
//+------------------------------------------------------------------+
extern string __s8 = "-----  Trading Date Parameters  ---------------";
extern bool TradeSunday = false;
extern bool TradeMonday = true;
extern bool TradeTuesday = true;
extern bool TradeWednesday = true;
extern bool TradeThursday = true;
extern bool TradeFriday = true;
extern bool TradeSaturday = false;


//+------------------------------------------------------------------+
// -- Other Parameters
//+------------------------------------------------------------------+
extern string __s9 = "-----  Other Parameters  ----------------------";
extern int MaxSlippage = 3;
extern string CustomComment = "Strategy 2.320";
extern int MagicNumber = 12345;
extern bool TradeLong = true;
extern bool TradeShort = true;
extern bool HandleSLPTByEA = false;
extern bool EmailNotificationOnTrade = false;

//+------------------------------------------------------------------+
// -- Other Hidden Parameters
//+------------------------------------------------------------------+
int MinDistanceOfStopFromPrice = 5;
double gPointPow = 0;
double gPointCoef = 0;
double gbSpread = 1.5;
double brokerStopDifference = 0;
string eaStopDifference = "";
double eaStopDifferenceNumber = 0;
int lastHistoryPosChecked = 0;
int lastHistoryPosCheckedNT = 0;
string currentTime = "";
string lastTime = "";
bool tradingRangeReverted = false;


//+------------------------------------------------------------------+
// -- Functions
//+------------------------------------------------------------------+

int init() {
   Log("--------------------------------------------------------");
   Log("Starting the EA");

   double realDigits;
   if(Digits < 2) {
      realDigits = 0;
   } else if (Digits < 4) {
      realDigits = 2;
   } else {
      realDigits = 4;
   }

   gPointPow = MathPow(10, realDigits);
   gPointCoef = 1/gPointPow;

   eaStopDifferenceNumber = MinDistanceOfStopFromPrice/gPointPow;
   
   eaStopDifference = DoubleToStr(MinDistanceOfStopFromPrice, 2);
   Log("Broker Stop Difference: ",DoubleToStr(brokerStopDifference*gPointPow, 2),", EA Stop Difference: ",eaStopDifference);

   if(DoubleToStr(brokerStopDifference*gPointPow, 2) != eaStopDifference) {
      Log("WARNING! EA Stop Difference is different from real Broker Stop Difference, the backtest results in MT4 could be different from results of Genetic Builder!");
   }

   string brokerSpread = DoubleToStr((Ask - Bid)*gPointPow, 2);
   string strGbSpread = DoubleToStr(gbSpread, 2);
   Log("Broker spread: ",brokerSpread,", Genetic Builder test spread: ",strGbSpread);

   if(strGbSpread != brokerSpread) {
      Log("WARNING! Real Broker spread is different from spread used in Genetic Builder, the backtest results in MT4 could be different from results of Genetic Builder!");
   }

   if(StrToTime(TradingRangeTo) < StrToTime(TradingRangeFrom)) {
      tradingRangeReverted = true;
      Log("Trading range s reverted, from: ", TradingRangeFrom," to ", TradingRangeTo);
   } else {
      tradingRangeReverted = false;
   }
   
   Log("--------------------------------------------------------");

   return(0);
}

//+------------------------------------------------------------------+

int start() {
   if(Bars<30) {
      Print("NOT ENOUGH DATA: Less Bars than 30");
      return(0);
   }

   if(!manageEntriesAndPositions()) {
      return(0);
   }
   
   // LONG: (MACD(18, 35, 25) Crosses Below MACD(2, 2, 26))

   if(TradeLong) {
      bool LongEntryCondition = ((iMACD(NULL, 0, pMACD_1, pMACD_2, pMACD_3, PRICE_CLOSE, MODE_MAIN, 2) > iMACD(NULL, 0, pMACD_4, pMACD_5, pMACD_6, PRICE_CLOSE, MODE_MAIN, 2)) && (iMACD(NULL, 0, pMACD_1, pMACD_2, pMACD_3, PRICE_CLOSE, MODE_MAIN, 1) < iMACD(NULL, 0, pMACD_4, pMACD_5, pMACD_6, PRICE_CLOSE, MODE_MAIN, 1)));
      if(LongEntryCondition == true) {
         openPosition(1);
      }
   }
   
   // SHORT: (MACD(18, 35, 25) Crosses Above MACD(2, 2, 26))

   if(TradeShort) {
      bool ShortEntryCondition = ((iMACD(NULL, 0, pMACD_7, pMACD_8, pMACD_9, PRICE_CLOSE, MODE_MAIN, 2) < iMACD(NULL, 0, pMACD_10, pMACD_11, pMACD_12, PRICE_CLOSE, MODE_MAIN, 2)) && (iMACD(NULL, 0, pMACD_7, pMACD_8, pMACD_9, PRICE_CLOSE, MODE_MAIN, 1) > iMACD(NULL, 0, pMACD_10, pMACD_11, pMACD_12, PRICE_CLOSE, MODE_MAIN, 1)));
      if(ShortEntryCondition == true) {
         openPosition(-1);
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

bool manageEntriesAndPositions() {
   if(getMarketPosition() != 0) {
      manageTradeSLPT();
      manageTrade();
   }
   
   if(getMarketPosition() != 0 && ExitAtEndOfDayOrRange && (!LimitTradingToRange || !tradingRangeReverted)) {
      if(FridayEndOfTrading != "00:00" && FridayEndOfTrading != "0:00" && FridayEndOfTrading != "") {
         // close trade at the specified time of friday
         if(TimeDayOfWeek(Time[0]) == 5 && TimeCurrent() >= StrToTime(FridayEndOfTrading)) { 
            closePositionAtMarket();
         }
      }
      
      closeTradeFromPreviousDay();
   }

   if(LimitTradingToRange) {
      if(checkInsideTradingRange() == false) {
         // we are out of allowed trading hours
         if(ExitAtEndOfDayOrRange) {
            if(tradingRangeReverted == false && TimeCurrent() > StrToTime(TradingRangeTo)) {
               closePositionAtMarket();
               if(ExitPendingEndOfDayOrRange) {
                  closePendingOrders();
               }
            } else if(tradingRangeReverted == true && TimeCurrent() > StrToTime(TradingRangeTo) && TimeCurrent() < StrToTime(TradingRangeFrom)) {
               closePositionAtMarket();
               if(ExitPendingEndOfDayOrRange) {
                  closePendingOrders();
               }
            }
         }
         return(false);          
      }   
   }  

   if(!isCorrectDayOfWeek(Time[0])) {
      return(false);
   }
      
   if(MaxTradesPerDay > 0) {
     if(getNumberOfTradesToday() >= MaxTradesPerDay) {
        return(false);
     }
   }
   
   return(true);
}

//+------------------------------------------------------------------+

double gbTrueRange(int period, int index) {
   int period1 = period + index-1; 
   int period2 = period + index; 
   return (MathMax(High[period1], Close[period2]) - MathMin(Low[period1], Close[period2]));
}

//+------------------------------------------------------------------+

double getStopLoss(int tradeDirection) {
   double atrValue;
   
   if(tradeDirection == 1) {
      // long
      if(LongStopLoss > 0) {
         return(checkCorrectMinMaxSLPT(LongStopLoss * gPointCoef));
      }
         } else {
      // short
      if(ShortStopLoss > 0) {
         return(checkCorrectMinMaxSLPT(ShortStopLoss * gPointCoef));
      }
   }
}
 
//+------------------------------------------------------------------+

double getProfitTarget(int tradeDirection) {
   double atrValue;
   
   if(tradeDirection == 1) {
      // long
      if(LongProfitTarget > 0) {
         return(checkCorrectMinMaxSLPT(LongProfitTarget * gPointCoef));
      }
   } else {
      // short
      if(ShortProfitTarget > 0) {
         return(checkCorrectMinMaxSLPT(ShortProfitTarget * gPointCoef));
      }
   }
} 

//+------------------------------------------------------------------+

double getTradeOpenPrice(int tradeDirection) {
   double rangeValue;

   RefreshRates();
   
   if(tradeDirection == 1) {
      // long
      return(Ask);
   } else {
      // short
      return(Bid);
   }
}

//+------------------------------------------------------------------+

void openPosition(int tradeDirection) {
   if(tradeDirection == 0) return(0);
   
   if(checkTradeClosedThisMinute()) {
      return(0);
   }        

   if(EnterOnlyOncePerBar && checkTradeClosedThisBar()) {
      return(0);
   }
   //---------------------------------------
   // get order price
   double openPrice = NormalizeDouble(getTradeOpenPrice(tradeDirection), Digits);
   
   //---------------------------------------
   // get order type
   int orderType;
   if(tradeDirection == 1) {
      if(getMarketPosition() != 0) return;

      orderType = OP_BUY;

   } else {
      if(getMarketPosition() != 0) return;

      orderType = OP_SELL;

   }

   if(orderType != OP_BUY && orderType != OP_SELL) {
      // it is stop or limit order
      double AskOrBid;
      if(tradeDirection == 1) { AskOrBid = Ask; } else { AskOrBid = Bid; }

      // check if stop/limit price isn't too close   
      if(NormalizeDouble(MathAbs(openPrice - AskOrBid), Digits) <= NormalizeDouble(eaStopDifferenceNumber, Digits)) {
         //Log("stop/limit order is too close to actual price");
         return(0);
      }

      // check price according to order type
      if(orderType == OP_BUYSTOP) {
         if(AskOrBid >= openPrice) return(0);
      } else if(orderType == OP_SELLSTOP) {
         if(AskOrBid <= openPrice) return(0);
         
      } else if(orderType == OP_BUYLIMIT) {
         if(AskOrBid <= openPrice) return(0);
      } else if(orderType == OP_SELLLIMIT) {
         if(AskOrBid >= openPrice) return(0);
      }
      
      // there can be only one active order of the same type
      if(checkPendingOrderAlreadyExists(orderType)) {
         return(0);
      }
   }
            
   //---------------------------------------
   // add SL/PT
   double stopLoss = 0;
   double profitTarget = 0;

   double SL = NormalizeDouble(getStopLoss(tradeDirection), Digits);
   double PT = NormalizeDouble(getProfitTarget(tradeDirection), Digits);

   if(SL != 0) {
      stopLoss = openPrice - tradeDirection * SL;
   }
   if(PT != 0) {
      profitTarget = openPrice + tradeDirection * PT;
   }
   
   string comment = CustomComment;
   if(HandleSLPTByEA) {
      comment = "_SL:"+DoubleToStr(stopLoss, Digits)+"_PT:"+DoubleToStr(profitTarget, Digits)+"_ND";
   }        
   
   double orderLots = getLots(SL*gPointPow);
   if(orderLots > MaximumLots) {
      orderLots = MaximumLots;
   }
      
   //---------------------------------------
   // send order
   int error, ticket;
   Log("Opening order, direction: ", orderType,", price: ", openPrice, ", Ask: ", Ask, ", Bid: ", Bid);
   ticket = OrderSend(Symbol(), orderType, orderLots, openPrice, MaxSlippage, 0, 0, comment, MagicNumber, 0, Green);
   if(ticket < 0) {
      // order failed, write error to log
      error = GetLastError();
      Log("Error opening order: ",error, " : ", ErrorDescription(error));
      return;
   }

   OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES); 
   Log("Order opened: ", OrderTicket(), " at price:", OrderOpenPrice());
      
   if(EmailNotificationOnTrade) {
      SendMail("GB Strategy - Order opened", getNotificationText());
   }

   // set up stop loss and profit target");
   // It has to be done separately to support ECN brokers
   if(stopLoss != 0 || profitTarget != 0) {
      if(!HandleSLPTByEA) {
         Log("Setting SL/PT, SL: ", stopLoss, ", PT: ", profitTarget);
         if(OrderModify(ticket, OrderOpenPrice(), stopLoss, profitTarget, 0, 0)) {
            Log("Order modified, StopLoss: ", OrderStopLoss(),", Profit Target: ", OrderTakeProfit());
         } else {
            Log("Error modifying order: ",error, " : ", ErrorDescription(error));
         }
      }
   }
}

//+------------------------------------------------------------------+
/**
 * manage trade - move SL to break even or trailing stop 
 */
void manageTrade() {
   double newSL, atrValue;
   double activeBEAtPipsProfit;
   double activeTrailingStopProfit;
   
   for(int i=0; i<OrdersTotal(); i++) { 
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         activeBEAtPipsProfit = 0;
         
         if (OrderType() == OP_BUY) {
            // TRAILING STOP
            if (LongTrailingStopPips > 0) {
               activeTrailingStopProfit = LongTrailingStopPips * gPointCoef;
            }
            
            if(activeTrailingStopProfit > 0) {
               newSL = Bid - activeTrailingStopProfit;
               if (OrderStopLoss() < newSL && !doublesAreEqual(OrderStopLoss(), newSL)) {
                  OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0);
               }
            }
            
            
            // SET STOP TO BREAK EVEN
            if (LongBreakEvenAtPipsProfit > 0) {
               activeBEAtPipsProfit = LongBreakEvenAtPipsProfit * gPointCoef;
            }
            
            if(activeBEAtPipsProfit > 0) {
               newSL = OrderOpenPrice();
               if (Bid - OrderOpenPrice() >= activeBEAtPipsProfit && OrderStopLoss() < newSL && !doublesAreEqual(OrderStopLoss(), newSL)) {
                  OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0);
               }
            }
         }
         else if (OrderType() == OP_SELL) {
            // TRAILING STOP
            if (ShortTrailingStopPips > 0) {
               activeTrailingStopProfit = ShortTrailingStopPips * gPointCoef;
            }
            
            if(activeTrailingStopProfit > 0) {
               newSL = Ask + activeTrailingStopProfit;
               if (OrderStopLoss() > newSL && !doublesAreEqual(OrderStopLoss(), newSL)) {
                  OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0);
               }
            }
            

            // SET STOP TO BREAK EVEN
            if (ShortBreakEvenAtPipsProfit > 0) {
               activeBEAtPipsProfit = ShortBreakEvenAtPipsProfit * gPointCoef;
            }

            if (activeBEAtPipsProfit > 0) {
               newSL = OrderOpenPrice();
               if (OrderOpenPrice() - Ask >= activeBEAtPipsProfit && OrderStopLoss() > newSL && !doublesAreEqual(OrderStopLoss(), newSL)) {
                  OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0);
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+

bool checkPendingOrderAlreadyExists(int orderType) {
   for(int i=0; i<OrdersTotal(); i++) { 
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() && OrderType() == orderType) {
         return(true);
      }
   }
}

//+------------------------------------------------------------------+

int getMarketPosition() {
   for(int i=0; i<OrdersTotal(); i++) { 
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         if(OrderType() == OP_BUY) {
            return(1);
         }
         if(OrderType() == OP_SELL) {
            return(-1);
       }
     }
   }

   return(0);
}

//+------------------------------------------------------------------+

bool checkItIsPendingOrder() {
   if(OrderType() != OP_BUY && OrderType() != OP_SELL) {
     return(true);
   }
}

//+------------------------------------------------------------------+

bool selectOrderByMagicNumber() {
   for(int i=0; i<OrdersTotal(); i++) { 
     if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
       
       return(true);
     }
   }
   
   return(false);
}

//+------------------------------------------------------------------+

bool selectOpenOrderByMagicNumber() {
   for(int i=0; i<OrdersTotal(); i++) { 
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
      
         if(checkItIsPendingOrder()) {
            continue;
         }
      
         return(true);
      }
   }
   
   return(false);
}

//+------------------------------------------------------------------+

void closePositionAtMarket() {
   if(selectOpenOrderByMagicNumber()) {
      RefreshRates();
      double priceCP;
      
      if(OrderType() == OP_BUY) {
         priceCP = Bid;
      } else {
         priceCP = Ask;
      }
      
      OrderClose(OrderTicket(), OrderLots(), priceCP, MaxSlippage);
   }
}

//+------------------------------------------------------------------+

void Log(string s1, string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="", string s10="", string s11="", string s12="" ) {
   Print(TimeToStr(TimeCurrent()), " ", s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
}

//+------------------------------------------------------------------+

void closeTradeFromPreviousDay() {
    if(selectOpenOrderByMagicNumber()) {
        if(TimeToStr(Time[0], TIME_DATE) != TimeToStr(OrderOpenTime(), TIME_DATE)) {
            closePositionAtMarket();
        }
    }
}

//+------------------------------------------------------------------+

double getHighest(int period, int shift) {
   double maxnum = -1000;
   
   for(int i=shift; i<shift+period; i++) {
      if(High[i] > maxnum) {
         maxnum = High[i];
      }
   }

   return(maxnum);
}

//+------------------------------------------------------------------+

double getLowest(int period, int shift) {
   double minnum = 1000;
   
   for(int i=shift; i<shift+period; i++) {
      if(Low[i] < minnum) {
         minnum = Low[i];
      }
   }

   return(minnum);
}

//+------------------------------------------------------------------+

void manageOrdersExpiration() {

   currentTime = getPeriodAsStr();
   if(currentTime == lastTime) {
      return;
   }

   int barsOpen = 0;
   int orderType;
   
   for(int i=0; i<OrdersTotal(); i++) { 
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         orderType = OrderType();
         
         if (orderType == OP_BUY || orderType == OP_SELL) {
            continue;
         }
         
         if (LongExpirationAfterBars > 0 && (orderType == OP_BUYLIMIT || orderType == OP_BUYSTOP)) {
            barsOpen = getOpenBarsForOrder(LongExpirationAfterBars);
            if(barsOpen >= LongExpirationAfterBars) {
               OrderDelete(OrderTicket());
            }         
         } else if (ShortExpirationAfterBars > 0 && (orderType == OP_SELLLIMIT || orderType == OP_SELLSTOP)) {
            barsOpen = getOpenBarsForOrder(ShortExpirationAfterBars);
            if(barsOpen >= ShortExpirationAfterBars) {
               OrderDelete(OrderTicket());
            }         
         }
      }
   }
   
   lastTime = currentTime;   
}  

//+------------------------------------------------------------------+

void closePendingOrders() {
   int orderType;

   for(int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         orderType = OrderType();

         if (orderType == OP_BUY || orderType == OP_SELL) {
            continue;
         }

         OrderDelete(OrderTicket());
      }
   }
}

//+------------------------------------------------------------------+

int getOpenBarsForOrder(int expBarsPeriod) {
   datetime opTime = OrderOpenTime();
   datetime currentTime = TimeCurrent();
   
   int numberOfBars = 0;
   for(int i=i; i<expBarsPeriod+10; i++) {
      if(opTime < Time[i]) {
         numberOfBars++;
      }
   }
   
   return(numberOfBars);
}

//+------------------------------------------------------------------+

string getPeriodAsStr() {
   string str = TimeToStr(TimeCurrent(), TIME_DATE);
   int period = Period();
   
   if(period == PERIOD_H4 || period == PERIOD_H1) {
      str = str + TimeHour(TimeCurrent());
   }
   if(period == PERIOD_M30 || period == PERIOD_M15 || period == PERIOD_M5 || period == PERIOD_M1) {
      str = str + " " + TimeToStr(TimeCurrent(), TIME_MINUTES);
   }
   
   return(str);
}

//+------------------------------------------------------------------+

bool checkTradeClosedThisMinute() {
   string currentTime = TimeToStr( TimeCurrent(), TIME_DATE|TIME_MINUTES);
   
   int startAt = lastHistoryPosChecked-10;
   if(startAt < 0) {
      startAt = 0;
   }
   
   for(int i=startAt;i<OrdersHistoryTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         string orderTime = TimeToStr( OrderCloseTime(), TIME_DATE|TIME_MINUTES);
         
         lastHistoryPosChecked = i;
         
         if(orderTime == currentTime) {
            return(true);
         }
      }
   }
   
   return(false);
}

//+------------------------------------------------------------------+

bool checkTradeClosedThisBar() {
   int startAt = lastHistoryPosChecked-10;
   if(startAt < 0) {
      startAt = 0;
   }

   for(int i=startAt;i<OrdersHistoryTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         if(OrderCloseTime() >= Time[0]) {
            return(true);
         }
      }
   }

   return(false);
}

//+------------------------------------------------------------------+

void manageTradeSLPT() {

   if(!HandleSLPTByEA) {
      return(0);
   }
   
   int orderType, posSL, posPT, posND;
   string comment, strSL, strPT;
   double SL, PT;
   
   for(int i=0; i<OrdersTotal(); i++) { 
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         orderType = OrderType();
         
         if (orderType != OP_BUY && orderType != OP_SELL) {
            // order is pending
            continue;
         }

         comment = OrderComment();
         //Log("Found Comment: ", comment);
         
         // find SL and PT values
         posSL = StringFind(comment, "_SL:");
         posPT = StringFind(comment, "_PT:");
         posND = StringFind(comment, "_ND");
         
         if(posSL == -1 || posPT == -1 || posND == -1) {
            // SL / PT not found in comment
            //Log("Pos Not Found");
            continue;
         }
         
         strSL = StringSubstr(comment, posSL+4, posPT-posSL-4);
         strPT = StringSubstr(comment, posPT+4, posND-posPT-4);
         
         //Log("Found SLPT: ", strSL, " - ", strPT);
         SL = StrToDouble(strSL);
         PT = StrToDouble(strPT);
                           
         if (OrderType() == OP_BUY) {
            
            // handle ProfitTarget
            if(PT > 0) {
               if (Bid >= PT) {
                  OrderClose(OrderTicket(), OrderLots(), Bid, 3);
               }
            }
            // handle StopLoss
            if(SL > 0) {
               if (Bid <= SL) {
                  OrderClose(OrderTicket(), OrderLots(), Bid, 3);
               }
            }
         }
         else if (OrderType() == OP_SELL) {
            // handle ProfitTarget
            if(PT > 0) {
               if (Ask <= PT) {
                  OrderClose(OrderTicket(), OrderLots(), Ask, 3);
               }
            }
            
            // handle StopLoss
            if(SL > 0) {
               if (Ask >= SL) {
                  OrderClose(OrderTicket(), OrderLots(), Ask, 3);
               }
            }
            
         }
      }
   }
}

//+------------------------------------------------------------------+

int getNumberOfTradesToday() {
   int startAt = lastHistoryPosCheckedNT-10;
   if(startAt < 0) {
      startAt = 0;
   }

   string currentTime = TimeToStr( TimeCurrent(), TIME_DATE);
   int count = 0;

   for(int i=startAt;i<OrdersHistoryTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         string orderTime = TimeToStr( OrderOpenTime(), TIME_DATE);

         lastHistoryPosCheckedNT = i;

         if(orderTime == currentTime) {
            count++;
         }
      }
   }

   for(i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         orderTime = TimeToStr( OrderOpenTime(), TIME_DATE);

         if(orderTime == currentTime) {
            count++;
         }
      }
   }

   return(count);
}

//+------------------------------------------------------------------+

double getLots(double slSize) {    
   if(slSize <= 0) {
      return(Lots);
   }
      
   if(UseMoneyManagement == false) {
      if(Lots > MaximumLots) {
         return(MaximumLots);
      }
      
      return(Lots);
   }
   
   if(RiskInPercent <0 ) {
      Log("Incorrect RiskInPercent size, it must be above 0");
      return(0);
   }
   double riskPerTrade = (AccountBalance() *  (RiskInPercent / 100.0));
   if(slSize <= 0) {
      Log("Incorrect StopLossPips size, it must be above 0");
      return(0);
   }
   double lotMM1 = NormalizeDouble(riskPerTrade / (slSize * 10.0), LotsDecimals);
   double lotMM;
   double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   if(MathMod(lotMM*100, lotStep*100) > 0) {
      lotMM = lotMM1 - MathMod(lotMM1, lotStep);
   } else {
      lotMM = lotMM1;
   }
   
   lotMM = NormalizeDouble( lotMM, LotsDecimals);
   
   if(MarketInfo(Symbol(), MODE_LOTSIZE)==10000.0) lotMM=lotMM*10.0 ;
   lotMM=NormalizeDouble(lotMM,LotsDecimals);
   
   //Log("Computing lots, risk: ", riskPerTrade, ", lotMM1: ", lotMM1, ", lotStep: ", lotStep, ", lots: ", lotMM);
   double Smallest_Lot = MarketInfo(Symbol(), MODE_MINLOT);
   double Largest_Lot = MarketInfo(Symbol(), MODE_MAXLOT);
   
   if (lotMM < Smallest_Lot) lotMM = Smallest_Lot;
   if (lotMM > Largest_Lot) lotMM = Largest_Lot;
     
   if(lotMM > MaximumLots) {
      lotMM = MaximumLots;
   }   

   //Log("SL size: ", slSize, ", LotMM: ", lotMM);

   return (lotMM);   
}

//+------------------------------------------------------------------+
//+ Heiken Ashi functions
//+------------------------------------------------------------------+

double HeikenAshiOpen(int shift) {
   return(iCustom( NULL, 0, "Heiken Ashi", 0,0,0,0, 2, shift));
}

double HeikenAshiClose(int shift) {
   return(iCustom( NULL, 0, "Heiken Ashi", 0,0,0,0, 3, shift));
}

double HeikenAshiHigh(int shift) {
   return(MathMax(iCustom( NULL, 0, "Heiken Ashi", 0,0,0,0, 0, shift), iCustom( NULL, 0, "Heiken Ashi", 0,0,0,0, 1, shift)));
}

double HeikenAshiLow(int shift) {
   return(MathMin(iCustom( NULL, 0, "Heiken Ashi", 0,0,0,0, 0, shift), iCustom( NULL, 0, "Heiken Ashi", 0,0,0,0, 1, shift)));
}

//+------------------------------------------------------------------+
//+ Simple rules functions
//+------------------------------------------------------------------+

bool ruleCloseAboveBB() {
   return (Close[1] > iBands(NULL,0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1)) ;
}

bool ruleCloseBelowBB() {
   return (Close[1] < iBands(NULL,0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1)) ;
}

bool ruleCloseAbovePSAR() {
   return (Close[1] > iSAR(NULL,0, 0.02, 0.2, 1)) ;
}

bool ruleCloseBelowPSAR() {
   return (Close[1] < iSAR(NULL,0, 0.02, 0.2, 1)) ;
}

bool ruleMACD_Above() {
   return (iMACD(NULL,0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1) > 0) ;
}

bool ruleMACD_Below() {
   return (iMACD(NULL,0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1) < 0) ;
}

bool ruleLongTermRSI_Above() {
   return (iRSI(NULL,0,40,PRICE_CLOSE,1) > 50) ;
}

bool ruleLongTermRSI_Below() {
   return (iRSI(NULL,0,40,PRICE_CLOSE,1) < 50) ;
}

bool ruleShortTermRSI_Above() {
   return (iRSI(NULL,0,20,PRICE_CLOSE,1) > 50) ;
}

bool ruleShortTermRSI_Below() {
   return (iRSI(NULL,0,20,PRICE_CLOSE,1) < 50) ;
}

bool ruleLongTermStoch_Above() {
   return (iStochastic(NULL,0, 40, 1, 3, MODE_SMA, 0, 1, 1) > 50) ;
}

bool ruleLongTermStoch_Below() {
   return (iStochastic(NULL,0, 40, 1, 3, MODE_SMA, 0, 1, 1) < 50) ;
}

bool ruleShortTermStoch_Above() {
   return (iStochastic(NULL,0, 20, 1, 3, MODE_SMA, 0, 1, 1) > 50) ;
}

bool ruleShortTermStoch_Below() {
   return (iStochastic(NULL,0, 20, 1, 3, MODE_SMA, 0, 1, 1) < 50) ;
}

bool ruleLongTermCCI_Above() {
   return (iCCI(NULL,0,40,PRICE_TYPICAL,1) > 0) ;
}

bool ruleLongTermCCI_Below() {
   return (iCCI(NULL,0,40,PRICE_TYPICAL,1) < 0) ;
}

bool ruleShortTermCCI_Above() {
   return (iCCI(NULL,0,20,PRICE_TYPICAL,1) > 0) ;
}

bool ruleShortTermCCI_Below() {
   return (iCCI(NULL,0,20,PRICE_TYPICAL,1) < 0) ;
}

bool ruleVolumeAboveAvg() {
   return (Volume[1] > iCustom(NULL,0, "AvgVolume", 50, 1, 1)) ;
}

bool ruleVolumeBelowAvg() {
   return (Volume[1] < iCustom(NULL,0, "AvgVolume", 50, 1, 1)) ;
}

//+------------------------------------------------------------------+
//+ Candle Pattern functions
//+------------------------------------------------------------------+

bool candlePatternBearishEngulfing(int shift) {
   double O = Open[shift];
   double O1 = Open[shift+1];
   double C = Close[shift];
   double C1 = Close[shift+1];

   if ((C1>O1)&&(O>C)&&(O>=C1)&&(O1>=C)&&((O-C)>(C1-O1))) {
      return(true);
   }
      
   return(false);
}

//+------------------------------------------------------------------+

bool candlePatternBullishEngulfing(int shift) {
   double O = Open[shift];
   double O1 = Open[shift+1];
   double C = Close[shift];
   double C1 = Close[shift+1];

   if ((O1>C1)&&(C>O)&&(C>=O1)&&(C1>=O)&&((C-O)>(O1-C1))) {
      return(true);
   }
      
   return(false);
}

//+------------------------------------------------------------------+

bool candlePatternDarkCloudCover(int shift) {
   double L = Low[shift];
   double H = High[shift];

   double O = Open[shift];
   double O1 = Open[shift+1];
   double C = Close[shift];
   double C1 = Close[shift+1];
   double CL = H-L;

   double OC_HL;
   if((H - L) != 0) {
      OC_HL = (O-C)/(H-L);
   } else {
      OC_HL = 0;
   }

   double Piercing_Line_Ratio = 0.5;
   double Piercing_Candle_Length = 10;
   
   if ((C1>O1)&&(((C1+O1)/2)>C)&&(O>C)&&(C>O1)&&(OC_HL>Piercing_Line_Ratio)&&((CL>=Piercing_Candle_Length*gPointCoef))) {
      return(true);
   }
   
   return(false);
}

//+------------------------------------------------------------------+

bool candlePatternDoji(int shift) {
   if(MathAbs(Open[shift] - Close[shift])*gPointPow < 0.6) {
      return(true);
   }
   return(false);
}

//+------------------------------------------------------------------+

bool candlePatternHammer(int shift) {
   double H = High[shift];
   double L = Low[shift];
   double L1 = Low[shift+1];
   double L2 = Low[shift+2];
   double L3 = Low[shift+3];
      
   double O = Open[shift];
   double C = Close[shift];
   double CL = H-L;
      
   double BodyLow, BodyHigh;
   double Candle_WickBody_Percent = 0.9;
   double CandleLength = 12;
      
   if (O > C) {
      BodyHigh = O;
      BodyLow = C;  
   } else {
      BodyHigh = C;
      BodyLow = O; 
   }
      
   double LW = BodyLow-L;
   double UW = H-BodyHigh;
   double BLa = MathAbs(O-C);
   double BL90 = BLa*Candle_WickBody_Percent;
      
   double pipValue = gPointCoef;
      
   if ((L<=L1)&&(L<L2)&&(L<L3))  {
      if (((LW/2)>UW)&&(LW>BL90)&&(CL>=(CandleLength*pipValue))&&(O!=C)&&((LW/3)<=UW)&&((LW/4)<=UW)/*&&(H<H1)&&(H<H2)*/)  {
         return(true);
      }
      if (((LW/3)>UW)&&(LW>BL90)&&(CL>=(CandleLength*pipValue))&&(O!=C)&&((LW/4)<=UW)/*&&(H<H1)&&(H<H2)*/)  {
         return(true);
      }
      if (((LW/4)>UW)&&(LW>BL90)&&(CL>=(CandleLength*pipValue))&&(O!=C)/*&&(H<H1)&&(H<H2)*/)  {
         return(true);
      }
   }
   
   return(false);
}

//+------------------------------------------------------------------+

bool candlePatternPiercingLine(int shift) {
   double L = Low[shift];
   double H = High[shift];

   double O = Open[shift];
   double O1 = Open[shift+1];
   double C = Close[shift];
   double C1 = Close[shift+1];
   double CL = H-L;

   double CO_HL;
   if((H - L) != 0) {
      CO_HL = (C-O)/(H-L);
   } else {
      CO_HL = 0;
   }

   double Piercing_Line_Ratio = 0.5;
   double Piercing_Candle_Length = 10;

   if ((C1<O1)&&(((O1+C1)/2)<C)&&(O<C) && (CO_HL>Piercing_Line_Ratio)&&(CL>=(Piercing_Candle_Length*gPointCoef))) {
      return(true);
   }
   
   return(false);
}

//+------------------------------------------------------------------+

bool candlePatternShootingStar(int shift) {
   double L = Low[shift];
   double H = High[shift];
   double H1 = High[shift+1];
   double H2 = High[shift+2];
   double H3 = High[shift+3];
      
   double O = Open[shift];
   double C = Close[shift];
   double CL = H-L;
      
   double BodyLow, BodyHigh;
   double Candle_WickBody_Percent = 0.9;
   double CandleLength = 12;
      
   if (O > C) {
      BodyHigh = O;
      BodyLow = C;  
   } else {
      BodyHigh = C;
      BodyLow = O; 
   }
      
   double LW = BodyLow-L;
   double UW = H-BodyHigh;
   double BLa = MathAbs(O-C);
   double BL90 = BLa*Candle_WickBody_Percent;
      
   double pipValue = gPointCoef;
      
   if ((H>=H1)&&(H>H2)&&(H>H3))  {
      if (((UW/2)>LW)&&(UW>(2*BL90))&&(CL>=(CandleLength*pipValue))&&(O!=C)&&((UW/3)<=LW)&&((UW/4)<=LW)/*&&(L>L1)&&(L>L2)*/)  {
         return(true);
      }
      if (((UW/3)>LW)&&(UW>(2*BL90))&&(CL>=(CandleLength*pipValue))&&(O!=C)&&((UW/4)<=LW)/*&&(L>L1)&&(L>L2)*/)  {
         return(true);
      }
      if (((UW/4)>LW)&&(UW>(2*BL90))&&(CL>=(CandleLength*pipValue))&&(O!=C)/*&&(L>L1)&&(L>L2)*/)  {
         return(true);
      }
   }
   
   return(false);
}

//+------------------------------------------------------------------+

bool checkInsideTradingRange() {
   if(tradingRangeReverted == false && (TimeCurrent() < StrToTime(TradingRangeFrom) || TimeCurrent() > StrToTime(TradingRangeTo))) {
      return(false);
   } else if(tradingRangeReverted == true && (TimeCurrent() > StrToTime(TradingRangeTo) && TimeCurrent() < StrToTime(TradingRangeFrom))) {
      return(false);
   }         
   
   return(true);
}

//+------------------------------------------------------------------+

bool isCorrectDayOfWeek(datetime time) {
   int dow = TimeDayOfWeek(time);
   
   if(!TradeSunday && dow == 0) { return(false); }
   if(!TradeMonday && dow == 1) { return(false); }
   if(!TradeTuesday && dow == 2) { return(false); }
   if(!TradeWednesday && dow == 3) { return(false); }
   if(!TradeThursday && dow == 4) { return(false); }
   if(!TradeFriday && dow == 5) { return(false); }
   if(!TradeSaturday && dow == 6) { return(false); }
   
   return(true);
}


//+------------------------------------------------------------------+

bool doublesAreEqual(double n1, double n2) {
   string s1 = DoubleToStr(n1, Digits);
   string s2 = DoubleToStr(n2, Digits);
   
   return (s1 == s2);
}

//+------------------------------------------------------------------+
 
double checkCorrectMinMaxSLPT(double slptValue) {
   double slptMin = MinimumSLPT * gPointCoef;
   
   if(MinimumSLPT > 0) {
      slptValue = MathMax(MinimumSLPT * gPointCoef, slptValue);
   }
   if(MaximumSLPT > 0) {
      slptValue = MathMin(MaximumSLPT * gPointCoef, slptValue);
   }
   
   return (slptValue);
}

//+------------------------------------------------------------------+

string getNotificationText() {
   string text = TimeToStr(TimeCurrent());
   text = StringConcatenate(text, " New Order Opened\n\n");

   text = StringConcatenate(text, " Order ticket: ", OrderTicket(),"\n");

   switch(OrderType()) {
      case OP_BUY: text = StringConcatenate(text, " Direction : Buy\n"); break;
      case OP_SELL: text = StringConcatenate(text, " Direction : Sell\n"); break;
      case OP_BUYLIMIT: text = StringConcatenate(text, " Direction : Buy Limit\n"); break;
      case OP_SELLLIMIT: text = StringConcatenate(text, " Direction : Sell Limit\n"); break;
      case OP_BUYSTOP: text = StringConcatenate(text, " Direction : Buy Stop\n"); break;
      case OP_SELLSTOP: text = StringConcatenate(text, " Direction : Sell Stop\n"); break;
   }

   text = StringConcatenate(text, " Open price: ", OrderOpenPrice(),"\n");

   text = StringConcatenate(text, " Lots: ", OrderLots(),"\n");

   return(text);
}
