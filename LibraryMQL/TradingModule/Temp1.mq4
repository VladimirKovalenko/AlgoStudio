int totaltrades;
int i, ticket;
double _array[];
extern bool show  = true;
int _profit = 0;
 
 
int start()
{    
//	if(Bars%70==0)	 	
//	{

		bool clo=OrderClose(ticket, 1, Bid,30);
		ticket = OrderSend(Symbol(),OP_BUY,1,Ask,30,0,0);
		totaltrades = OrdersHistoryTotal();
		int resize=ArrayResize(_array,totaltrades);     
		
		for(i=0;i<totaltrades;i++)
		{
			if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderSymbol() == Symbol())
			{
				_array[i] = OrderProfit();
				Print("Trade number:  ",i,"  Trade instrument:  ", Symbol(), "  Trader Profit:  ", _array[i]);       
			}
		} 
		
		if ( (_array[totaltrades-2] > 0) && (_array[totaltrades-1] > 0) && (_array[totaltrades] > 0 )) 
			_profit = 1 else _profit =0;
		
		Print ("Last three trades: ", _profit,"  ", _array[totaltrades-3],"  ",_array[totaltrades-2],"  ",_array[totaltrades-1] );
		Sleep(1000);
//	}  
	return(0);
}