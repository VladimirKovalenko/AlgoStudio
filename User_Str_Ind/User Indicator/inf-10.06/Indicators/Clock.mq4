//+------------------------------------------------------------------+
//|                                                        Clock.mq4 |
//|                                Copyright © 2012, Tjipke de Vries |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Tjipke de Vries"
#property link      ""

#property indicator_chart_window


extern string Clocktext = "Server";
extern int Timezone.from.Server = 0;
extern int ClockSize = 14;
string FontType = "Verdana";
extern color ClockColor = Blue;
extern int ClockCorner = 0;
extern int yLine = 20;
extern int xCol = 10;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   if(ClockCorner>=4)
      { 
       while (ClockCorner>=4){ClockCorner=ClockCorner-4;}
      } 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("Clock"+DoubleToStr(Timezone.from.Server,0));
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   DisplayText("Clock"+DoubleToStr(Timezone.from.Server,0), yLine, xCol, Clocktext+"  "
   + TimeToStr((TimeCurrent()+ ((  0 - Timezone.from.Server) * 3600)), TIME_SECONDS),
   ClockSize,FontType, ClockColor);   

//----
   return(0);
  }
//+------------------------------------------------------------------+
void DisplayText(string eName, int eYD, int eXD, string eText, int eSize, string eFont, color eColor) {
   ObjectCreate(eName, OBJ_LABEL, 0, 0, 0);
   ObjectSet(eName, OBJPROP_CORNER, ClockCorner);
   ObjectSet(eName, OBJPROP_XDISTANCE, eXD);
   ObjectSet(eName, OBJPROP_YDISTANCE, eYD);
   ObjectSetText(eName, eText, eSize, eFont, eColor);
}
//+------------------------------------------------------------------+

