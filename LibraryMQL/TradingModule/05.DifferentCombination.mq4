int writeFile, file;
int tempCounter=0, counter=0, failCounter=0, setCounter=0;
double coeficient[]={ 0,-1000,-10, -0.99, -0.001, 0.001, 0.99, 10, 1000};
double SLTPArray[18]; //надо руками задавать размер.

string symbolArray[1];

int cmdArary[]={0,1,2,3,4,5};	//OP_BUY=0,	OP_SELL=1, OP_BUYLIMIT=2,OP_SELLLIMIT=3, OP_BUYSTOP=4,OP_SELLSTOP=5
double volumeArray[]={-100, -1.0, -0.99, -0.1, -0.00001, 0, 0.00001, 0.001, 0.1, 0.99, 1,100};
double priceArray[]={ , , -100, -1, -0.99, -0.0000001, 0, 0.0000001, 0.99, 1, 100};

int slippageArray[]={-100,-1,-0.2,0,0.2,1,100};
string commentArray="";
int magicArray=0;
datetime expirationArray=0;
color arrow_colorArray=Black;
	
	
int errorLog()
{
	int err=GetLastError();
	if(err!=0)
	{
		Print("Order did not set, error: "+ err);
		writeFile=FileWrite(file, "Order did not set, error: "+ err);
	}
		
}

int init()
{
	allTrade();
}

int deinit()
{
	FileClose(file);
	return(0);
}

void allTrade()
{
	symbolArray[0]=Symbol();
	priceArray[0]=Bid;
	priceArray[1]=Ask;
	
	//определение массива для СЛ ТП...самому не нравится
	for(int AskArrayIndex=0; AskArrayIndex<ArraySize(coeficient); AskArrayIndex++)
	{
		SLTPArray[AskArrayIndex]=2 + coeficient[AskArrayIndex] * Point;
	}
	for(int BidArrayIndex=ArraySize(coeficient); BidArrayIndex<(ArraySize(coeficient)*2);BidArrayIndex++)
	{
		SLTPArray[BidArrayIndex]=1 + coeficient[BidArrayIndex - ArraySize(coeficient)] * Point;
	}
	
	for(int symbolIndex=0; symbolIndex<ArraySize(symbolArray); symbolIndex++)
	{
		for(int cmdIndex=0; cmdIndex<ArraySize(cmdArary); cmdIndex++)
		{
			if(cmdIndex==tempCounter)
			{
				file= FileOpen("C:\\Program Files (x86)\\MetaTrader 4\\tester\\files\\TestAS"+cmdIndex+".csv",FILE_CSV|FILE_WRITE|FILE_READ,';');
			//	file= FileOpen("TestMT"+cmdIndex+".csv",FILE_CSV|FILE_WRITE|FILE_READ,';');
				tempCounter=cmdIndex+1;
			}
			for(int volumeIndex=0; volumeIndex<ArraySize(volumeArray); volumeIndex++)	
			{
				for(int priceIndex=0; priceIndex<ArraySize(priceArray); priceIndex++)	
				{
					for(int slippageIndex=0; slippageIndex<ArraySize(slippageArray); slippageIndex++)
					{
						for(int stopLossIndex=0; stopLossIndex<ArraySize(SLTPArray);stopLossIndex++)
						{
							for(int takeProfitIndex=0; takeProfitIndex<ArraySize(SLTPArray);takeProfitIndex++)
							{	
								string symbol=symbolArray[symbolIndex];	
								int cmd=cmdArary[cmdIndex];
								double volume=volumeArray[volumeIndex];
								double price=priceArray[priceIndex];
								int slippage=slippageArray[slippageIndex];
								double stoploss=SLTPArray[stopLossIndex];
								double takeprofit=SLTPArray[takeProfitIndex];
								string comment="";
								int magic=0;
								datetime expiration=0;
								color arrow_color=Black;
								
								int ticker=OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic, expiration, arrow_color);
								errorLog();
								if(ticker>0)
								{
									writeFile=FileWrite(file, "SET("+symbolIndex+","+ cmdIndex+","+ volumeIndex+","+ priceIndex+slippageIndex+", "+stopLossIndex+
									", "+takeProfitIndex+") \t"+symbol+" "+cmd+" "+DoubleToStr(volume,4)+" "+/*price+*/" "+slippage+" "+DoubleToStr(stoploss,5)+
									" "+DoubleToStr(takeprofit,5)+" "+comment+" "+magic+" "+expiration+" "+arrow_color+"\n");
									setCounter++;
								}
								
								if(ticker<=0)
								{
									writeFile=FileWrite(file, "FAIL("+symbolIndex+","+ cmdIndex+","+ volumeIndex+","+ priceIndex+slippageIndex+", "+stopLossIndex+
									", "+takeProfitIndex+") \t"+symbol+" "+cmd+" "+DoubleToStr(volume,4)+" "+/*price+*/" "+slippage+" "+DoubleToStr(stoploss,5)+
									" "+DoubleToStr(takeprofit,5)+" "+comment+" "+magic+" "+expiration+" "+arrow_color+"\n");
									failCounter++;
								}
								counter++;
							}
						}
					}
				}
			}
		}
	}
	Print("All iteration= " +counter+ " Orders set= " + setCounter+ " Orders failed= "+failCounter);
	writeFile=FileWrite(file, "All iteration= " +counter+ " Orders set= " + setCounter+ " Orders failed= "+failCounter);
}