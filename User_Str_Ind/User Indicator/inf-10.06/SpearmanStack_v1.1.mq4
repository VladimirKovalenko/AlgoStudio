//+------------------------------------------------------------------+
//|                                   Copyright © 2010, Ivan Kornilov|
//|                                            SpearmanStack_v1.1.mq4|
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Ivan Kornilov. All rights reserved."
#property link "excelf@gmail.com"

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color8 C'50,50,50'   
#property indicator_color7 C'90,90,90'
#property indicator_color6 C'120,120,120'
#property indicator_color5 C'140,140,140'
#property indicator_color4 C'160,160,160'
#property indicator_color3 C'180,180,180'
#property indicator_color2 C'200,200,200'
#property indicator_color1 C'220,220,220' 

#property indicator_level1 0.8
#property indicator_level2 -0.8
#property indicator_maximum  1.05
#property indicator_minimum -1.05

extern int rangeNlength = 21;
extern int step = 6;
extern int calculatedBars = 1440;
bool direction = true;

int rangeNs[];

double ExtMapBuffer0[];
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];

double multiply;

double Rtwo0[];
int PriceInt0[];
int SortInt0[];

double Rtwo1[];
int PriceInt1[];
int SortInt1[];

double Rtwo2[];
int PriceInt2[];
int SortInt2[];

double Rtwo3[];
int PriceInt3[];
int SortInt3[];

double Rtwo4[];
int PriceInt4[];
int SortInt4[];

double Rtwo5[];
int PriceInt5[];
int SortInt5[];

double Rtwo6[];
int PriceInt6[];
int SortInt6[];

double Rtwo7[];
int PriceInt7[];
int SortInt7[];



int init(){
   SetIndexStyle(0, DRAW_LINE, EMPTY, 1);
   SetIndexStyle(1, DRAW_LINE, EMPTY, 1);
   SetIndexStyle(3, DRAW_LINE, EMPTY, 1);
   SetIndexStyle(4, DRAW_LINE, EMPTY, 1);
   SetIndexStyle(5, DRAW_LINE, EMPTY, 1);
   SetIndexStyle(6, DRAW_LINE, EMPTY, 1);
   SetIndexStyle(7, DRAW_LINE, EMPTY, 1);   
   
   SetIndexBuffer(0, ExtMapBuffer0);
   SetIndexBuffer(1, ExtMapBuffer1);
   SetIndexBuffer(2, ExtMapBuffer2);
   SetIndexBuffer(3, ExtMapBuffer3);
   SetIndexBuffer(4, ExtMapBuffer4);
   SetIndexBuffer(5, ExtMapBuffer5);
   SetIndexBuffer(6, ExtMapBuffer6);
   SetIndexBuffer(7, ExtMapBuffer7);
   

   
   multiply = MathPow(10, Digits);
   
   ArrayResize(rangeNs, 8);
   rangeNs[0] = rangeNlength;
   for(int i = 1; i < 8; i++) {
        rangeNs[i] = rangeNs[i-1] + step;
   }
   
   SetIndexLabel(0, "Spearman (" + rangeNs[0]+")");
   SetIndexLabel(1, "Spearman (" + rangeNs[1]+")");
   SetIndexLabel(2, "Spearman (" + rangeNs[2]+")");
   SetIndexLabel(3, "Spearman (" + rangeNs[3]+")");
   SetIndexLabel(4, "Spearman (" + rangeNs[4]+")");
   SetIndexLabel(5, "Spearman (" + rangeNs[5]+")");
   SetIndexLabel(6, "Spearman (" + rangeNs[6]+")");
   SetIndexLabel(7, "Spearman (" + rangeNs[7]+")");
   
   ArrayResize(Rtwo0, rangeNs[0]);
   ArrayResize(PriceInt0, rangeNs[0]);
   ArrayResize(SortInt0, rangeNs[0]);
   
   ArrayResize(Rtwo1, rangeNs[1]);
   ArrayResize(PriceInt1, rangeNs[1]);
   ArrayResize(SortInt1, rangeNs[1]);
   
   ArrayResize(Rtwo2, rangeNs[2]);
   ArrayResize(PriceInt2, rangeNs[2]);
   ArrayResize(SortInt2, rangeNs[2]);
   
   ArrayResize(Rtwo3, rangeNs[3]);
   ArrayResize(PriceInt3, rangeNs[3]);
   ArrayResize(SortInt3, rangeNs[3]);
   
   ArrayResize(Rtwo4, rangeNs[4]);
   ArrayResize(PriceInt4, rangeNs[4]);
   ArrayResize(SortInt4, rangeNs[4]);
   
   ArrayResize(Rtwo5, rangeNs[5]);
   ArrayResize(PriceInt5, rangeNs[5]);
   ArrayResize(SortInt5, rangeNs[5]);
   
   ArrayResize(Rtwo6, rangeNs[6]);
   ArrayResize(PriceInt6, rangeNs[6]);
   ArrayResize(SortInt6, rangeNs[6]);
   
   ArrayResize(Rtwo7, rangeNs[7]);
   ArrayResize(PriceInt7, rangeNs[7]);
   ArrayResize(SortInt7, rangeNs[7]);
   IndicatorShortName("Spearman(" + rangeNs[0] + "-" + rangeNs[7] + "," + step + ")");
  
}

double SpearmanRankCorrelation(double Ranks[], int N){
   double res,z2;
   int i;
   for(i = 0; i < N; i++){
       z2 += MathPow(Ranks[i] - i - 1, 2);
   }
   res = 1 - 6 * z2 / (MathPow(N,3) - N);
   return(res);
}

void RankPrices(int InitialArray[], double &Rtwo[], int SortInt[], int rangeN) {
   int i, k, m, dublicat, counter, etalon;
   double dcounter, averageRank;
   double TrueRanks[];
   ArrayResize(TrueRanks, rangeN);
   ArrayCopy(SortInt, InitialArray);
   for(i = 0; i < rangeN; i++) {
       TrueRanks[i] = i + 1;
   }
   if(direction){
       ArraySort(SortInt, 0, 0, MODE_DESCEND);
   } else {
       ArraySort(SortInt, 0, 0, MODE_ASCEND);
   }
   for(i = 0; i < rangeN-1; i++){
        if(SortInt[i] != SortInt[i+1]) {
            continue;
        }
        dublicat = SortInt[i];
        k = i + 1;
        counter = 1;
        averageRank = i + 1;
        while(k < rangeN){
            if(SortInt[k] == dublicat){
                counter++;
                averageRank += k + 1;
                k++;
            } else {
                break;
            }
        }
        dcounter = counter;
        averageRank = averageRank / dcounter;
        for(m = i; m < k; m++) {
            TrueRanks[m] = averageRank;
        }
        i = k;
    }
    for(i = 0; i < rangeN; i++){
       etalon = InitialArray[i];
       k = 0;
       while(k < rangeN) {
           if(etalon == SortInt[k]){
               Rtwo[i] = TrueRanks[k];
               break;
           }
           k++;
       }
    }
}


int start(){
    int counted_bars = IndicatorCounted();
    int i, k, limit;
    if(counted_bars == 0){
       if(calculatedBars == 0) {
           limit = Bars - rangeNlength;
       } else{
           limit = calculatedBars;
       }
    }
    if(counted_bars > 0) {
       limit = Bars - counted_bars;
    }
   
    for(i = limit-2; i >= 0; i--){
        for(k = 0; k < rangeNs[0]; k++) {
           PriceInt0[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt0, Rtwo0, SortInt0, rangeNs[0]);
        ExtMapBuffer0[i] = SpearmanRankCorrelation(Rtwo0, rangeNs[0]);
        
        
        for(k = 0; k < rangeNs[1]; k++) {
           PriceInt1[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt1, Rtwo1, SortInt1, rangeNs[1]);
        ExtMapBuffer1[i] = SpearmanRankCorrelation(Rtwo1, rangeNs[1]);
        
        
        for(k = 0; k < rangeNs[2]; k++) {
           PriceInt2[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt2, Rtwo2, SortInt2, rangeNs[2]);
        ExtMapBuffer2[i] = SpearmanRankCorrelation(Rtwo2, rangeNs[2]);
        
        for(k = 0; k < rangeNs[3]; k++) {
           PriceInt3[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt3, Rtwo3, SortInt3, rangeNs[3]);
        ExtMapBuffer3[i] = SpearmanRankCorrelation(Rtwo3, rangeNs[3]);
        
        
        for(k = 0; k < rangeNs[4]; k++) {
           PriceInt4[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt4, Rtwo4, SortInt4, rangeNs[4]);
        ExtMapBuffer4[i] = SpearmanRankCorrelation(Rtwo4, rangeNs[4]);
        
        
        for(k = 0; k < rangeNs[5]; k++) {
           PriceInt5[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt5, Rtwo5, SortInt5, rangeNs[5]);
        ExtMapBuffer5[i] = SpearmanRankCorrelation(Rtwo5, rangeNs[5]);
        
         for(k = 0; k < rangeNs[6]; k++) {
           PriceInt6[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt6, Rtwo6, SortInt6, rangeNs[6]);
        ExtMapBuffer6[i] = SpearmanRankCorrelation(Rtwo6, rangeNs[6]);
        
         for(k = 0; k < rangeNs[7]; k++) {
           PriceInt7[k] = Close[i + k] * multiply;
        }
        RankPrices(PriceInt7, Rtwo7, SortInt7, rangeNs[7]);
        ExtMapBuffer7[i] = SpearmanRankCorrelation(Rtwo7, rangeNs[7]);//*/
    }
}

