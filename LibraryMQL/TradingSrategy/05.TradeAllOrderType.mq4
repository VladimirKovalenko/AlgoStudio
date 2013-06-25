#include <WinUser32.mqh>

double lots=1;
int ticket, caseNumber=0;

//открывает ордера
void orderSender()	
{
	orderCloser();
//	Print("3");
	ticket=OrderSend(Symbol(), OP_BUY, lots, Ask, 100, 0,0);
	int error=GetLastError();
	
	if(error!=0)
		Print("orderSender invoke error= ", error);
	else Print("Order open successfully with ticket ", ticket);
}

//закрывает ордера
void orderCloser()
{
//	Print("2");
	
	if(ticket<1)
	{
		Print("Не удалось закрыть ордер, не найден ордер с тикетом ",ticket);
		return;
	}
	bool close=OrderClose(ticket, lots, Bid, 100);
	int error=GetLastError();
	
	if(error!=0 || !close)
		Print("orderCloser invoke error= ", error);
	else Print("Order with ticket ", ticket, " close successfully");
}

int start()
{
	if(caseNumber==-1)
		return;
//	Print("1");
	
	orderSender();
	int ret=MessageBox("Ляськи масяськи", "Question", MB_ABORTRETRYIGNORE|MB_ICONQUESTION);	//ignor значит все ок
//	Print("4");
	if(ret==3)
		caseNumber=-1;
	if(ret==4)
		return(caseNumber);
	if(ret==5)
		return(caseNumber+1);
}

int deinit()
{
	Print("deinit invoke");
	orderCloser();
}