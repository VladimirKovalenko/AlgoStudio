//+------------------------------------------------------------------+
//|                                                       MAonMA.mq4 |
//|                                                 Copyright © 2012 |
//|                                             basisforex@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012"
#property link      "basisforex@gmail.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Aqua
#property indicator_color3 Yellow
//---- input parameters
extern int maPeriod_1   = 13;
extern int maMethod_1   = 0;
extern int maAppPrice_1 = 0;
extern int maPeriod_2   = 34;
extern int maMethod_2   = 0;
extern int maPeriod_3   = 89;
extern int maMethod_3   = 0;
//---- indicator buffers
double a[]; 
double b[]; 
double c[];
//+------------------------------------------------------------------+
int init()
 {
   SetIndexDrawBegin(0, maPeriod_1 + maPeriod_2 + maPeriod_3);
   SetIndexDrawBegin(1, maPeriod_1 + maPeriod_2 + maPeriod_3);
   SetIndexDrawBegin(2, maPeriod_1 + maPeriod_2 + maPeriod_3);
   //---
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   //---
   SetIndexBuffer(0, a);
   SetIndexBuffer(1, b);
   SetIndexBuffer(2, c);
   //---
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);   
   //---
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   int limit, i;
   int counted_bars=IndicatorCounted();
   //---
   if(counted_bars<0) return(-1);
   //----
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   //=====================
   for(i = 0; i < limit; i++)
    {
      a[i]=iMA(NULL, 0, maPeriod_1 , 0, maMethod_1, maAppPrice_1, i);
    }  
   for(i=0; i<limit; i++)
    {
      b[i] = iMAOnArray(a, Bars, maPeriod_2, 0, maMethod_2, i);
    }  
   for(i=0; i<limit; i++)
    {
      c[i] = iMAOnArray(b, Bars, maPeriod_3, 0, maMethod_3, i);
    }    
  //----
   return(0);
 }
//+------------------------------------------------------------------+

