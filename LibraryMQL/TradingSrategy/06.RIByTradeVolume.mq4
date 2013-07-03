/*≈сли объЄм сделок за последние 60 сек.> чем 1.2*среднее количество сделок 
за последние 10 минут, то торгуем. ¬ходим по направлению движение последних 
60 секунд. тейкпрофет 100 пунктов, стоп лосс 50 пунктов.

также заменить "количество сделок" на "движение"*/

extern int TP=10;
int side,bar10,bar1,ticket=0;
double price, sl, tp;

//‘ункци€ дл€ отлова ошибок. –аботает, проверил.
int errorLog()
{
	int err=GetLastError();
	if(err!=0)
		Print(err);
}

/*ѕроводит выборку бара через указанное врем€ в прошлом.
range - сколько секунд назад надо найти бар
shift - сдвиг в секундах из-за того что бары не чЄтко прив€заны к времени*/
int selectBar(int range, int shift)
{
	datetime time=(TimeCurrent()-range);	
	int shiftTime=iBarShift(Symbol(), 0, time, false);
	
	/*ѕровер€ет соответствует ли выбранный бар интервалу в 10 мин - shiuft
	shift секунд из-за того что тиковые бары не чЄтко по времени прив€заны.*/
	if(Time[shiftTime]>time-shift)	
		return(-1);
	else return(shiftTime);
}

int volumeCounter(int bar)
{	
	double totalVolume=0; 
	for(int index=0; index<bar; index++)
	{
		totalVolume=totalVolume+Volume[index];
		
		if(totalVolume>2147483646 || totalVolume<-2147483646)	//если работать по форексам то бывает переполнение
		{
			Print("Constant 'totalVolume' more or less then integer");
			return(-1);
		}
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

void sendPosition()
{
	int volume10=volumeCounter(bar10);
	int volume1=volumeCounter(bar1);
	if(volume10==-1 || volume1==-1)
		return;
	Print("Time: "+TimeToStr(TimeCurrent())+": Volume1= "+volume1+": volume10/10= "+volume10/10);

	if(volume1 > (1.2*(volume10/10)))
	{
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
		
		Print("-------sendPosition call-----------");
		ticket=OrderSend(Symbol(),side, 1, price,30, sl,tp);
		errorLog();
		bool select=OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
		errorLog();
	}
}

int start()
{
	datetime closeTime=OrderCloseTime();
	if(ticket!=0)
		if(closeTime==0)
			return;
	
	bar10=selectBar(600, 10);
	bar1=selectBar(60, 1);
	
	if(bar1==-1 || bar10==-1)
	{
		Print("Warning, bar1 or bar10 return -1");
		return;
	}
	
	sendPosition();
}