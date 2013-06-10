#property  copyright "BECEMAL"
#property  link      "http://www.becemal.ru/"
#property  indicator_chart_window
//#property  indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Gold

extern   int   MAPeriod = 24;
extern   int   NeedCountBars = 2048;
int   NeedBars;
double   N, DN, NLW, DNLW, SMAPrev = 0.0, LWMAPrev = 0.0;
double Buff[];
//datetime TimePrev = 0;

int init()  {
if(MAPeriod < 3)  MAPeriod = 24;
N = MAPeriod;
NLW = 0.5 * N * (N + 1.0);
DN = 1 / N;
DNLW = 1 / NLW;
if(NeedCountBars < 1) NeedBars = Bars - MAPeriod - 1;
else  NeedBars = NeedCountBars;
SetIndexStyle(0,DRAW_LINE);
SetIndexBuffer(0,Buff);
SetIndexDrawBegin(0, NeedBars);
SetIndexLabel(0, "LRMA(" + MAPeriod + ")");  
return(0);  }

int start() {
if(Bars < NeedBars + MAPeriod)   {
   Print("No Data");
   return(0);  }
int    i, limit, Error, counted_bars = IndicatorCounted();
double newSMA, newLWMA, newPrice;
limit = Bars - counted_bars - 1;
if(limit > NeedBars) limit = NeedBars;
if(counted_bars < 2) {
   newLWMA = iMA(NULL,0,MAPeriod,0,MODE_LWMA,PRICE_CLOSE,limit);
   newSMA = iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,limit);
   Buff[limit] = 3.0 * newLWMA - 2.0 * newSMA;
   limit--;
   SMAPrev = newSMA * N;
   LWMAPrev = newLWMA * NLW;  }
//if(Time != TimePrev) {
//   TimePrev = Time;
//   SMAPrev = newSMA;
//   LWMAPrev = newLWMA;  }   
for(i = limit; i >= 0; i--)   {
   newPrice = Close[i];
   newLWMA = LWMAPrev + (N * newPrice - SMAPrev);  
   newSMA = SMAPrev + (newPrice - Close[i + MAPeriod]);
   Buff[i] = 3.0 * DNLW * newLWMA - 2.0 * DN * newSMA;
   if(i > 0)  {
      SMAPrev = newSMA;
      LWMAPrev = newLWMA;  }  }
return(0);
}