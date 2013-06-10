//---------------------------------------------------
// Project: TrailingStop
// Language: MQL4
// Type: Strategy
// Author: Karol Marchewka
// Company: PFSoft
// Copyright: Karol Marchewka
// Created: 2012-12-17
//---------------------------------------------------

#define MAGIC 352320 

extern double TrailingStop = 10.0;

int init()
{

  return(0);
}

int deinit()
{

  return(0);
}

int start()
{

  return(0);
}

void TrailingStopLongPositions()
{
   for (int i = 0; i < OrdersTotal(); i++)
   {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MAGIC)
      {
         if (OrderType() == OP_BUY)
         {
            if(TrailingStop > 0)  
            {                 
               if (Bid - OrderOpenPrice() > Point * TrailingStop)
               {
                  if (OrderStopLoss() < Bid - Point * TrailingStop)
                  {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * TrailingStop, OrderTakeProfit(), 0, Aqua);
                  }
               }
            }
         }
      }
   }      
}

int TrailingStopShortPositions()
{
   for (int i = 0; i < OrdersTotal(); i++)
   {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MAGIC)
      {
         if (OrderType() == OP_SELL)
         {
            if (TrailingStop > 0)  
            {                 
               if (OrderOpenPrice() - Ask > Point * TrailingStop)
               {
                  if (OrderStopLoss() > Ask + Point * TrailingStop)
                  {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * TrailingStop, OrderTakeProfit(), 0 , Magenta);
                  }
               }
            }
         }         
      }
   }
}
