//---------------------------------------------------
// Project: Volatility_Spyke_24.12.2012
// Language: MQL4
// Type: Strategy
// Author: 
// Company: 
// Copyright: 
// Created: 24.12.2012
//---------------------------------------------------

extern bool df=true;
extern string dfg="sdfsdf";
extern double QTY = 1;
//extern int Open_koef=5;
//extern int Clos_koef=15;
extern int periodMA        =50; 
extern int bars_volume_calc  =10;
extern double  volume_koef   =2;
extern double   tick_size = 0.0001;
extern double profit=5;
extern double loss=5;
extern bool Pos_hold_time_restriction=false;
extern int Hold_pos_max_time_minutes =10;
extern int fg=5;
extern bool f=false;
int h,ticket,n,posB,posS,bars,barsOld,barsNew;
double v,lotsize,b,k,bidNew,askNew,askOld,bidOld,vavgA,vavgB,avg_Vol,askV,bidV,koef1[50000],orderprof,l;
string ss;
extern string sdf="sdfsfsf";
extern bool ààdf=false;
int init()
{ 


 lotsize= MarketInfo(Symbol(),MODE_LOTSIZE);
 b= lotsize*tick_size*QTY ;
 l=QTY*lotsize;
 ss=Symbol();
  return(0);
}



int start()
{ 
 if (ticket>0){ chek_open_pos(); return;}
 n++;
 
if (n<2)return;

barsNew = Bars;
if (barsNew-barsOld==1)
 { 
  bars++;
	
	}
barsOld=Bars;
if (bars>bars_volume_calc)
	{
	   bars= 1; 
	   askV=0;
	   bidV=0;
	   n=1;
	   return;
 }
	 
    bidNew=Bid;
    askNew=Ask;

  if(askNew>askOld)askV ++;
  if(bidNew>bidOld)bidV++;
   bidOld=Bid;
   askOld=Ask;   
   if( askV==0&&bidV==0) return;
    
if (IsTesting()&&bars<bars_volume_calc) return;
// vavgA =askV/bars_volume_calc;
// vavgB =bidV/bars_volume_calc;
k=(askV+bidV)/(bars_volume_calc);
barsavgvolume();
double koef =k/avg_Vol*100;
koef1[n]=koef;
if (koef>volume_koef&&ticket==0){
  double MA=iMA(ss,PERIOD_M1,periodMA,0,MODE_EMA,PRICE_OPEN,0);
  RefreshRates();
  double deltaS=  (MA -Ask)/tick_size;
   double deltaB= (Bid-MA)/tick_size;
  	 if (deltaS<20&& deltaS>2) 
  	 {
	      while(ticket<1)
	       {
    	       ticket=OrderSend(ss,OP_SELL,QTY,Bid,1000,0,0,0,0,0,Red); }
	      
	       return;
	       }
   if (deltaB >2&&deltaB <20)  
	   {  
	   while(ticket<1)
	      {
	          ticket=OrderSend(ss,OP_BUY,QTY,Ask,1000,0,0,0,0,0,Red);
	      }
	     
	       return;
	       }
}
if (ticket!=0)
{
    chek_open_pos();
        
   }
    
  return(0);
}
 
void chek_open_pos()
{ 
  
  int  Orders_Total= OrdersTotal();
 
             OrderSelect(0, SELECT_BY_POS, MODE_TRADES ); 
             RefreshRates();
            if (OrderType()==OP_BUY ) {   orderprof=(Bid -OrderOpenPrice())/tick_size;}
            if (OrderType()==OP_SELL ) {   orderprof=(OrderOpenPrice()-Ask)/tick_size;}
            
            
              if (orderprof>=profit||orderprof<=(-1)*loss||(Pos_hold_time_restriction&&(TimeCurrent()-OrderOpenTime()>Hold_pos_max_time_minutes*60)&&orderprof>0))
               {
                   while(ticket>0)
                 { 
                   if( OrderClose(ticket, QTY,Ask,1000,0)==true)
                   { ticket=0;
                   return;
                   }
                 }
                }
            
    
        
        
 return;
}
void barsavgvolume()
{ 
  avg_Vol=0;
  int i; 
for(i=Bars-bars_volume_calc;i<Bars;i++)
   avg_Vol+= Volume[i];

 }   

    