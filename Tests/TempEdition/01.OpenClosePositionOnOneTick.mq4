extern int length=1;//через сколько баров ставить позицию
int bar,tick;

int init(){	//Присваиваем переменной текущее значение бара для условия
	bar=Bars;	
//	Print(bar);
	}
	
int start()
{
	Print("Bars=", Bars, ": bar=", bar, ": length=", length);
	if (Bars==bar+length){
		bool f=OrderSelect(tick, SELECT_BY_TICKET);
		bool tickclose=OrderClose(tick, 1, Bid,10);
		tick=OrderSend(Symbol(), OP_SELL,1,Ask, 10,0,0);
		Print(GetLastError(),"  ", GetLastErrorDescription());
//		OrderPrint();
		Print(Bid, "   ", Ask );
		bar=Bars;
	}
  return(0);
}