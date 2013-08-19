extern double i=0.01;
int count, count2,send1, send2, send3;
int start()
{ 
int bar=Bars;
if (Bars==50){
Print("ddfdf");
}
if(bar%50==0 && count!=bar){
		send1=OrderSend("EURUSD", OP_BUY, i, Ask, 0, 0,0);
	    bool select1=OrderSelect(send1, SELECT_BY_TICKET, MODE_TRADES);
	    send2=OrderSend("CHFJPY", OP_BUY, i, MarketInfo("CHFJPY",MODE_ASK), 0, 0,0);
	    bool select2=OrderSelect(send2, SELECT_BY_TICKET, MODE_TRADES);
	    send3=OrderSend("EURCHF", OP_BUY, i, MarketInfo("EURCHF",MODE_ASK), 0, 0,0);
	    bool select3=OrderSelect(send3, SELECT_BY_TICKET, MODE_TRADES);
	    count=bar;
//     Print(Close, "   ",Bars);
     }
     if(bar%70==0 && count2!=bar){
//     	bool select2=OrderSelect(send, SELECT_BY_TICKET);
     	bool close1=OrderClose(send1, i, 0, 0);
     	bool close2=OrderClose(send2, i, 0, 0);
     	bool close3=OrderClose(send3, i, 0, 0);
     	count2=bar;
     }
  return(0);
}