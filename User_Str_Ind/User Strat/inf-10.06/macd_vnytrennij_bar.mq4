extern int MA;
extern int FastMACD;
extern int SlowMACD;
extern int SignalMACD;
extern double FiltrBar;
extern bool StopFiltr;
extern int HighLow;
extern int OrderOpenMax;
extern int Order2_Minute;
extern int Shift;
extern double TakeProfit;
extern int TakeProfit2;
extern double kProfit;
extern int Paritet;
extern int Paritet_Shift;
extern int Paritet2;
extern double Lots;
extern double Lots2;
extern double Filtr;
extern int MagicNumber;
extern int MagicNumber2;
double g_price_184;
double g_price_192;
double g_price_208;
double g_price_216;
double g_price_224;
double g_price_232;
bool gi_240;
bool gi_244;
bool gi_248;
bool gi_252;
bool gi_256;
bool gi_260;
int g_pos_264;
int g_ticket_268;
int g_datetime_272;
int g_count_276;
int gi_280;
double g_price_284;
double g_price_292;
double g_price_300;
double g_price_308;
double g_price_316;
double g_price_324;
int gi_332;
int gi_336;
int g_datetime_340;
bool gi_344;
bool gi_348;
bool gi_352;
double gd_356;
string g_comment_364 = "macd_vnytrennij_bar";

int start() {
   gi_240 = FALSE;
   gi_244 = FALSE;
   for (g_pos_264 = 0; g_pos_264 < OrdersTotal(); g_pos_264++) {
      if (OrderSelect(g_pos_264, SELECT_BY_POS, MODE_TRADES) == TRUE) {
         if (OrderMagicNumber() == MagicNumber2 && Symbol() == OrderSymbol()) {
            gi_332 = TimeMinute(OrderOpenTime()) + Order2_Minute;
            for (gi_336 = TimeHour(OrderOpenTime()); gi_332 >= 60; gi_336++) gi_332 -= 60;
            if (OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT)
               if ((gi_332 <= TimeMinute(TimeCurrent()) && gi_336 == TimeHour(TimeCurrent())) || gi_260 == TRUE) OrderDelete(OrderTicket());
            if (OrderType() == OP_BUY) {
               if (Paritet2 == 0) gd_356 = (OrderTakeProfit() - OrderOpenPrice()) / 2.0 + OrderOpenPrice();
               else gd_356 = Paritet2;
               if (OrderOpenPrice() + gd_356 * Point <= Bid)
                  if (OrderOpenPrice() != OrderStopLoss()) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice(), OrderTakeProfit(), 0, Green);
            }
            if (OrderType() == OP_SELL) {
               if (Paritet2 == 0) gd_356 = OrderOpenPrice() - (OrderOpenPrice() - OrderTakeProfit()) / 2.0;
               else gd_356 = Paritet2;
               if (OrderOpenPrice() - gd_356 * Point >= Ask)
                  if (OrderOpenPrice() != OrderStopLoss()) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice(), OrderTakeProfit(), 0, Green);
            }
         }
         if (OrderMagicNumber() == MagicNumber && Symbol() == OrderSymbol()) {
            if (OrderType() == OP_BUY && g_datetime_340 != OrderOpenTime()) {
               gi_344 = TRUE;
               g_price_284 = NormalizeDouble(OrderOpenPrice() - Shift * Point, MarketInfo(Symbol(), MODE_DIGITS));
               g_price_300 = NormalizeDouble(OrderStopLoss() - Shift * Point, MarketInfo(Symbol(), MODE_DIGITS));
               g_datetime_340 = OrderOpenTime();
               if (TakeProfit2 == 0) g_price_316 = OrderTakeProfit();
               else g_price_316 = g_price_284 + TakeProfit2 * Point;
            }
            if (OrderType() == OP_SELL && g_datetime_340 != OrderOpenTime()) {
               gi_348 = TRUE;
               g_price_292 = NormalizeDouble(OrderOpenPrice() + Shift * Point, MarketInfo(Symbol(), MODE_DIGITS));
               g_price_308 = NormalizeDouble(OrderStopLoss() + Shift * Point, MarketInfo(Symbol(), MODE_DIGITS));
               g_datetime_340 = OrderOpenTime();
               if (TakeProfit2 == 0) g_price_324 = OrderTakeProfit();
               else g_price_324 = g_price_292 - TakeProfit2 * Point;
            }
            if (OrderType() == OP_BUYSTOP || OrderType() == OP_BUY) {
               if (OrderType() == OP_BUYSTOP) {
                  g_ticket_268 = OrderTicket();
                  if (gi_252 == TRUE) OrderDelete(OrderTicket());
               }
               if (OrderType() == OP_BUY) {
                  if (OrderOpenPrice() + Paritet * Point < Bid) gi_260 = TRUE;
                  if (gi_260 == TRUE && OrderOpenPrice() + Paritet_Shift * Point != OrderStopLoss()) {
                     if (gi_256 == FALSE) {
                        if (TrailingStop(Paritet_Shift) != 0) {
                           gi_256 = TRUE;
                           Print("—топ-лос не был переставлен в безубыток. ѕозици€ будет автоматически закрыта при достижении цены уровн€ ", OrderOpenPrice(), ". ¬еличина проскальзывани€ 50 пунктов.");
                        }
                     } else
                        if (TrailingClose(gi_280) != 0) gi_280 += 10;
                  }
               }
               gi_240 = TRUE;
               gi_248 = FALSE;
            }
            if (OrderType() == OP_SELLSTOP || OrderType() == OP_SELL) {
               if (OrderType() == OP_SELLSTOP) {
                  g_ticket_268 = OrderTicket();
                  if (gi_252 == TRUE) OrderDelete(OrderTicket());
               }
               if (OrderType() == OP_SELL) {
                  if (OrderOpenPrice() - Paritet * Point > Ask) gi_260 = TRUE;
                  if (gi_260 == TRUE && OrderOpenPrice() - Paritet_Shift * Point != OrderStopLoss()) {
                     if (gi_256 == FALSE) {
                        if (TrailingStop(-Paritet_Shift) != 0) {
                           gi_256 = TRUE;
                           Print("—топ-лос не был переставлен в безубыток. ѕозици€ будет автоматически закрыта при достижении цены уровн€ ", OrderOpenPrice(), ". ¬еличина проскальзывани€ 50 пунктов.");
                        }
                     } else
                        if (TrailingClose(gi_280) != 0) gi_280 += 10;
                  }
               }
               gi_244 = TRUE;
               gi_248 = FALSE;
            }
         }
      }
   }
   if (gi_344 == TRUE && gi_352 == FALSE) {
      if (OrderSend(Symbol(), OP_BUYLIMIT, Lots2, g_price_284, 0, g_price_300, g_price_316, g_comment_364, MagicNumber2, 0, Green) != 0) gi_352 = TRUE;
      if (GetLastError() != 0/* NO_ERROR */) Print("Buy O ", g_price_284, " S ", g_price_300, " T ", g_price_316);
   }
   if (gi_348 == TRUE && gi_352 == FALSE) {
      if (OrderSend(Symbol(), OP_SELLLIMIT, Lots2, g_price_292, 0, g_price_308, g_price_324, g_comment_364, MagicNumber2, 0, Red) != 0) gi_352 = TRUE;
      if (GetLastError() != 0/* NO_ERROR */) Print("Buy O ", g_price_292, " S ", g_price_308, " T ", g_price_324);
   }
   if (iTime(Symbol(), 0, 1) != g_datetime_272) {
      if (iLow(Symbol(), 0, 1) > iLow(Symbol(), 0, 2) && iHigh(Symbol(), 0, 1) < iHigh(Symbol(), 0, 2) && (iHigh(Symbol(), 0, 2) - iLow(Symbol(), 0, 2)) * FiltrBar > iHigh(Symbol(), 0, 1) - iLow(Symbol(), 0, 1) &&
         iHigh(Symbol(), 0, 1) - iLow(Symbol(), 0, 1) > HighLow * Point && TimeDayOfWeek(iTime(Symbol(), 0, 1)) != 0) {
         gi_344 = FALSE;
         gi_348 = FALSE;
         gi_248 = TRUE;
         gi_352 = FALSE;
         g_count_276 = 0;
         gi_252 = FALSE;
         gi_256 = FALSE;
         gi_260 = FALSE;
         gi_280 = 0;
         if (gi_240 == TRUE || gi_244 == TRUE) {
            if (OrderSelect(g_ticket_268, SELECT_BY_TICKET) == TRUE)
               if (OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) OrderDelete(g_ticket_268);
         }
      } else {
         gi_248 = FALSE;
         g_ticket_268 = 0;
      }
      g_datetime_272 = iTime(Symbol(), 0, 1);
      g_count_276++;
      if (g_count_276 == OrderOpenMax) gi_252 = TRUE;
   }
   if (gi_248 == TRUE) {
      if (iMA(Symbol(), 0, MA, 0, MODE_EMA, PRICE_CLOSE, 1) > iMA(Symbol(), 0, MA, 0, MODE_EMA, PRICE_CLOSE, 2) && gi_240 != TRUE)
         if (iMACD(Symbol(), 0, FastMACD, SlowMACD, SignalMACD, PRICE_CLOSE, MODE_SIGNAL, 1) > iMACD(Symbol(), 0, FastMACD, SlowMACD, SignalMACD, PRICE_CLOSE, MODE_SIGNAL, 2)) OpenBuy();
      if (iMA(Symbol(), 0, MA, 0, MODE_EMA, PRICE_CLOSE, 1) < iMA(Symbol(), 0, MA, 0, MODE_EMA, PRICE_CLOSE, 2) && gi_244 != TRUE)
         if (iMACD(Symbol(), 0, FastMACD, SlowMACD, SignalMACD, PRICE_CLOSE, MODE_SIGNAL, 2) > iMACD(Symbol(), 0, FastMACD, SlowMACD, SignalMACD, PRICE_CLOSE, MODE_SIGNAL, 1)) OpenSell();
   }
   return (0);
}

int TrailingStop(int ai_0) {
   OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + ai_0 * Point, OrderTakeProfit(), 0, Green);
   return (GetLastError());
}

int TrailingClose(int a_slippage_0) {
   if (OrderType() == OP_BUY && OrderOpenPrice() >= Bid) OrderClose(OrderTicket(), Lots, Bid, a_slippage_0, Red);
   if (OrderType() == OP_SELL && OrderOpenPrice() <= Ask) OrderClose(OrderTicket(), Lots, Ask, a_slippage_0, Red);
   return (GetLastError());
}

int OpenBuy() {
   g_price_184 = NormalizeDouble(iHigh(Symbol(), 0, 1) + Filtr * Point + Ask - Bid, MarketInfo(Symbol(), MODE_DIGITS));
   if (StopFiltr == TRUE) g_price_208 = NormalizeDouble(iLow(Symbol(), 0, 1) - Filtr * Point, MarketInfo(Symbol(), MODE_DIGITS));
   else g_price_208 = NormalizeDouble(iLow(Symbol(), 0, 1), MarketInfo(Symbol(), MODE_DIGITS));
   if (TakeProfit == 0.0) g_price_224 = NormalizeDouble(g_price_184 + (g_price_184 - g_price_208) * kProfit, MarketInfo(Symbol(), MODE_DIGITS));
   else g_price_224 = NormalizeDouble(g_price_184 + TakeProfit * Point, MarketInfo(Symbol(), MODE_DIGITS));
   if (MathAbs(g_price_184 - Ask) > MarketInfo(Symbol(), MODE_STOPLEVEL) * Point && g_price_184 - g_price_208 > MarketInfo(Symbol(), MODE_STOPLEVEL) * Point) OrderSend(Symbol(), OP_BUYSTOP, Lots, g_price_184, 0, g_price_208, g_price_224, g_comment_364, MagicNumber, 0, Green);
   if (GetLastError() == 130/* INVALID_STOPS */) Print(g_price_184, " ", g_price_208, " ", g_price_224);
   return (0);
}

int OpenSell() {
   g_price_192 = NormalizeDouble(iLow(Symbol(), 0, 1) - Filtr * Point, MarketInfo(Symbol(), MODE_DIGITS));
   if (StopFiltr == TRUE) g_price_216 = NormalizeDouble(iHigh(Symbol(), 0, 1) + Filtr * Point, MarketInfo(Symbol(), MODE_DIGITS));
   else g_price_216 = NormalizeDouble(iHigh(Symbol(), 0, 1), MarketInfo(Symbol(), MODE_DIGITS));
   if (TakeProfit == 0.0) g_price_232 = NormalizeDouble(g_price_192 - (g_price_216 - g_price_192) * kProfit, MarketInfo(Symbol(), MODE_DIGITS));
   else g_price_232 = NormalizeDouble(g_price_192 - TakeProfit * Point, MarketInfo(Symbol(), MODE_DIGITS));
   if (MathAbs(g_price_192 - Bid) > MarketInfo(Symbol(), MODE_STOPLEVEL) * Point && g_price_216 - g_price_192 > MarketInfo(Symbol(), MODE_STOPLEVEL) * Point) OrderSend(Symbol(), OP_SELLSTOP, Lots, g_price_192, 0, g_price_216, g_price_232, g_comment_364, MagicNumber, 0, Red);
   if (GetLastError() == 130/* INVALID_STOPS */) Print(g_price_192, " ", g_price_216, " ", g_price_232);
   return (0);
}