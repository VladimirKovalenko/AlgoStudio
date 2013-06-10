//+------------------------------------------------------------------+
//|                                                        IDWma.mq4 |
//|                             Copyright © 2012, WHRoeder@yahoo.com |
//|                                        mailto:WHRoeder@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, WHRoeder@yahoo.com"
#property link      "mailto:WHRoeder@yahoo.com"

#define MY_NAME "IDWma"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red  // Default Moving Average
//---- indicator parameters
extern int MA_Period    = 14;   // Default Moving Average
extern int MA_Shift     = 0;    // Default Moving Average
extern int MA_Price     = 0;    // PRICE_CLOSE=0, O1, H2, L3, m4, t5, w6
extern int MA_TF        = 0;    // Chart
//---- indicator buffers
double MAs[];       #define MAS_BUF     0
double prices[];    #define PRICES_BUF  1
//---- auxiliary buffers
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int drawBegin;
int init(){
    if (MA_TF <= Period()){ MA_TF = Period();   string periodTxt = ""; }
    else{
        int TFperiod[]  = { PERIOD_M1,  PERIOD_M5,  PERIOD_M15, PERIOD_M30,
                            PERIOD_H1,  PERIOD_H4,  PERIOD_D1,  PERIOD_W1,
                            PERIOD_MN1, 0       };
        string TFtext[] = { "M1",       "M5",       "M15",      "M30",
                            "H1",       "H4",       "D1",       "W1",
                            "Mn1",      "InvTF" };
        for(int iPeriod = 0; TFperiod[iPeriod] < MA_TF; iPeriod++){}
        if(MA_TF != TFperiod[iPeriod]){
            MA_TF = TFperiod[iPeriod];  Alert("MA_TF = ",MA_TF);            }
        periodTxt = ","+TFtext[iPeriod];
    }
    if(MA_Period<2){    MA_Period=13;   Alert("MA_Period = ",MA_Period);    }
    string price2txt[]  = { "", ",O", ",H", ",L", ",M", ",T", ",W"  };
    string sn = MY_NAME+"("+MA_Period+price2txt[MA_Price]+periodTxt+")";
    IndicatorShortName(sn);

    drawBegin   = MA_Period * MA_TF / Period();
    SetIndexBuffer(MAS_BUF,MAs);
    SetIndexStyle(MAS_BUF,DRAW_LINE);
    SetIndexShift(MAS_BUF,MA_Shift);
    SetIndexLabel(MAS_BUF,sn);
    SetIndexDrawBegin(MAS_BUF,drawBegin);
    IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
    if (MA_TF <= Period()){
        IndicatorBuffers(PRICES_BUF+1);
        SetIndexBuffer(PRICES_BUF,prices);
    }
    return(MAS_BUF);
}
//+------------------------------------------------------------------+
//| Inverse Distance Weighted Moving Average MultiTimeFrame          |
//+------------------------------------------------------------------+
int start(){
    int counted_bars    = IndicatorCounted();
    if (MA_TF <= Period()){
        for(int iBar = Bars - 1 - counted_bars; iBar >= 0; iBar--)
        switch(MA_Price){
        case PRICE_WEIGHTED:    prices[iBar] =( High[iBar]
                                             +   Low[iBar]
                                             + Close[iBar]
                                             + Close[iBar] )/4.;    break;
        case PRICE_TYPICAL:     prices[iBar] =( High[iBar]
                                             +   Low[iBar]
                                             + Close[iBar] )/3.;    break;
        case PRICE_MEDIAN:      prices[iBar] =( High[iBar]
                                             +   Low[iBar] )/2.;    break;
        case PRICE_LOW:         prices[iBar] =   Low[iBar];         break;
        case PRICE_HIGH:        prices[iBar] =  High[iBar];         break;
        case PRICE_OPEN:        prices[iBar] =  Open[iBar];         break;
        case PRICE_CLOSE:
        default:                prices[iBar] = Close[iBar];         break;
        }   // switch/iBar
        if (counted_bars < drawBegin)   counted_bars = drawBegin;
        for(iBar = Bars - 1 - counted_bars; iBar >= 0; iBar--){
            // reference //en.wikipedia.org/wiki/Distance-weighted_estimator
            // W[i] = (n-1)/E[j=1..n]|x[i]-x[j]|
            // ave[i] = E[i=1..n](W[i]X[i]) / E[i=1..n]W[i]
            double  Ewx=0,  Ew=0;   int iLimit = iBar + MA_Period;
            for(int iWeight = iBar; iWeight < iLimit; iWeight++){
                double Ed = 0.;
                for(int iDist = iBar; iDist < iLimit; iDist++){
                    Ed += MathAbs(prices[iWeight] - prices[iDist]);
                }
                double w = (MA_Period - 1) / MathMax(Ed, Point);
                Ew  += w;
                Ewx += w * prices[iWeight];
            }
            MAs[iBar] = Ewx / Ew;
        }   // iBar
    }
    else{   // MA_TF > Period()
        if (counted_bars < drawBegin)   counted_bars = drawBegin;
        for(iBar = Bars - 1 - counted_bars; iBar >= 0; iBar--){
            int iTF = iBarShift(NULL, MA_TF, Time[iBar]);
            MAs[iBar]   = iCustom(  NULL, MA_TF, MY_NAME,
                                        MA_Period,
                                        0,  //MA_Shift
                                        MA_Price,
                                        MA_TF,
                                    MAS_BUF, iTF );
        }
    }
}   // start
