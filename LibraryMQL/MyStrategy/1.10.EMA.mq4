/*Strategy for forex instrument*/

extern string   CCYSettings		 		= "===== CCY Settings ======================================";
extern string 	SecondCurrency			="EUR/JPY";
extern string 	ThirdCurrency			="EUR/CHF";

extern string   GeneralSettings 		= "===== General Settings ==================================";
extern double 	Lots  					= 1;
extern int 		MAGIC 					= 456;
extern int 		slow 					= 50;
extern int 		fast 					= 25;

extern string   LotOptimizerSettings    = "===== Lot Optimizer Settings ============================";
extern bool 	UseLotOptimizer			= true;
extern double 	MaximumRisk_perc		= 5; 	//Changes from 0.00001 to 100
extern int      DecreaseFactor  		= 2; 	//Changes from 1 to infinity
extern int      IncreaseFactor  		= 2;	//Changes from 1 to infinity

extern string   SLTPSettings		    = "===== SL/TP settings ====================================";
extern bool 	UseSLTPModule			=false;
extern int 		takeProfit_pips			=50;
extern int 		stopLoss_pips			=50;

extern string   LoggingSetup    		= "===== Logging Settings ==================================";
extern bool 	WriteLogs				=false;

double 	sredniaSlow, sredniaFast, openPrice,closePrice,takeProfit_absol,stopLoss_absol;
int 	side,ticket[3];
int 	fileName[3];
bool 	OpenPosi[3] ={false,false,false};
string 	instrument[3];

//+------------------------------------------------------------------+
//| START Function Open Positions                         			 |
//+------------------------------------------------------------------+

void openOrder(int openSide, int instrIndex)
{
	if(openSide==OP_BUY)
		openPrice=MarketInfo(instrument[instrIndex],MODE_ASK);
	else openPrice=MarketInfo(instrument[instrIndex],MODE_BID);
	
	if(!UseSLTPModule)
	{
		takeProfit_absol=0;
		stopLoss_absol=0;
	}
	else
	{
		takeProfit_absol=openPrice+(takeProfit_pips*MarketInfo(instrument[instrIndex], MODE_POINT));
		stopLoss_absol=openPrice-(stopLoss_pips*MarketInfo(instrument[instrIndex], MODE_POINT));
	}
	
	ticket[instrIndex] = OrderSend(instrument[instrIndex],openSide,LotsOptimized(instrIndex),openPrice,40,takeProfit_absol,stopLoss_absol,"",MAGIC);
	int lastOpenError=GetLastError();
	if (lastOpenError!=0 || ticket[instrIndex]<0) 
	{
		Print(Bars+" :Error by instrumet "+instrument[instrIndex]+", during open position: "+lastOpenError);
		Logging(instrIndex, ("~7:"+Bars+" :Error by instrumet "+instrument[instrIndex]+", during open position: "+lastOpenError));
	}
	else 
	{
		Print(Bars+" :Position opened by "+instrument[instrIndex]);
		Logging(instrIndex,("~8:"+Bars+" :Position opened by "+instrument[instrIndex]));
		OpenPosi[instrIndex] = true;
	}
}

//+------------------------------------------------------------------+
//| STOP Function Open Positions                          			 |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| START Function Close Trade                              		 |
//+------------------------------------------------------------------+

void closeOrder(int closeSide, int instrIndex)
{
	bool selectOrder=OrderSelect(ticket[instrIndex], SELECT_BY_TICKET);
	if (OrderType()== closeSide && OrderMagicNumber()==MAGIC)
	{
		
		if(closeSide==OP_BUY)
			closePrice=MarketInfo(instrument[instrIndex],MODE_BID);
		else closePrice=MarketInfo(instrument[instrIndex],MODE_ASK);
		
		bool close=OrderClose(ticket[instrIndex], OrderLots(), closePrice, 40);
		int lastCloseError=GetLastError();
		if (lastCloseError!=0 || close!=1) 
		{
			Print(Bars+" :Error by instrument "+instrument[instrIndex]+", during close position: "+lastCloseError);
			Logging(instrIndex, ("~5:"+Bars+" :Error by instrument "+instrument[instrIndex]+", during close position: "+lastCloseError));
		}
		else 
		{
			Print(Bars+" :Position closed by "+instrument[instrIndex]);
			Logging(instrIndex, ("~6"+Bars+" :Position closed by "+instrument[instrIndex]));
			OpenPosi[instrIndex] = false;
			ticket[instrIndex]=0;
		}
	}		
}

//+------------------------------------------------------------------+
//| END Function Close Trade                                		 |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| START Calculate optimal lot size                                 |
//+------------------------------------------------------------------+

double LotsOptimized(int instrIndex)
{
	if(UseLotOptimizer==false) return(Lots);
	if(MaximumRisk_perc<0.00001)	MaximumRisk_perc=0.00001;
	if(MaximumRisk_perc>100)		MaximumRisk_perc=100;
	
	double lot=Lots;
	int    count=0, losses=0, profit=0;
	int    decimalPlaces=MathAbs(MathLog(MarketInfo(instrument[instrIndex], MODE_MINLOT)));
	int    orders=HistoryTotal();
	
	lot=NormalizeDouble(AccountEquity()*MaximumRisk_perc/(MarketInfo(instrument[instrIndex], MODE_LOTSIZE)),decimalPlaces);

	if(DecreaseFactor>0 || IncreaseFactor>0)
	{
		if(DecreaseFactor<1) DecreaseFactor=1;
		if(IncreaseFactor<1) IncreaseFactor=1;
		
		for(int i=orders-1;i>=0;i--)
		{
			if(count>2) break;
			if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
			{
				Print("Error in history!"); 
				Logging(instrIndex, "~4:Error in history");
				break;
			}
			if(instrument[instrIndex]==OrderSymbol())
			{
				if(OrderProfit()>0) profit++;
				if(OrderProfit()<0) losses++;
				count++;
			}
		}
		if(losses>1) lot=NormalizeDouble(lot-lot/DecreaseFactor,decimalPlaces);
		if(profit>1) lot=NormalizeDouble(lot+lot*IncreaseFactor,decimalPlaces);
	}
		
	if (lot<MarketInfo(instrument[instrIndex], MODE_MINLOT))
		lot=MarketInfo(instrument[instrIndex], MODE_MINLOT);
		
	Logging(instrIndex, "~3:Lot after optimization= "+lot);
	return(lot);
}

//+------------------------------------------------------------------+
//| END Calculate optimal lot size                                   |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| START logging data				                                 |
//+------------------------------------------------------------------+

void Logging(int instrIndex, string line)
{
	if(WriteLogs==false) return;
	
	int write;
	if (instrIndex==-1)
	{
		for(instrIndex=0; instrIndex<3; instrIndex++)
		{
			write=FileWrite(fileName[instrIndex],"Time= "+TimeToStr(Time)+ "; Bars= "+Bars+": "+line);
			FileFlush(fileName[instrIndex]);
		}
	}
	
	else if(instrIndex>=0 && instrIndex<=3)
	{
		write=FileWrite(fileName[instrIndex],"Time= "+TimeToStr(Time)+ "; Bars= "+Bars+": "+line);
		FileFlush(fileName[instrIndex]);
	}
	
	else Print("Problem in Logging, index out of range"+instrIndex);
}

//+------------------------------------------------------------------+
//| END logging data				                                 |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| START Preffered Settings                                         |
//+------------------------------------------------------------------+

int init()
{
	//------Logging block start ----------
	fileName[0]= FileOpen("C:\\AlgoLog\\FirstInst("+TimeLocal()+").csv",FILE_CSV|FILE_WRITE);
	if(fileName[0]==-1) Print("File did not open with error: "+GetLastError());
	
	fileName[1]= FileOpen("C:\\AlgoLog\\SecondInst("+TimeLocal()+").csv",FILE_CSV|FILE_WRITE);
	if(fileName[1]==-1)Print("File did not open with error: "+GetLastError());
	
	fileName[2]= FileOpen("C:\\AlgoLog\\ThirdInst("+TimeLocal()+").csv",FILE_CSV|FILE_WRITE);
	if(fileName[2]==-1)Print("File did not open with error: "+GetLastError());
	
	if (fileName[0]<0 && fileName[1]<0 && fileName[2]<0)
		Logging(-1, "~2:One of the file did not open");
	//------Logging block end----------
}

//+------------------------------------------------------------------+
//| END Preffered Settings                                           |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| START EA                                                         |
//+------------------------------------------------------------------+

int start()
{
	instrument[0]=Symbol();
	instrument[1]=SecondCurrency;
	instrument[2]=ThirdCurrency;
	
	if(Bars<slow+2)
	{
		Print("bars less than ", slow+2);
		return(0);
	}
		
	for(int index=0; index<ArrayRange(instrument,0);index++)
	{
		sredniaSlow=iMA(instrument[index],0,slow,0,MODE_SMA,PRICE_CLOSE,1);
		sredniaFast=iMA(instrument[index],0,fast,0,MODE_SMA,PRICE_CLOSE,1);
		
		bool selectOrder=OrderSelect(ticket[index], SELECT_BY_TICKET);
		if(OrderCloseTime()!=0 && OpenPosi[index]!=0)
		{
			OpenPosi[index]=false;
			ticket[index]=0;
		}
		
		Logging(index, ("~1:Fast: "+ sredniaFast+ "\tSlow: "+ sredniaSlow+"\tdelta: "+NormalizeDouble((sredniaFast-sredniaSlow),8)+"\tOpenPosi["+index+"]: "+OpenPosi[index]));
		
		if (sredniaFast < sredniaSlow && OpenPosi[index] == false)
			openOrder(OP_SELL,index);
	
		if (sredniaFast > sredniaSlow && OpenPosi[index] == false)
			openOrder(OP_BUY,index);
			
		if (sredniaFast > sredniaSlow) 
			closeOrder(OP_SELL,index);
	
		if (sredniaFast < sredniaSlow) 
			closeOrder(OP_BUY,index);
	}
	return(0);
}
 
//+------------------------------------------------------------------+
//| END EA                                                           |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| START Ending Settings                                            |
//+------------------------------------------------------------------+

int  deinit()
{
    FileClose(fileName[0]);
    FileClose(fileName[1]);
    FileClose(fileName[2]);
}

//+------------------------------------------------------------------+
//| START Ending Settings                                            |
//+------------------------------------------------------------------+