//+------------------------------------------------------------------+
//|                                                Jurik average.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
#property copyright "www.forex-tsd.com"
#property link      "www.forex-tsd.com"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1  DeepSkyBlue
#property indicator_color2  LimeGreen
#property indicator_color3  LimeGreen
#property indicator_color4  Red
#property indicator_color5  Red
#property indicator_color6  Peru
#property indicator_style3  STYLE_DOT
#property indicator_style4  STYLE_DOT
#property indicator_style6  STYLE_DASH
#property indicator_width1  3
#property indicator_width2  2
#property indicator_width5  2

//
//
//
//
//

#import "dynamicZone.dll"
   double dzBuyP(double& sourceArray[],double probabiltyValue, int lookBack, int bars, int i, double precision);
   double dzSellP(double& sourceArray[],double probabiltyValue, int lookBack, int bars, int i, double precision);
#import

//
//
//    
//
//

extern int    Periods                 = 21;
extern int    Price                   = PRICE_CLOSE;
extern int    Method                  = 6;
extern bool   ShowMiddleLine          = true;
extern int    DzLookBackBars          = 35;
extern double DzStartBuyProbability1  = 0.10;
extern double DzStartBuyProbability2  = 0.25;
extern double DzStartSellProbability1 = 0.10;
extern double DzStartSellProbability2 = 0.25;


//
//
//
//
//

double MABuffer[];
double alpha[];
double prices[];
double bl1Buffer[];
double bl2Buffer[];
double sl1Buffer[];
double sl2Buffer[];
double zliBuffer[];
double stored[][7];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   SetIndexBuffer(0,MABuffer);
   SetIndexBuffer(1,bl1Buffer);
   SetIndexBuffer(2,bl2Buffer);
   SetIndexBuffer(3,sl2Buffer);
   SetIndexBuffer(4,sl1Buffer);
   SetIndexBuffer(5,zliBuffer);
   
        
   IndicatorShortName("DZ of averages"+getAverageName(Method)+"");
   return(0);
}
int deinit() { return(0); }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int start()
{
   double precision = Point*100.0;
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);

   //
   //
   //
   //
   //
   
   for (i=limit; i>=0; i--)
   {
      MABuffer[i] = iCustomMA(iMA(NULL,0,1,0,MODE_SMA,Price,i),Periods,Method,i);
      if (DzStartBuyProbability1 >0) bl1Buffer[i] = dzBuyP (MABuffer, DzStartBuyProbability1,  DzLookBackBars, Bars, i, precision);
      if (DzStartBuyProbability2 >0) bl2Buffer[i] = dzBuyP (MABuffer, DzStartBuyProbability2,  DzLookBackBars, Bars, i, precision);
      if (DzStartSellProbability1>0) sl1Buffer[i] = dzSellP(MABuffer, DzStartSellProbability1, DzLookBackBars, Bars, i, precision);
      if (DzStartSellProbability2>0) sl2Buffer[i] = dzSellP(MABuffer, DzStartSellProbability2, DzLookBackBars, Bars, i, precision);
      if (ShowMiddleLine)            zliBuffer[i] = dzSellP(MABuffer, 0.5                    , DzLookBackBars, Bars, i, precision);
      }
   return(0);
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

double workPrices[];
double workResult[];
int    r;

double iCustomMA(double price, int period, int method, int i)
{
   if (ArraySize(workPrices)!= Bars) ArrayResize(workPrices,Bars);
            r = Bars-i-1;
   workPrices[r] = price;

   //
   //
   //
   //
   //
   
      switch(method)
      {
         case  0: return(iSma(price,period,i));
         case  1: return(iEma(price,period,i));
         case  2: return(iSmma(price,period,i));
         case  3: return(iLwma(price,period,i));
         case  4: return(iLsma(price,period,i));
         case  5: return(iTma(price,period,i));
         case  6: return(iSineWMA(price,period,i));
         case  7: return(iVolumeWMA(price,period,i));
         case  8: return(iHma(price,period,i));
         case  9: return(iNonLagMa(price,period,i));
      }
   return(EMPTY_VALUE);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

double iSma(double price, double period, int i)
{
   double sum = 0;
   for(int k=0; k<period && (r-k)>=0; k++) sum += workPrices[r-k];  
   if (k!=0)
         return(sum/k);
   else  return(EMPTY_VALUE);
}

//
//
//
//
//

double iEma(double price, double period, int i)
{
   if (ArraySize(workResult)!= Bars) ArrayResize(workResult,Bars);
   double alpha = 2.0 / (1.0+period);
          workResult[r] = workResult[r-1]+alpha*(price-workResult[r-1]);
   return(workResult[r]);
}
//
//
//
//
//

double iSmma(double price, double period, int i)
{
   if (ArraySize(workResult)!= Bars) ArrayResize(workResult,Bars);
   if (i>=(Bars-period))
   {
      double sum = 0; 
         for(int k=0; k<period && (r-k)>=0; k++) sum += workPrices[r-k];  
         if (k!=0)
               workResult[i] = sum/k;
         else  workResult[i] = EMPTY_VALUE;
   }      
   else   workResult[r] = (workResult[r-1]*(period-1)+price)/period;
   return(workResult[r]);
}

//
//
//
//
//

double iLwma.prices[][3];
double iLwma(double price, double period, int i,int forValue=0)
{
   if (ArrayRange(iLwma.prices,0)!= Bars) ArrayResize(iLwma.prices,Bars);
   
   //
   //
   //
   //
   //
   
   iLwma.prices[r][forValue] = price;
      double sum  = 0;
      double sumw = 0;

      for(int k=0; k<period && (r-k)>=0; k++)
      {
         double weight = period-k;
                sumw  += weight;
                sum   += weight*iLwma.prices[r-k][forValue];  
      }             
   if (sumw!=0)
         return(sum/sumw);
   else  return(EMPTY_VALUE);
}

//
//
//
//
//

double iLsma(double price, double period, int i)
{
   return(3.0*iLwma(price,period,i)-2.0*iSma(price,period,i));
}

//
//
//
//
//

double iHma(double price, double period, int i)
{
   int HalfPeriod = MathFloor(period/2);
   int HullPeriod = MathFloor(MathSqrt(period));
            double price1 = 2.0*iLwma(price,HalfPeriod,i,0)-iLwma(price,period,i,1);
   return (iLwma(price1,HullPeriod,i,2));
}

//
//
//
//
//

double iTma(double price, double period, int i)
{
   double half = (period+1.0)/2.0;
   double sum  = 0;
   double sumw = 0;

   for(int k=0; k<period && (r-k)>=0; k++)
   {
      double weight = k+1; if (weight > half) weight = period-k;
             sumw  += weight;
             sum   += weight*workPrices[r-k];  
   }             
   if (sumw!=0)
         return(sum/sumw);
   else  return(EMPTY_VALUE);
}

//
//
//
//
//

#define Pi 3.14159265358979323846
double iSineWMA(double price, int period, int i)
{
   double sum  = 0;
   double sumw = 0;
  
   for(int k=0; k<period && (r-k)>=0; k++)
   { 
      double weight = MathSin(Pi*(k+1)/(period+1));
             sumw  += weight;
             sum   += weight*workPrices[r-k]; 
   }
   if (sumw!=0)
         return(sum/sumw);
   else  return(EMPTY_VALUE);
}

//
//
//
//
//

double iVolumeWMA(double price, int period, int i)
{
   double sum  = 0;
   double sumw = 0;
  
   for(int k=0; k<period && (r-k)>=0; k++)
   { 
      double weight = Volume[i+k];
             sumw  += weight;
             sum   += weight*workPrices[r-k]; 
   }
   if (sumw!=0)
         return(sum/sumw);
   else  return(EMPTY_VALUE);
}


//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

#define Pi       3.14159265358979323846264338327950288
#define _length  0
#define _len     1
#define _weight  2

#define numOfSeparateCalculations 1
double  nlm.values[3][numOfSeparateCalculations];
double  nlm.prices[ ][numOfSeparateCalculations];
double  nlm.alphas[ ][numOfSeparateCalculations];

//
//
//
//
//

double iNonLagMa(double price, int length, int i, int forValue=0)
{
   if (ArrayRange(nlm.prices,0) != Bars) ArrayResize(nlm.prices,Bars);
            int r = Bars-i-1;  nlm.prices[r][forValue]=price;
   if (length<3 || r<3) return(nlm.prices[r][forValue]);
   
   //
   //
   //
   //
   //
   
   if (nlm.values[_length][forValue] != length)
   {
      double Cycle = 4.0;
      double Coeff = 3.0*Pi;
      int    Phase = length-1;
      
         nlm.values[_length][forValue] = length;
         nlm.values[_len   ][forValue] = length*4 + Phase;  
         nlm.values[_weight][forValue] = 0;

         if (ArrayRange(nlm.alphas,0) < nlm.values[_len][forValue]) ArrayResize(nlm.alphas,nlm.values[_len][forValue]);
         for (int k=0; k<nlm.values[_len][forValue]; k++)
         {
            if (k<=Phase-1) 
                 double t = 1.0 * k/(Phase-1);
            else        t = 1.0 + (k-Phase+1)*(2.0*Cycle-1.0)/(Cycle*length-1.0); 
            double beta = MathCos(Pi*t);
            double g = 1.0/(Coeff*t+1); if (t <= 0.5 ) g = 1;
      
            nlm.alphas[k][forValue]        = g * beta;
            nlm.values[_weight][forValue] += nlm.alphas[k][forValue];
         }
   }
   
   //
   //
   //
   //
   //
   
   if (nlm.values[_weight][forValue]>0)
   {
      double sum = 0;
           for (k=0; k < nlm.values[_len][forValue]; k++) sum += nlm.alphas[k][forValue]*nlm.prices[r-k][forValue];
           return( sum / nlm.values[_weight][forValue]);
   }
   else return(0);           
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

string methodNames[] = {"SMA","EMA","SMMA","LWMA","LSMA","TriMA","SWMA","VWMA","HullMA","NonLagMA"};
string getAverageName(int& method)
{
   method=MathMax(MathMin(method,9),0); return(methodNames[method]);
}