//+------------------------------------------------------------------+
//|                                         Waddah Attar Weekly Fibo |
//|                                   Copyright © 2007, Waddah Attar |
//|                             Waddah Attar waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Waddah Attar waddahattar@hotmail.com"
#property link      "waddahattar@hotmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_color5 Red
#property indicator_color6 Red
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
int myPeriod=PERIOD_W1;
//----
double Q,H,L,F;
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
   SetIndexStyle(0,DRAW_LINE,2,1,Red);
   SetIndexStyle(1,DRAW_LINE,2,1,Red);
   SetIndexStyle(2,DRAW_LINE,2,1,Red);
   SetIndexStyle(3,DRAW_LINE,2,1,Red);
   SetIndexStyle(4,DRAW_LINE,2,1,Red);
   SetIndexStyle(5,DRAW_LINE,2,1,Red);
   SetIndexStyle(6,DRAW_LINE,2,1,Red);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("WeekF1");
   ObjectDelete("WeekF2");
   ObjectDelete("WeekF3");
   ObjectDelete("WeekF4");
   ObjectDelete("WeekF5");
   ObjectDelete("WeekF6");
   ObjectDelete("WeekF7");
   ObjectDelete("txtWeekF1");
   ObjectDelete("txtWeekF2");
   ObjectDelete("txtWeekF3");
   ObjectDelete("txtWeekF4");
   ObjectDelete("txtWeekF5");
   ObjectDelete("txtWeekF6");
   ObjectDelete("txtWeekF7");
   //----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, dayi, counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0)
      return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0)
      counted_bars--;
   int limit=Bars - counted_bars;
//----   
   for(i=limit - 1; i>=0; i--)
     {
      dayi=iBarShift(Symbol(), myPeriod, Time[i], false);
      H=iHigh(Symbol(), myPeriod,dayi + 1);
      L=iLow(Symbol(), myPeriod,dayi + 1);
      Q=(H-L);
      //----
      P1Buffer[i]=H;
      //----
      P2Buffer[i]=L;
      //----
      P3Buffer[i]=L+(Q*0.236);
      //----
      P4Buffer[i]=L+(Q*0.382);
      //----
      P5Buffer[i]=L+(Q*0.50);
      //----
      P6Buffer[i]=L+(Q*0.618);
      //----
      P7Buffer[i]=L+(Q*0.764);
     }
   F=(Bid-L)/Q*100;
//----
   return(0);
  }
//+------------------------------------------------------------------+