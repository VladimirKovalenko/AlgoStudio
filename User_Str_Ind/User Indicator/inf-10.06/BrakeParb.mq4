//+------------------------------------------------------------------+
//|                                   Copyright © 2012, Ivan Kornilov|
//|                                                     BrakeParb.mq4|
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Ivan Kornilov. All rights reserved."
#property link "excelf@gmail.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color2 Red
#property indicator_color1 Green

extern double a = 2;
extern double b = 1;
extern double biginShift = 10;

extern bool isLine = false;


double upValue[];
double downValue[];

int init() {
   IndicatorShortName("BrakeExp (" + DoubleToStr(a, 2) + "," + DoubleToStr(b, 2) + " )");
   b = b * Point * Period() * 0.1;

   SetIndexBuffer(0, upValue);
   SetIndexLabel(0, "Up Value");
   
   SetIndexBuffer(1, downValue);
   SetIndexLabel(1, "Down Value");
   
   if(isLine) {
      SetIndexStyle(0, DRAW_LINE, EMPTY, 2);
      SetIndexStyle(1, DRAW_LINE, EMPTY, 2);
   } else {
      SetIndexStyle(0, DRAW_ARROW, EMPTY, 2);
      SetIndexArrow(0, 159);
      SetIndexStyle(1, DRAW_ARROW, EMPTY, 2);
      SetIndexArrow(1, 159);
   }
   
   IndicatorDigits(Digits);
}

double beginPrice = 0;
datetime beginTime = 0;
bool isLong = true;
double maxPrice = -999;
double minPrice = 999;

int start() {
   int indicatorCounted = IndicatorCounted();
   if (indicatorCounted < 0) { 
        return (-1);
   }
   if (indicatorCounted > 0) {
        indicatorCounted--;
   }
   int limit = Bars - indicatorCounted;
   for (int i = limit-1; i >= 0; i--) {
      if(beginPrice == 0) {
         beginPrice = Low[i];
         beginTime = Time[i];
         isLong = true;
      }
      
      if(maxPrice < High[i]) {
         maxPrice = High[i];
      }
      if(minPrice > Low[i]) {
         minPrice = Low[i];
      }
      double value;
      
      int beginBar = iBarShift(NULL, 0, beginTime, false);

      double parab = MathPow((beginBar - i), a) * b;
      if(isLong) {
         value = beginPrice + parab;
      } else {
         value = beginPrice - parab;
      }
      if(isLong && value > Low[i]) {
        // upValue[i] = value;
         isLong = false;
         beginPrice = maxPrice + biginShift * Point;
         value = beginPrice ;
         beginTime = Time[i];
         
         maxPrice = -999;
         minPrice = 999;      
      } else if(!isLong && value < High[i]) {
        // downValue[i] = value;
         isLong = true;
         beginPrice = minPrice - biginShift * Point;
         value = beginPrice ;
         beginTime = Time[i];
         
         maxPrice = -999;
         minPrice = 999;
         
      }
      if(isLong) {
         upValue[i] = value;
        // downValue[i] = EMPTY_VALUE;
      } else {
       //  upValue[i] = EMPTY_VALUE;
         downValue[i] = value;
      }
   }
}