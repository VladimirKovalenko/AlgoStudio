//+------------------------------------------------------------------+
//|                                                LatencyTester.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""

//#import "kernel32.dll"
//   int GetTickCount();
//#import

#include <stderror.mqh>
#include <stdlib.mqh>
extern double lot=0.01;
datetime PreviousBar;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
      if(!IsNewBar()) return;
      Print("Новый бар");
      CloseAll();
      Print("Ордера закрыты");
      Print(Close[1]+" "+Close[2]);
      if(Close[1]>Close[2]) Trade(OP_BUY);
      if(Close[1]<Close[2]) Trade(OP_SELL);
      
//----
   return(0);
  }
//+------------------------------------------------------------------+

int Trade(int type)
{
   int orderID;
   int time1, time2;
   RefreshRates();
   if(type==OP_SELL)
   {
      time1=GetTickCount();
      orderID=OrderSend(Symbol(),OP_SELL,lot,Bid,0,0,0);
      time2=GetTickCount();
   }
   else if(type==OP_BUY)
   {
      time1=GetTickCount();
      orderID=OrderSend(Symbol(),OP_BUY,lot,Ask,0,0,0);
      time2=GetTickCount();
   }
   int check=GetLastError();
   if(check!=ERR_NO_ERROR)
   { 
      Alert("Error: ",ErrorDescription(check));
      return;
   }
   Alert("Latency, ms : ", time2-time1);
}

bool IsNewBar()
{
	Print(PreviousBar+"  "+iTime(Symbol(),0,0));
   if(PreviousBar<iTime(Symbol(),0,0))
   {
      PreviousBar=iTime(Symbol(),0,0);
      return(true);
   }
   return(false);
}

int CloseAll()
{
   int cnt,total=OrdersTotal();
   int tickets[];
   ArrayResize(tickets,total);
   for(cnt=0;cnt<total;cnt++)
   {
   		Print("Вхожу в 1 цикл");
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
      {
         tickets[cnt]=OrderTicket();
      }
      else
      {
         tickets[cnt]=0;
      }
   }
         
   for(cnt=0;cnt<total;cnt++)
   {
   		Print("Вхожу в 2 цикл");
      if(tickets[cnt]==0) continue;
      RefreshRates();
      if(OrderSelect(tickets[cnt],SELECT_BY_TICKET)==true)
      {
         if(OrderType()==OP_BUY) 
         {
            while(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
            {
            	Print("Сейчас усну");
               Sleep(500);
               RefreshRates();
            }
         }
         else if(OrderType()==OP_SELL) 
         {
            while(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
            {
            	Print("Сейчас усну");
               Sleep(500);
               RefreshRates();
            }
         }
               
      }
   }
}