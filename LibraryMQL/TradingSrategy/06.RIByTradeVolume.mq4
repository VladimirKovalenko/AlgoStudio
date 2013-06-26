/*Если объём сделок за последние 60 сек.> чем 1.2*среднее количество сделок 
за последние 10 минут, то торгуем. Входим по направлению движение последних 
60 секунд. тейкпрофет 100 пунктов, стоп лосс 50 пунктов.*/

extern int TP=100;
int side,ticket=0;
double price, sl, tp;

//Функция для отлова ошибок. Работает, проверил.
int errorLog()
{
	int err=GetLastError();
	if(err!=0)
		Print(err);
}

/*Проводит выборку бара через указанное время в прошлом.
range - сколько секунд назад надо найти бар
shift - сдвиг в секундах из-за того что бары не чётко привязаны к времени*/
int selectBar(int range, int shift)
{
	datetime time=(TimeCurrent()-range);	
	int shiftTime=iBarShift(Symbol(), 0, time, false);
	if(Time[shiftTime]>time-shift)	//-shift секунд из-за того что тиковые бары не чётко по времени привязаны.
		return(-1);
	else return(shiftTime);
}

int volumeCounter(int bar)
{	
	int totalVolume=0;
	for(int index=0; index<bar; index++)
	{
		totalVolume=totalVolume+Volume[index];
	}
	return(totalVolume);
}

int positionSide(int bar1)
{
	double result=(Bid+Ask)/2-Close[bar1];
	if(result>=0)
		return(0);
	else return(1);
}

int start()
{
	datetime closeTime=OrderCloseTime();
	if(ticket!=0)
		if(closeTime==0)
			return;
	
	int bar10=selectBar(600, 10);
	if(bar10==-1)
		return;
		
	int bar1=selectBar(60, 1);
	if(bar1==-1)
	{
		Print("Warning, bar1 return -1");
		return;
	}
	
	int volume10=volumeCounter(bar10);
	int volume1=volumeCounter(bar1);
	

	side=positionSide(bar1);
	
	if(side==0)	
	{
		price=Ask;
		sl=Bid-TP/2*Point;
		tp=Bid+TP*Point;
	}
	else
	{	
		price=Bid;
		sl=Ask+TP/2*Point;
		tp=Ask-TP*Point;
	}
	
	
	if(volume1 > (1.2*(volume10/10)))
	{
		ticket=OrderSend(Symbol(),side, 1, price,30, sl,tp);
		errorLog();
		bool select=OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
		errorLog();
	}
}