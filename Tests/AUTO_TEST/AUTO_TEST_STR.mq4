extern double lots=1;

//OpenStep не должен быть меньше CloseStep
int OpenStep=100;
int CloseStep=50;
int bar, count, count2,send, OpenBar, CloseBar, err;
bool tick;

int init()
{
	Print("Start AUTOTEST_STR");
	OpenBar=OpenStep+Bars;
	CloseBar=OpenStep+CloseStep+Bars;
}

void OpenPosi()
{
	bar=Bars;
	if(Bars==OpenBar && count!=bar)
	{
		send=OrderSend(Symbol(), OP_BUY, lots, Ask, 10, 0,0);
		err=GetLastError();
		if(err!=0)
			Print(err);
			
		tick=OrderSelect(send,SELECT_BY_TICKET, MODE_TRADES);
		err=GetLastError();
		if(err!=0)
			Print(err);
	    count=bar;
	    OpenBar=OpenBar+OpenStep;
	}
}

void ClosePosi()
{	
	bar=Bars;
	if(Bars==CloseBar && count2!=bar)
	{
		bool close=OrderClose(send, lots, Bid, 100);
		err=GetLastError();
		if(err!=0)
			Print(err);
			
		if(close!=true)
		{
			Print(GetLastError());
		}
	    count2=bar;
	    CloseBar=CloseBar+OpenStep;
    }
}

void PrintOrder()
{
	int    orders=HistoryTotal();
	for(int i=orders-1;i>=0;i--)
    {
		if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
		{
			Print("Error in history!");
			break; 
		}
		double prof=OrderProfit();
		OrderPrint();
	}
}

int start()
{ 
	OpenPosi();
	ClosePosi();
//	PrintOrder();
	return(0);
}
