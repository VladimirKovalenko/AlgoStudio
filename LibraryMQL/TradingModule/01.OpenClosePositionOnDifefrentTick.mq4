extern double i=10;
extern int OpenStep=1;
extern int CloseStep=1;
int bar, count, count2,send, OpenBar, CloseBar;
bool tick;

int init()
{
	OpenBar=OpenStep+Bars;
	CloseBar=OpenStep+CloseStep+Bars;
}

void OpenPosi()
{
	bar=Bars;
	Print("Bars= "+Bars+ " Openbar= "+OpenBar);
	if(Bars==OpenBar && count!=bar)
	{
		send=OrderSend(Symbol(), OP_BUY, i, Ask, 10, 0,0);
		tick=OrderSelect(send,SELECT_BY_TICKET, MODE_TRADES);
	    count=bar;
	    OpenBar=OpenBar+OpenStep;
	}
}

void ClosePosi()
{	
	bar=Bars;
	if(Bars==CloseBar && count2!=bar)
	{
		bool close=OrderClose(send, i, Bid, 100);
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
		if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
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
