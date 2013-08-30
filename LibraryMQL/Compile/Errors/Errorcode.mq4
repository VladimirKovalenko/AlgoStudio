int error=0;

//список всех ошибок
void list()
{
	//0+
	//1+
	//2-
	//3+
	//4-
	//5-
	//6-
	//7-
	//8-
	//9-
	//64+
	//65-
	//128-
	//129+
	//130+
	//131+
	//132+
	//133+
	//134-
	//135-
	//136-
	//137-
	//138+
	//139-
	//140+
	//141-
	//145-
	//146-
	//147+
	//148-
	//149-
	//150-
	//
	//4000
	//4001
	//4002
	//4003
	//4004
	//4005
	//4006
	//4007
	//4008
	//4009
	//4010
	//4011
	//4012
	//4013
	//4014
	//4015
	//4016
	//4017
	//4018
	//4019
	//4020
	//4021
	//4022
	//4050
	//4051
	//4052
	//4053
	//4054
	//4055
	//4056
	//4057
	//4058
	//4059
	//4060+
	//4061
	//4062
	//4063
	//4064
	//4065
	//4066
	//4067
	//4099
	//4100
	//4101
	//4102
	//4103
	//4104
	//4105
	//4106
	//4107
	//4108
	//4109
	//4110
	//4111
	//4200
	//4201
	//4202
	//4203
	//4204
	//4205
	//4206
	//4207
}


//Ошибки которые может присылать сервак взагали
void ErrorFromSErver()
{
	/*
	Order cannot be created, because instrument is not found

	Order cannot be created, because Close Orders not allowed.
	Order cannot be created, because route is not active
	Not tradeable order type.
	Order cannot be created, because amount is forbidden
	Position is already closing
	Order cannot be created, because SL/TP orders is disable.
	Order cannot be created, because OCO Orders not allowed.
	Close order cannot be created, because order is in executing
	Order cannot be created, because option expiration date not allowed
	Order cannot be created, because expiration date is not working day
	Order cannot be created, because wrong expiration date
	Order cannot be created, because wrong expiration date
	Order cannot be created, such contract not tradeable
	Order cannot be created, because Instrument is forbidden
	Order cannot be created, because Instrument type not found
	SL/TP Order cannot be created, because order price too close to base order price
	Order cannot be created, because unknown Order Type
	Order cannot be created, because trailing stop orders is disable
	SL/PT order can't be created, open order for position not completely filled!
	SL/PT order can't be created, open order for position not found!
	Order cannot be created, because TIF and Order Type combination is forbidden by route
	Order cannot be created, because account is closed.
	Order cannot be created, because account is suspended.
	Order cannot be created, because account trading disabled by risk rules.
	Order cannot be created, because Account not found
	No price available!
	No cross price available!
	No cross price for account available!
	SL/TP cannot be created, because order is closed
	Order not allowed
	Order not allowed, because close position is foridden
	Order cannot be created, because short positions are forbidden. You don't have enough rights.
	Order cannot be created, because short positions are forbidden.Or you already have Limit/Stop orders for cover all your positions.
	Order cannot be created, because open positions are forbidden. You don't have enough rights.
	Order cannot be created, because open positions are forbidden. You don't have enough rights.
	Order cannot be created, because Route is forbidden
	You can't trade for this account.
	Wrong price for stoplimit order
	Quote is too old
	   String reason = "Market price [" + instrument.roundPrice(mprice) + "]  is out of range [" + instrument.roundPrice(dialog.getPrice()) + ((order.getOperationType() == Order.OPERATION_TYPE_BUY)
	                        ? "+"
	                        : "-") + instrument.formatPrice(instrument.roundPrice(range)) + "]"
	Service unavailable
	        "This dialog is already processed by another broker.",
	        "Cant send the order request notification to the broker.",
	        "Cant confirm order for execution.",
	        "The quote could not be delivered to user because the user has disconnected from the system.",
	        "The response from the system is not the XML response.",
	        "Cant resume the instrument stream.",                          //5
	        "Session does not exist in the context",
	        "Cant find open session for one of the requested users.",
	        "Cant found the user to set alert.",
	        "Could not submit the alert to the alert executor.",
	        "Cant find processor for the request.",                        // 10
	        "Cant resolve the request from the XML source.",
	        "Cant get input stream from the request to create request.",
	        "Cant confirm creation of the Market Order",
	        "Type (open, close) of order is undefined in the request.",
	        "Type (market, stop, limit) of order is undefined in the request.", //15
	        "Operation type (buy, sell) of order is undefined.",
	        "Cant parse positionId from the request",
	        "Cant find position to close",
	        "Cant send order execution confirmation/refuse/postponse to the order executor",
	        "User role is not defined",                                         // 20
	        "Cant set alert for order execution",
	        "Cant remove alert of another user",
	        "Cant find alert to remove",
	        "Only confirm execute or refuse execute are allowed for market order.",
	        "Cant refuse the execution of stop or limit order",                       //25
	        "Cant find order to propose price.",
	        "Cant save order to the database",
	        "Cant change password bacause of user name or old password is not valid", //28
	        "User name or password is not valid",
	        "Authorization error.",   //30
	        "New password must differ from several previous passwords",
	        "The connection with database was losted. Contact with support team, please", //32
	        "Can't save userin DB", //33
	        "Already authorized",
	        "Not allowed: TargetUserId=SenderUserId", //35
	        "Can't find message by ID",
	        "Cannot generate SMS. Service not avaliable", //37
	        "Illegal price!" ,//38
	        "Request is not supported", //39
	        "Wrong price for stoplimit order"
	        */
}

//Ошибки которые обрабатывает наш ТСЛ
void ErrorOnCLisen()
{
	/*	
	 if (string.IsNullOrEmpty(responce))
                errorCode = PTLRuntime.NETScript.mql4.ERR_COMMON_ERROR;

            else if (responce.Contains("instrument is not found") ||
                responce.Contains("Instrument type not found") ||
                responce.Contains("unknown Order Type") ||
                responce.Contains("open order for position not found") ||
                responce.Contains("Not tradeable order type") ||
                responce.Contains("because order is closed") ||
                responce.Contains("SL/TP orders is disable") ||
                responce.Contains("OCO Orders not allowed") ||
                responce.Contains("trailing stop orders is disable") ||
                responce.Contains("TIF and Order Type combination is forbidden by route") ||
                responce.Contains("of order is undefined in the request") ||
                responce.Contains("Cant find position to close") ||
                responce.Contains("No trading instrument for") ||
                responce.Contains("NO_QUOTES") ||
                responce.Contains("ORDER_DOES_NOT_EXISTS"))
                //В торговую функцию переданы неправильные параметры, например, неправильный символ, неопознанная торговая операция,
                //отрицательное допустимое отклонение цены, несуществующий номер тикета и т.п. 
                errorCode = PTLRuntime.NETScript.mql4.ERR_INVALID_TRADE_PARAMETERS;
            
            else if (responce.Contains("amount is forbidden") ||
                responce.Contains("Invalid amount") ||
                responce.Contains("VOLUME_IS_NULL"))
                errorCode = PTLRuntime.NETScript.mql4.ERR_INVALID_TRADE_VOLUME;
            
            else if (responce.Contains("is in executing") ||
                responce.Contains("is already closing") ||
                responce.Contains("This dialog is already processed by another broker") ||
                responce.Contains("open order for position not completely filled"))
                //Ордер заблокирован и уже обрабатывается
                errorCode = PTLRuntime.NETScript.mql4.ERR_ORDER_LOCKED;
            
            else if (responce.Contains("Instrument is forbidden") ||
                responce.Contains("Account not found") ||
                responce.Contains("Route is forbidden") ||
                responce.Contains("Route doesn't exist") ||
                responce.Contains("Cant found the user") ||
                responce.Contains("Illegal account"))
                //Неправильный номер счета. Необходимо прекратить все попытки торговых операций.
                errorCode = PTLRuntime.NETScript.mql4.ERR_INVALID_ACCOUNT;

            else if (responce.Contains("route is not active") ||
                responce.Contains("You can't trade for this account") ||
                responce.Contains("such contract not tradeable"))
                //Торговля запрещена. Необходимо прекратить все попытки торговых операций
                errorCode = PTLRuntime.NETScript.mql4.ERR_TRADE_DISABLED;

            else if (responce.Contains("too close to base order price") ||
                responce.Contains("Wrong price for stoplimit order"))
                //Слишком близкие стопы
                errorCode = PTLRuntime.NETScript.mql4.ERR_INVALID_STOPS;

            else if (responce.Contains("account is closed") ||
                responce.Contains("account is suspended") ||
                responce.Contains("account trading disabled by risk rules"))
                //Торговля запрещена. Необходимо прекратить все попытки торговых операций.
                errorCode = PTLRuntime.NETScript.mql4.ERR_ACCOUNT_DISABLED;

            else if (responce.Contains("No price available") ||
                responce.Contains("No cross price available") ||
                responce.Contains("No cross price for account available") ||
                responce.Contains("Quote is too old") ||
                responce.Contains("Service unavailable") ||
                responce.Contains("This dialog is already processed by another broker") ||
                responce.Contains("Cant send the order request notification to the broker") ||
                responce.Contains("Cant confirm order for execution"))
                errorCode = PTLRuntime.NETScript.mql4.ERR_OFF_QUOTES;

            else if (responce.Contains("Market is close"))
                errorCode = PTLRuntime.NETScript.mql4.ERR_MARKET_CLOSED;

            else if (responce.Contains("Not enoght margin"))
                errorCode = PTLRuntime.NETScript.mql4.ERR_NOT_ENOUGH_MONEY;

            else if (responce.Contains("short positions are forbidden"))
                errorCode = PTLRuntime.NETScript.mql4.ERR_LONG_POSITIONS_ONLY_ALLOWED;

            else if (responce.Contains("Illegal price") ||
                responce.Contains("Invalid price for order"))
                errorCode = PTLRuntime.NETScript.mql4.ERR_INVALID_PRICE;

            else if (responce.Contains("timeout") ||
                responce.Contains("Time out"))
                errorCode = PTLRuntime.NETScript.mql4.ERR_TRADE_TIMEOUT;
                */
}

//---------------------------------

//Всё хорошо
void _0ERR_NO_ERR()
{
	int ticket=OrderSend(Symbol(), OP_BUY, 1, Ask,100, 0,0);
	Print(GetLastError());	
}

//Сейчас не брoсает в ТСЛ ошибку, а МТ бросает. Связанос 19435
void _1ERR_NO_RESULT()
{
	double var=Ask+Ask/1000;
		Print(GetLastError());	
	int ticket=OrderSend(Symbol(), OP_SELL, 1, Bid,100, var,0);
		Print(GetLastError());	
	bool selct=OrderSelect(ticket, SELECT_BY_TICKET);
		Print(GetLastError());	
	OrderPrint();
		Print(GetLastError());	
	double opPrice=OrderOpenPrice();
		Print(GetLastError());	
	bool modify=OrderModify(ticket, opPrice, var, 0,0);
		Print(GetLastError()+"  "+modify);	
	bool selct2=OrderSelect(ticket, SELECT_BY_TICKET);
		Print(GetLastError());	
	OrderPrint();		
		Print(GetLastError());	
}

//-
void _2ERR_COMMON_ERROR()
{

}

/*В торговую функцию переданы неправильные параметры, например, неправильный символ, 
неопознанная торговая операция, отрицательное допустимое отклонение цены, 
несуществующий номер тикета и т.п. Необходимо изменить логику программы.*/
void _3ERR_INVALID_TRADE_PARAMETERS()
{
	int ticket11=OrderSend(Symbol(), OP_SELL,1,Bid,20,0,0,0,0,"str",Green);
	Print(GetLastError());
}

//4,5 у нас нет

/*Для проявления надо просто дисконекнутьь клиент когда стр запущенна в ТСЛ.
Нет связи с торговым сервером. Необходимо убедиться, что связь не нарушена (например, 
при помощи функции IsConnected) и через небольшой промежуток времени (от 5 секунд) повторить попытку.*/
void _6ERR_NO_CONNECTION()
{
	double var=Ask+Ask/1000;
	int ticket=OrderSend(Symbol(), OP_BUY, 1, Ask,100, 0,0);
	Print(GetLastError());	
	bool selct=OrderSelect(ticket, SELECT_BY_TICKET);
	Print(GetLastError());
	for(int i=0; i<100; i++)
	{
		Sleep(1000);
		double opPrice=OrderOpenPrice();
		Print(GetLastError());	
		bool modify=OrderModify(ticket, opPrice, var+i/1000, 0,0);
		Print(GetLastError()+"  "+modify);	
	}
}



//У нас нет.
void _8ERR_TOO_FREQUENT_REQUESTS()
{

}

//Надо в БО сделать статус Close.Счет заблокирован. Необходимо прекратить все попытки торговых операций.
void _64ERR_ACCOUNT_DISABLED()
{
	int ticket=OrderSend(Symbol(), OP_BUY, 1, Ask,100, 0,0);
	Print(GetLastError());	
}

//-
void _65ERR_INVALID_ACCOUNT()
{
	
}

//-
void _128ERR_TRADE_TIMEOUT()
{
	
}

/*Неправильная цена bid или ask, возможно, ненормализованная цена. Необходимо после задержки 
от 5 секунд обновить данные при помощи функции RefreshRates и повторить попытку. Если ошибка 
не исчезает, необходимо прекратить все попытки торговых операций и изменить логику программы.*/
void _129ERR_INVALID_PRICE()
{
	int ticket=OrderSend(Symbol(), OP_BUY, 1, 2.3215648854658,100, 0,0);
	Print(GetLastError());	
}

/*Слишком близкие стопы или неправильно рассчитанные или ненормализованные цены в стопах 
(или в цене открытия отложенного ордера). Попытку можно повторять только в том случае, если 
ошибка произошла из-за устаревания цены. Необходимо после задержки от 5 секунд обновить 
данные при помощи функции RefreshRates и повторить попытку. Если ошибка не исчезает, необходимо 
прекратить все попытки торговых операций и изменить логику программы.*/
void _130ERR_INVALID_STOPS()
{
	double var=Ask+Ask/1000;
	int ticket=OrderSend(Symbol(), OP_SELLLIMIT, 1, Ask,1000, var-1,0);
	Print(GetLastError());	
}

/*Неправильный объем, ошибка в грануляции объема. Необходимо прекратить все попытки торговых
 операций и изменить логику программы.*/
void _131ERR_INVALID_TRADE_VOLUME()
{
	double var=Ask+Ask/1000;
	int ticket=OrderSend(Symbol(), OP_SELLLIMIT, -1, Ask,1000, var,0);
	Print(GetLastError());	
}

//Не работает из-за бага 19462
void _132ERR_MARKET_CLOSED()
{
	int ticket=OrderSend(Symbol(), OP_BUY, 1, Ask,100, 0,0);
	Print(GetLastError());	
}

/*Надо протсо инструмент на серваке сделать Fully close. 
Торговля запрещена. Необходимо прекратить все попытки торговых операций.*/
void _133ERR_TRADE_DISABLED()
{
	int ticket=OrderSend(Symbol(), OP_BUY, 1, Ask,100, 0,0);
	Print(GetLastError());	
}

//- 		У нас выскакивает ошибка 0 и сообщение о недостатке маржи
void _134ERR_NOT_ENOUGH_MONEY()
{
	int ticket=OrderSend(Symbol(), OP_BUY, 10000, Ask,100, 0,0);
	Print(GetLastError());	
}

//-
void _135ERR_PRICE_CHANGED()
{
	
}

//- попытался сделать как в 19532, написал баг.
void _136ERR_OFF_QUOTES()
{
	
}

//Выпадает если для Sell стоит цена по Ask, а для Buy по Bid
void _138ERR_REQUOTE()
{
	double var=Ask+Ask/1000;
	Print(GetLastError());	
	int ticket=OrderSend(Symbol(), OP_SELL, 1, Ask,1000, var,0);
	Print(GetLastError());	
}

//-
void _139ERR_ORDER_LOCKED()
{
	
}

/*Разрешена только покупка. Повторять операцию SELL нельзя.
Вырудаем на серваке для инструмента рул Allow short positions.*/
void _140ERR_LONG_POSITIONS_ONLY_ALLOWED()
{
	int ticket=OrderSend(Symbol(), OP_SELL, 1, Bid,100, 0,0);
	Print(GetLastError());	
}

//141,142,143,144,145,146 у нас отсутствует

/*Для получения надо отключить на роуте тифы GTD and Day
Использование даты истечения ордера запрещено брокером. 
Операцию можно повторить только в том случае, если обнулить параметр expiration.*/
void _147ERR_TRADE_EXPIRATION_DENIED()
{
	datetime a = CurTime();
	a += 1000;
	Print(a);
	int ticket=OrderSend(Symbol(), OP_BUY, 1, Ask,100, 0,0,"",123,a);
	Print(GetLastError());		
}

//148,149,150 нет у нас.

//Функция не разрешена
void _4060ERR_FUNCTION_NOT_CONFIRMED()
{
	double var=Ask+Ask/1000;
	int ticket=OrderSend(Symbol(), OP_BUY, 1, Ask,100, 0,0);
	Print(GetLastError());	
	for(int i=0; i<100; i++)
	{
		Sleep(1000);
		bool modify=OrderModify(ticket, 0, var+i/1000, 0,0);
		Print(GetLastError()+"  "+modify);	
	}
}


void start()
{
 	switch(error)
 	{
 		case 0 : _0ERR_NO_ERR()
		case 1 : _1ERR_NO_RESULT()
		case 2 : _2ERR_COMMON_ERROR()
		case 3 :
		case 4 :
		case 5 :
		case 6 :
		case 7 :
		case 8 :
		case 9 :
		case 64 :
		case 65 :
		case 128 :
		case 129 :
		case 130 :
		case 131 :
		case 132 :
		case 133 :
		case 134 :
		case 135 :
		case 136 :
		case 137 :
		case 138 :
		case 139 :
		case 140 :
		case 141 :
		case 145 :
		case 146 :
		case 147 :
		case 148 :
		case 149 :
		case 150 :
		case 4000 :
		case 4001 :
		case 4002 :
		case 4003 :
		case 4004 :
		case 4005 :
		case 4006 :
		case 4007 :
		case 4008 :
		case 4009 :
		case 4010 :
		case 4011 :
		case 4012 :
		case 4013 :
		case 4014 :
		case 4015 :
		case 4016 :
		case 4017 :
		case 4018 :
		case 4019 :
		case 4020 :
		case 4021 :
		case 4022 :
		case 4050 :
		case 4051 :
		case 4052 :
		case 4053 :
		case 4054 :
		case 4055 :
		case 4056 :
		case 4057 :
		case 4058 :
		case 4059 :
		case 4060 :
		case 4061 :
		case 4062 :
		case 4063 :
		case 4064 :
		case 4065 :
		case 4066 :
		case 4067 :
		case 4099 :
		case 4100 :
		case 4101 :
		case 4102 :
		case 4103 :
		case 4104 :
		case 4105 :
		case 4106 :
		case 4107 :
		case 4108 :
		case 4109 :
		case 4110 :
		case 4111 :
		case 4200 :
		case 4201 : 
		case 4202 :
		case 4203 :
		case 4204 :
		case 4205 :
		case 4206 :
		case 4207 :
 	}
}
