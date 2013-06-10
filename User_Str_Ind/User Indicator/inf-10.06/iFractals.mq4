//+------------------------------------------------------------------+
//|                                                    iFractals.mq4 |
//|                              Copyright © 2006, SOK.LiteForEx.Net |
//|                                         http://sok.liteforex.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, SOK.LiteForEx.Net"
#property link      "http://sok.liteforex.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0,217);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 218);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexEmptyValue(1, 0.0);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("iFractals");
   SetIndexLabel(0, "iFractalsUp");
   SetIndexLabel(1, "iFractalsDn");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
//----
     int limit;
  //---- последний посчитанный бар будет пересчитан
     if(counted_bars > 0) 
         counted_bars--;
     limit = Bars - counted_bars;
  //---- основной цикл
     for(int i = 2; i < limit; i++)
       {
         ExtMapBuffer1[i] = iFractals(NULL, 0, MODE_UPPER, i);
         ExtMapBuffer2[i] = iFractals(NULL, 0, MODE_LOWER, i);
       }
//----
   return(0);
  }
//+------------------------------------------------------------------+