#property copyright "Copyright: (C) 2013 new_order_check"
extern double WaitTime = 0;
extern int StartTime = 8;
extern int StopLoss = 3;
extern int StopLossZero = 0;
extern int TakeProfit = 3;
extern double Lots = 0.4	;
extern double Magic = 123261;
extern bool WriteLogs=false;
int fileName;

void Logging(string line)
{
	if(WriteLogs==false) return;
	
	int write;
	write=FileWrite(fileName,"Time= "+TimeToStr(Time)+ "; Bars= "+Bars+": "+line);
	FileFlush(fileName);
}

int checkTime(int time) {
//   if(Hour()>=time && Hour()<=time+15) //
     return(1);
//   else 
//     return(0);
}

int checkOrder() {
 int positions = 0;
      Comment("OrdersTotal: "+OrdersTotal());
    for (int i = 0; i < OrdersTotal(); i++)
    {
    	if(OrdersTotal()!=1)
    		Print("Time: "+TimeToStr(TimeCurrent())+"  OrderTotal: "+OrdersTotal());	//~
    		Logging("Time: "+TimeToStr(TimeCurrent())+"  OrderTotal: "+OrdersTotal());	//~
   		
		OrderSelect(i, SELECT_BY_POS, MODE_TRADES);     
       	if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) 
       	{
        	if (OrderType() == OP_BUY || OrderType() == OP_SELL) 
                positions++;
       	}         
    }
   
   if (positions > 0) return(0);
   return(1);
}

datetime LastTrade(int MinutesToWait)
{
   int cnt;
   datetime NextTime;
   bool ClosedForProfit;
   
   NextTime = 0;
   
   for (cnt = HistoryTotal()-1; cnt >=0; cnt--)
   {
      OrderSelect (cnt, SELECT_BY_POS, MODE_HISTORY);      
      if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic) 
      {
			if (OrderType() == OP_BUY || OrderType() == OP_SELL)
	            NextTime = OrderCloseTime()+MinutesToWait*60;
      }
      break;
   }   
   return (NextTime);
}

int init()
{
	fileName= FileOpen("C:\\AlgoLog\\SA("+TimeLocal()+").csv",FILE_CSV|FILE_WRITE);
	if(fileName==-1)
		Print("File did not open with error: "+GetLastError());
	Comment("OrdersTotal: "+OrdersTotal());
}

int start() 
{
	
	int cnt, ticket;
	double account = AccountBalance();
	
	// check for long position (BUY) possibility
	if(checkOrder() == 1 && checkTime(StartTime) == 1 && CurTime() > LastTrade(WaitTime)) 
	{
		ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Ask-StopLoss*10*Point,Ask+TakeProfit*10*Point,"BUY",Magic,0,Green);
		int lastErr1=GetLastError();
		if(ticket>0)
		{
			if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
			{
				Print("BUY order opened : "+OrderOpenPrice()+ "Stop: "+ StopLoss*10*Point+"p "+OrderStopLoss()+"Target:"+OrderTakeProfit());
				Logging("BUY order opened : "+OrderOpenPrice()+"Stop: "+ StopLoss*10*Point+"p "+OrderStopLoss()+"Target:"+OrderTakeProfit());
			}
		}
		else
		{
			Print("Error opening BUY order: Lots:"+Lots+" Stop:"+(Ask-StopLoss*10*Point)+" Profit:"+Ask+TakeProfit*10*Point+" Error: "+lastErr1);
			Logging("Error opening BUY order: Lots:"+Lots+" Stop:"+(Ask-StopLoss*10*Point)+" Profit:"+Ask+TakeProfit*10*Point+" Error: "+lastErr1);
		}
		return(0); 
	}
	
	// check for short position (SELL) possibility
	if(checkOrder() == 1 && checkTime(StartTime) == 1 && CurTime() > LastTrade(WaitTime)) 
	{
		ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,10,Bid+StopLoss*10*Point,Bid-TakeProfit*10*Point,"SELL",Magic,0,Red);
		int lastErr2=GetLastError();
		if(ticket>0)
		{
			if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
				Print("SELL order opened : "+OrderOpenPrice()+ "Stop: "+ StopLoss*10*Point+"p "+ OrderStopLoss()+"Target:"+OrderTakeProfit());
				Logging("SELL order opened : "+OrderOpenPrice()+ "Stop: "+ StopLoss*10*Point+"p "+ OrderStopLoss()+"Target:"+OrderTakeProfit());
		}
		else 
		{
		Print("Error opening SELL order: "+Lots+" Stop:"+(Ask-StopLoss*Point)+" Profit:"+Ask+TakeProfit*Point+" Error: "+lastErr2);
		Logging("Error opening SELL order: "+Lots+" Stop:"+(Ask-StopLoss*Point)+" Profit:"+Ask+TakeProfit*Point+" Error: "+lastErr2);
		}
		return(0); 
	}
	
	
	//Stop to BE    
	for(cnt=0;cnt<OrdersTotal();cnt++)
	{
		Comment("OrdersTotal: "+OrdersTotal());
		OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
		int lastErr3=GetLastError();
		if(lastErr3!=0)
		{
			Print("Problem in select function"+lastErr3);
		}
		if(OrderType()<=OP_SELL &&	OrderSymbol()==Symbol() && OrderMagicNumber() == Magic)
		{   
			if(Bid-OrderOpenPrice()>-5*10*Point )
				Logging("Type: "+OrderType()+"  Bid: "+Bid+"  Ask: "+Ask+"  OrderOpenPrice: "+OrderOpenPrice()+"  StopLossZero: "+StopLossZero+"  OrderStopLoss: "+OrderStopLoss());//~
			
			if(OrderType()==OP_BUY)   // long position is opened
			{
				//move stoploss to breakeven if stoploss+ points gained
				if (Bid-OrderOpenPrice() > StopLossZero*10*Point && OrderStopLoss() < OrderOpenPrice())
				{
					OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Green);
					Print("Order"+OrderTicket()+"Stop to Entry:" + OrderOpenPrice());
					Logging("Order"+OrderTicket()+"Stop to Entry:" + OrderOpenPrice());
					return(0);
				}
			}
			else // go to short position
			{
				//move stoploss to breakeven if stoploss+ points gained
				if (OrderOpenPrice()-Ask > StopLossZero*10*Point && OrderStopLoss() > OrderOpenPrice())
				{
					OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Green);
					Print("Order"+OrderTicket()+"Stop to Entry:" + OrderOpenPrice());
					Logging("Order"+OrderTicket()+"Stop to Entry:" + OrderOpenPrice());
					return(0);
				}
			} //else             
		}
	}
	return(0);
}

int deinit()
{
	FileClose(fileName);
}