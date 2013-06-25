extern int TradeNumbers=100;
extern bool CalcTimeOnEveryTrade=false;
extern string spliter1="-----------------";
extern bool UseTimeLocal=false;
extern bool UseTimeCurrent=false;
extern string spliter2="-----------------";
extern bool CheckFirsLastTradeTime=true;
int counter=0, result=0;
int TimeArr[];

void MatrixResize() //Если размер матрицы на задан или количество элементов было переопределено, то эта функция делает ресайз.
{
	if(ArraySize(TimeArr)!=TradeNumbers)
	{
		int resize=ArrayResize(TimeArr, TradeNumbers);
	}
}

double TimeType()
{
	if(UseTimeLocal) return(TimeLocal());
	if(UseTimeCurrent) return(TimeCurrent());
}

/*Не очень хороший метод так как для TimLocal бывает рассинхронка времени сервака и клиента, а на 
TimeCurrent влияет ликвиднось инструмента.
*/
void CalcTimeOnEveryTradeMode()
{
	if (CalcTimeOnEveryTrade==true)
	{
		MatrixResize();
		while(counter<TradeNumbers)
		{
			datetime StartTime=TimeType(); //Можно испльзовать TimeLocal а можно CurrentTime
			int ticket=OrderSend(Symbol(), OP_BUY, 0.1, Ask,100, 0,0,"", 123);
			int select=OrderSelect(ticket, SELECT_BY_TICKET);
			datetime OpenTime=OrderOpenTime();
			
			if(OpenTime==0) return;
			Print("OpenTime= "+OpenTime+"  StartTime= "+StartTime);
			double DeltaTime=OpenTime-StartTime;
			Print(DeltaTime); 
			TimeArr[counter]=DeltaTime;
			result=result+DeltaTime;
			counter++;
		}
		Print(result);
	}
}

void CheckFirsLastTradeTimeMode()
{
	if (CheckFirsLastTradeTime==true)
	{
		MatrixResize();
		while(counter<TradeNumbers)
		{
			int ticket=OrderSend(Symbol(), OP_BUY, 0.1, Ask,100, 0,0,"", 123);
			int select=OrderSelect(ticket, SELECT_BY_TICKET);			
			if(counter==0)
			{
				datetime StartTime=OrderOpenTime();
			}
			if(counter==TradeNumbers-1)
			{
				datetime OpenTime=OrderOpenTime();
			}
			if(ticket<0) return;
			counter++;
		}
		double DeltaTime=OpenTime-StartTime;
		Print(DeltaTime);
	}
}

int start()
{	
	CalcTimeOnEveryTradeMode();
	CheckFirsLastTradeTimeMode();
	return(0);
}
