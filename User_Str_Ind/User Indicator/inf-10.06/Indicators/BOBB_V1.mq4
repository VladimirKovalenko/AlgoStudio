//+------------------------------------------------------------------+
//|                                                      BOBB_V1.mq4 |
//|                                         Based On Bollinger Bands |
//|                                                   mg@downspin.de |
//+------------------------------------------------------------------+
#property copyright "Copyright @ 2011, downspin"
#property link      "mg@downspin.de"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
#property indicator_color3 Orange
#property indicator_level2 0

extern int    BandsPeriod=20;
extern double BandsDeviations=1.0;

double val1[],
       val2[],
       dev[];

int init(){
  SetIndexStyle(0,DRAW_LINE); SetIndexBuffer(0,val1);
  SetIndexStyle(1,DRAW_LINE); SetIndexBuffer(1,val2);
  SetIndexStyle(2,DRAW_LINE); SetIndexBuffer(2,dev);
  return(0);
}

int deinit(){return(0);}

int start(){
  double sum,ma;
  for(int i=Bars-IndicatorCounted();i>=0;i--){
    ma=iMA(NULL,0,BandsPeriod,0,MODE_SMA,PRICE_CLOSE,i);
    sum=0.0;
    for(int k=i+BandsPeriod-1;k>=i;k--) sum+=MathPow(Close[k]-ma,2);
    dev[i]=BandsDeviations*MathSqrt(sum/BandsPeriod)/Point;
    val1[i]=(Close[i]-ma)/Point-dev[i];
    val2[i]=(ma-Close[i])/Point-dev[i];
  }
  return(0);
}

