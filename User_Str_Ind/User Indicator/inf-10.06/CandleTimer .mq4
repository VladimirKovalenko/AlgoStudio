//+------------------------------------------------------------------+
//|                                                  CandleTimer.mq4 |
//|                                                           raposo |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "raposo"
#property link      ""

#property indicator_chart_window

extern color color1 = Red;
extern int fontsize = 20;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {

   ObjectCreate("Timer",OBJ_LABEL,0,0,0);
   ObjectSet("Timer",OBJPROP_CORNER,3);
   ObjectSet("Timer",OBJPROP_COLOR,color1);
   ObjectSet("Timer",OBJPROP_FONTSIZE,fontsize);
   ObjectSet("Timer",OBJPROP_XDISTANCE,60);
   ObjectSet("Timer",OBJPROP_YDISTANCE,20);
  
   return(0);
}

int deinit() {
   ObjectDelete("Timer");

   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  datetime opentime = iTime(NULL,0,0) + (Period() * 60);

//----
  ObjectSetText("Timer",TimeToStr(opentime - TimeCurrent(),TIME_SECONDS));   
//----
   return(0);
  }
//+------------------------------------------------------------------+