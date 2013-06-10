
//+------------------------------------------------------------------+
//|                                              +++Urban_Towers.mq4 |
//|                                 Copyright © 2010, XrustSolution. |
//|                                           mail: xrustx@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, XrustSolution."
#property link      "mail: xrustx@gmail.com"
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 DodgerBlue
#property indicator_color2 DodgerBlue
#property indicator_color3 DodgerBlue
#property indicator_color4 Green
#property indicator_color5 Green
#property indicator_color8 Green
#property indicator_color6 Aqua
#property indicator_color7 Red
//+------------------------------------------------------------------+
extern    int       Start_Period_Ma  = 9;
extern    int       Step_Period_Ma   = 2;
extern    int       Ma_Price         = 0;
extern    int       Ma_Metod         = 1;
extern    bool      Show_Ma          = true;
extern    int       Trand_back_count = 3;
//+------------------------------------------------------------------+
//---- buffers
double ma1[];
double ma2[];
double ma3[];
double ma4[];
double ma5[];
double ma6[];
double up[];
double dn[];
int draw = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if(!Show_Ma){draw = 12;}
   SetIndexStyle(0,draw);
   SetIndexLabel(0,"MA1");
   SetIndexBuffer(0,ma1);
   SetIndexStyle(1,draw);
   SetIndexLabel(0,"MA2");
   SetIndexBuffer(1,ma2);
   SetIndexStyle(2,draw);
   SetIndexLabel(0,"MA3");
   SetIndexBuffer(2,ma3);
   SetIndexStyle(3,draw);
   SetIndexLabel(0,"MA4");
   SetIndexBuffer(3,ma4);
   SetIndexStyle(4,draw);
   SetIndexLabel(0,"MA5");
   SetIndexBuffer(4,ma5);
   SetIndexStyle(7,draw);
   SetIndexLabel(0,"MA6");
   SetIndexBuffer(7,ma6);
   SetIndexStyle(5,DRAW_ARROW,EMPTY,2);
   SetIndexArrow(5,233);
   SetIndexBuffer(5,up);
   SetIndexEmptyValue(5,0.0);
   SetIndexStyle(6,DRAW_ARROW,EMPTY,2);
   SetIndexArrow(6,234);
   SetIndexBuffer(6,dn);
   SetIndexEmptyValue(6,0.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
void deinit(){
   for(int i=ObjectsTotal();i>=0;i--){
      string nm = ObjectName(i);
      if(StringSubstr(nm,0,5) == "Level"){ObjectDelete(nm);}
   }
   CloseBy(0);
return;}
//+------------------------------------------------------------------+
int start(){
   int    counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars == 0){ArrayInitialize(dn,0);ArrayInitialize(up,0);}
//----
   for(int i = limit;i>=0;i--){
      ma1[i] = iMA(Symbol(),Period(),Start_Period_Ma,0,Ma_Metod,Ma_Price,i);
      ma2[i] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma,0,Ma_Metod,Ma_Price,i);
      ma3[i] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*2,0,Ma_Metod,Ma_Price,i);
      ma4[i] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*3,0,Ma_Metod,Ma_Price,i);
      ma5[i] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*4,0,Ma_Metod,Ma_Price,i);
      ma6[i] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*5,0,Ma_Metod,Ma_Price,i);
      int trand = Trand(i,Trand_back_count);
      if(trand>0){
         if(High[i+3]>High[i+2]&&High[i+2]>High[i+1]){
            if(High[i+3]>hi_lo(true,i+3)&&High[i+2]>hi_lo(true,i+2)&&High[i+1]>hi_lo(true,i+1)){
               if(Low[i+2]<=hi_lo(true,i+2)||Low[i+1]<=hi_lo(true,i+1)){
                  if(Close[i]>High[i+1]){
                     SetLevel(true,i,High[i+1]);
                     up[i]=Low[i]-10*Point;
                  }   
               }   
            }
         }
      }
      if(trand<0){
         if(Low[i+3]<Low[i+2]&&Low[i+2]<Low[i+1]){
            if(Low[i+3]<hi_lo(false,i+3)&&Low[i+2]<hi_lo(false,i+2)&&Low[i+1]<hi_lo(false,i+1)){
               if(High[i+2]>=hi_lo(false,i+2)||High[i+1]>=hi_lo(false,i+1)){
                  if(Close[i]<Low[i+1]){  
                     SetLevel(false,i,Low[i+1]);    
                     dn[i]=High[i]+10*Point;
                  }
               }
            }      
         }   
      }
   }
//----
  
   return(0);
  }
//+------------------------------------------------------------------+
void SetLevel(bool bs,int co,double pr){color cl;
   if(bs){cl = Blue;}else{cl = Red;}
   string nm = "Level_"+Time[co];
   if(ObjectFind(nm)!=0){ObjectCreate(nm,2,0,0,0,0,0);}
      ObjectSet(nm,OBJPROP_TIME1,Time[co]+Period()*60*4);
      ObjectSet(nm,OBJPROP_TIME2,Time[co+1]);
      ObjectSet(nm,OBJPROP_PRICE1,pr);
      ObjectSet(nm,OBJPROP_PRICE2,pr);
      ObjectSet(nm,OBJPROP_COLOR,cl);
      ObjectSet(nm,OBJPROP_WIDTH,2);
      ObjectSet(nm,OBJPROP_STYLE,0);
      ObjectSet(nm,OBJPROP_RAY,false);
   return;
}  
//+------------------------------------------------------------------+
double hi_lo(bool hl,int i){double pr[6],hi,lo;
   pr[0] = iMA(Symbol(),Period(),Start_Period_Ma,0,Ma_Metod,Ma_Price,i);
   pr[1] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma,0,Ma_Metod,Ma_Price,i);
   pr[2] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*2,0,Ma_Metod,Ma_Price,i);
   pr[3] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*3,0,Ma_Metod,Ma_Price,i);
   pr[4] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*4,0,Ma_Metod,Ma_Price,i);
   pr[5] = iMA(Symbol(),Period(),Start_Period_Ma+Step_Period_Ma*5,0,Ma_Metod,Ma_Price,i);
   ArraySort(pr,WHOLE_ARRAY,0,MODE_DESCEND);
   hi = pr[ArrayMaximum(pr)];
   lo = pr[ArrayMinimum(pr)];
   if(lo==0){lo = pr[ArrayMinimum(pr)-1];}
   if(lo==0){lo = pr[ArrayMinimum(pr)-1];}
   if(lo==0){lo = pr[ArrayMinimum(pr)-1];}
   if(hl){return(hi);}else{return(lo);}
}  
//+------------------------------------------------------------------+
int Trand(int pos,int co){int tr=0;
   for(int i = pos;i<pos + co;i++){
      if(ma1[i]>ma2[i+1]){tr++;}
      if(ma1[i]<ma2[i+1]){tr--;}
   }
   return(tr);
}
bool CloseBy(int mn){int ticket=0,typ=-1;
  for(int i=OrdersTotal();i>=0;i--){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol() == Symbol()){
        if(OrderLots() == 0.1){
          if(OrderMagicNumber()==mn){
            ticket = OrderTicket();
            typ    = OrderType();
            break;
          }  
        }
      }
    }
  }
  return;
  if(ticket == 0){return(false);}
  for(i=OrdersTotal();i>=0;i--){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol() == Symbol()){
        if(OrderLots() == 0.1/2){
          if(OrderTicket()!=ticket){
          if(OrderMagicNumber()==mn){
            if(typ==0&&OrderType()==1){
              if(OrderCloseBy(OrderTicket(),ticket,Green)){
                return(true);
              }else{return(false);}
            }
            if(typ==1&&OrderType()==0){
              if(OrderCloseBy(OrderTicket(),ticket,Green)){
                return(true);
              }
            } 
          }             
          }
        }
      }
    }
  }
  return(false);  
}