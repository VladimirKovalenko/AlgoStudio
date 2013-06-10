//+------------------------------------------------------------------+
//|                                               Waddah Attar Pivot |
//|                               Copyright © 2007, ww.metaforex.net |
//|                                   Waddah Attar www.metaforex.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, www.metaforex.net"
#property link      "www.metaforex.net"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Blue
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Green
#property indicator_color5 Red
#property indicator_color6 Green
#property indicator_color7 Red
//---- buffers
double P1Buffer[];
double P2Buffer[];
double P3Buffer[];
double P4Buffer[];
double P5Buffer[];
double P6Buffer[];
double P7Buffer[];
//----
int myPeriod = PERIOD_W1;
//----
double PP, R1, S1, R2, S2, R3, S3, Q;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, P1Buffer);
   SetIndexBuffer(1, P2Buffer);
   SetIndexBuffer(2, P3Buffer);
   SetIndexBuffer(3, P4Buffer);
   SetIndexBuffer(4, P5Buffer);
   SetIndexBuffer(5, P6Buffer);
   SetIndexBuffer(6, P7Buffer);
//----
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 1);
//----
   Comment("By eng.Waddah Attar  www.metaforex.net");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("WeekP");
   ObjectDelete("WeekR1");
   ObjectDelete("WeekR2");
   ObjectDelete("WeekR3");
   ObjectDelete("WeekS1");
   ObjectDelete("WeekS2");
   ObjectDelete("WeekS3");
   ObjectDelete("txtWeekP");
   ObjectDelete("txtWeekR1");
   ObjectDelete("txtWeekR2");
   ObjectDelete("txtWeekR3");
   ObjectDelete("txtWeekS1");
   ObjectDelete("txtWeekS2");
   ObjectDelete("txtWeekS3");
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, dayi, counted_bars = IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--;  
   int limit = Bars - counted_bars;
//----   
   for(i = limit - 1; i >= 0; i--)
     {
       dayi = iBarShift(Symbol(), myPeriod, Time[i], false); 
       Q = (iHigh(Symbol(), myPeriod,dayi + 1) - iLow(Symbol(), myPeriod, 
            dayi + 1));
       PP = (iHigh(Symbol(), myPeriod, dayi + 1) + 
             iLow(Symbol(), myPeriod, dayi + 1) +
             iClose(Symbol(), myPeriod, dayi + 1) +
             iOpen(Symbol(), myPeriod, dayi)) / 4;    
       //----
       R1 = PP + (Q * 0.23);
       S1 = PP - (Q * 0.23);
       //----
       R2 = PP + (Q * 0.38);
       S2 = PP - (Q * 0.38);
       //----
       R3 = PP + (Q * 0.50);
       S3 = PP - (Q * 0.50);
       //----
       P1Buffer[i] = PP;
       SetPrice("WeekP", Time[i], PP, Blue);
       SetText("txtWeekP", "WP", Time[i], PP, Blue);
       //----
       P2Buffer[i] = R1;
       SetPrice("WeekR1", Time[i], R1, Green);
       SetText("txtWeekR1", "WR1", Time[i], R1, Green);
       //----
       P3Buffer[i] = S1;
       SetPrice("WeekS1", Time[i], S1, Red);
       SetText("txtWeekS1", "WS1", Time[i], S1, Red);
       //----
       P4Buffer[i] = R2;
       SetPrice("WeekR2", Time[i], R2, Green);
       SetText("txtWeekR2", "WR2", Time[i], R2, Green);
       //----
       P5Buffer[i] = S2;
       SetPrice("WeekS2", Time[i], S2, Red);
       SetText("txtWeekS2", "WS2", Time[i], S2, Red);
       //----
       P6Buffer[i] = R3;
       SetPrice("WeekR3", Time[i], R3, Green);
       SetText("txtWeekR3", "WR3", Time[i], R3, Green);
       //----
       P7Buffer[i] = S3;
       SetPrice("WeekS3", Time[i], S3, Red);
       SetText("txtWeekS3", "WS3", Time[i], S3, Red);
    }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetPrice(string name, datetime Tm, double Prc, color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_ARROW, 0, Tm, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 1);
       ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 1);
       ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     } 
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name, string txt, datetime Tm, double Prc, color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_TEXT, 0, Tm, Prc);
       ObjectSetText(name, txt, 10, "Times New Roman", clr);
       ObjectSet(name, OBJPROP_CORNER, 2);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSetText(name, txt, 10, "Times New Roman", clr);
       ObjectSet(name, OBJPROP_CORNER, 2);
     } 
  }
//+------------------------------------------------------------------+