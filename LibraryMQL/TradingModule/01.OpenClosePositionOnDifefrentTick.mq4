extern double i=1;
extern int OpenStep=1;
extern int CloseStep=1;
int bar, count, count2,send, OpenBar, CloseBar;
bool tick,firstQuote=true;

int errorLog()
{
	int err=GetLastError();
	if(err!=0)
		Print(err);
}

void OpenPosi()
{
	bar=Bars;
	Print("Bars= "+Bars+ " Openbar= "+OpenBar);
	if(Bars==OpenBar && count!=bar)
	{
		send=OrderSend(Symbol(), OP_BUY, i, Ask, 10, 0,0);
		errorLog();
		tick=OrderSelect(send,SELECT_BY_TICKET, MODE_TRADES);
		errorLog();
	    count=bar;
	    Print("-----");
	    OpenBar=OpenBar+OpenStep;
	}
}

void ClosePosi()
{	
	bar=Bars;
	if(Bars==CloseBar && count2!=bar)
	{
		bool close=OrderClose(send, i, Bid, 100);
		errorLog();
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
			errorLog();
			Print("Error in history!"); 
			break; 
		}
		double prof=OrderProfit();
		OrderPrint();
	}
}

int start()
{ 
	if(firstQuote)
	{
		OpenBar=OpenStep+Bars;
		CloseBar=OpenStep+CloseStep+Bars;
	}
	firstQuote=false;
	ClosePosi();
	OpenPosi();
//	PrintOrder();
	return(0);
}
