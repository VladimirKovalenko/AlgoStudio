//Для корректного отображения времени в репортах надо делать БТ не на кастом инструментах.

/*При добавлении новых проверок есть много мест в которые надо будет подправлять
1) Добавить сепараторов в метод string separators()
*/



#include <WinUser32.mqh>
extern bool T01_PrimitiveMath1000, T02_PrimitiveMath10000, T03_PrimitiveMath100000,T04_PredefinedVariables1000,
			T05_TimeseriesAccess50,T06_Concatenatio100,T07_TradeFunction,T08_ConversionFunctions50,T09_DateTimeFunctions100,
			T10_GlobalVariable100,T11_AccountInformation100,T12_ArrayFunctions,T13_Checkup100,T14_ClientTerminal10000,T15_CommonFunctions5,
			T16_AllIndicators,T17_CustomIndicator50,T18_MathTrig10000,T19_AllStringFunctions,T20_AllWindowFunctions,T21_ObjectFunctions;

//Присваивание переменных для статистики-----------------------
bool One_Chose=true;
int Quoute_counter=0;
double Start_time,Stop_Time,Passed_sec,QuotesPerSec,MksPerSec;	
//-------------------------------------------------------------
int file;


//Переменные для методов проверок, от тех что лё--------------------------------------------------------------------

// Предназначен для использования в качестве примера в учебнике MQL4.
//Для 20 проверки--------------------------------------------------------------------
//#property indicator_chart_window    // Индик. рисуется в основном окне
//#property indicator_buffers 2       // Количество буферов
//#property indicator_color1 Blue     // Цвет первой линии
//#property indicator_color2 Red      // Цвет второй линии
 
double Buf_0[],Buf_1[];             // Объявление массивов (под буферы индикатора)
//--------------------------------------------------------------------
//Для 21 проверки--------------------------------------------------------------------
datetime DT1=D'2013.02.06 9:45:00';
datetime DT2=D'2013.02.06 11:00:00';
datetime DT3=D'2013.02.06 13:15:00';
double Price1=1.35450;
double Price2=1.35550;
double Price3=1.35650;
//--------------------------------------------------------------------


//Tests method-------------------------------------------------------------
void _01_PrimitiveMath1000(){
    for(int n=0; n<1000; n++)
     {
	     int s1=45+123;
	     int s2=4561-2541;
	     int s3=14*86;
	     int s4=4564/153;
     	}
    return;
    }
    
void _02_PrimitiveMath10000(){
	for(int n=0; n<10000; n++)
     {
	     int s1=45+123;
	     int s2=4561-2541;
	     int s3=14*86;
	     int s4=4564/153;
     	}
    return;
    }
    
void _03_PrimitiveMath100000(){
	for(int n=0; n<100000; n++)
     {
	     int s1=45+123;
	     int s2=4561-2541;
	     int s3=14*86;
	     int s4=4564/153;
     	}
    return;
    }
    
void _04_PredefinedVariables1000(){
	for(int i=0; i<1000; i++){
    	double s1=(Ask),s2=(Bid),s3=(Open[0]),s4=(High[0]),s5=(Low[0]),s6=(Close[0]),s7=(Time[0]),s8=(Volume[0]),s9=(Bars), s10=(Digits), s11=(Point);
		}
    return;
    }
    
void _05_TimeseriesAccess50(){
	for(int n=0; n<50; n++)
     {
	     double s1=iClose("111", 0, 0),
	     		s2=iHigh("111", 0, 0),
//	     		s3=iHighest("111", 0, 0), //Поиск по всему масиву тупит систему
	     		shift=iBarShift(Symbol(),0,D'2013.01.03 12:00'),
			    s4=iLow("111", 0, 0),
//	     		s5=iLowest("111", 0, 0),	//Поиск по всему масиву тупит систему
	     		s6=iOpen("111", 0, 0),
	     		s7=iTime("111", 0, 0),
	     		s8=iVolume("111", 0, 0),
	     		s9=iBars("111", 0);
     	}
    return;
    }    
    
void _06_Concatenatio100(){
	for(int n=0; n<100; n++)
     {
	     string s1="rr",s2="ff",s3,s4,s7;
	     s3=s1+s2;
	     s4="111"+"222";
	     string s5=(("333"+"444")+"555");
	     string s6=("!@#"+("   "+"*&^"));
	     s7=s1+s2+s3+s4+s5+s6;
     	}
    return;
    }
    
void _07_TradeFunction(){
	for(int n=0; n<1; n++)
     {
	     string symb=Symbol();
        //Устанавливаем маркет ордер(последний параметр не работает)
		int i=OrderSend(symb, OP_SELL, 1, Bid, 10, Ask+0.0005, Bid-0.0005, "I dont why it's need", 123456, 0, White);
		//Выбираем поставленный ордер для дальнейшей работы
		bool j=OrderSelect(i, SELECT_BY_TICKET);
		//Возвращает тип операции текущего выбранного ордера
		int q=OrderType();
		//Возвращает номер тикета для текущего выбранного ордера.
		int w=OrderTicket();
		//Возвращает значение цены закрытия позиции при достижении уровня убыточности (stop loss) для текущего выбранного ордера.
		double StopLoss=OrderStopLoss();
		//Возвращает значение цены закрытия позиции при достижении уровня прибыльности (take profit) для текущего выбранного ордера
		double TakeProfit=OrderTakeProfit();
		//Возвращает наименование финансового инструмента для текущего выбранного ордера.
		string Symb=OrderSymbol();
		//Возвращает значение свопа для текущего выбранного ордера.
		double swap=OrderSwap();
		//Возвращает общее количество открытых и отложенных ордеров.
		int total=OrdersTotal();
		//Возвращает количество закрытых позиций и удаленных ордеров в истории текущего счета, загруженной в клиентском терминале.
		int accTotal=OrdersHistoryTotal();
		//Возвращает значение чистой прибыли (без учёта свопов и комиссий) для выбранного ордера.
		double profit=OrderProfit();
		//Выводит данные ордера в журнал
		OrderPrint();
		//Возвращает время открытия выбранного ордера.	
		datetime OpTime=OrderOpenTime();
		//Возвращает цену открытия для выбранного ордера.
		double ClPr=OrderOpenPrice();
		//Возвращает идентификационное ("магическое") число для выбранного ордера.
		int Mag=OrderMagicNumber();
		//Возвращает количество лотов для выбранного ордера.
		double Lot=OrderLots();
		//Возвращает дату истечения для выбранного отложенного ордера.
		datetime Exp=OrderExpiration();
		//Возвращает значение рассчитанной комиссии для выбранного ордера.
		double comis=OrderCommission();
		//Возвращает комментарий для выбранного ордера.
		string comment=OrderComment();
		//Возвращает цену закрытия выбранного ордера.
		double CLPr=OrderClosePrice();
		//Закрытие позиции.
		bool Clos=OrderClose(i, 1, Ask, 10, White);
		//Возвращает время закрытия для выбранного ордера. Только закрытые ордера имеют время закрытия, не равное 0.
		datetime ClTime=OrderCloseTime();
		//Устанавливаем маркет ордер(последний параметр не работает)
		int tick=OrderSend(symb, OP_BUYLIMIT, 1, Bid-0.005, 10, Bid-0.0005, Bid+0.0005, "Wats happens?", 987564, 0, White);
		//Выбираем поставленный ордер для дальнейшей работы
		bool jtick=OrderSelect(tick, SELECT_BY_TICKET);
		//Изменяет параметры ранее открытых позиций или отложенных ордеров.
		bool ModTick=OrderModify(tick, 1, 1-0.0005, 1+0.0005, 0, Black);
		//Удаляет ранее установленный отложенный ордер.
		bool delord=OrderDelete(OrderTicket());
		//Устанавливаем маркет ордер(последний параметр не работает)
		int selli=OrderSend(symb, OP_SELL, 1, Bid, 10, 0, 0);
		//Устанавливаем маркет ордер(последний параметр не работает)
		int buyi=OrderSend(symb, OP_BUY, 1, Ask, 10, 0, 0);
		//Закрытие одной открытой позиции другой позицией, открытой по тому же самому инструменту, но в противоположном направлении.
		bool closeby=OrderCloseBy(selli,buyi);
     	}
    return;
    }    
    
void _08_ConversionFunctions50(){
	    for(int c=0; c<50;c++){
			//Преобразование кода символа в односимвольную строку.
		    for(int i=0; i<257; i++) string j=CharToStr(i);
		    //Преобразование числового значения в текстовую строку, содержащую символьное представление числа в указанном формате точности.
		    string value0=DoubleToStr(1.123456789,8);
		    string value1=DoubleToStr(123456979797,0);
		    string value2=DoubleToStr(1464646464.1234567894,7);
		    string value3=DoubleToStr(0,8);
		    //Округление числа с плавающей запятой до указанной точности.
		    double norm1=0.12315464987, norm2=12116546464, norm3=45632131.6466464646;
		    double norm11=NormalizeDouble(norm1,7), norm22=NormalizeDouble(norm2,7), norm33=NormalizeDouble(norm3,7);
		    //Преобразование строки, содержащей символьное представление числа, в число типа double (формат двойной точности с плавающей точкой).
		    double var1=StrToDouble("1.355");
		    double var2=StrToDouble("145464644.355");
		    double var3=StrToDouble("1.646546464355");
		    //Преобразование строки, содержащей символьное представление числа, в число типа int (целое).
		    int varia1=StrToInteger("123123");
		    int varia2=StrToInteger("123123.23434");
		    int varia3=StrToInteger("0");
			//Преобразование строки, содержащей время и/или дату в формате "yyyy.mm.dd [hh:mi]", в число типа datetime (количество секунд, прошедших с 01.01.1970).
			datetime dt1,dt2,dt3;
			var1=StrToTime("2003.8.12 17:35");
			var2=StrToTime("17:35");      // возврат текущей даты с указанным временем
			var3=StrToTime("2003.8.12");  // возврат даты с полуночным временем "00:00"    
			//Преобразование значения, содержащего время в секундах, прошедшее с 01.01.1970, в строку формата "yyyy.mm.dd hh:mi".
			string tts1, tts2, tts3;
			tts1=TimeToStr(135567300,TIME_DATE|TIME_SECONDS);
			tts2=TimeToStr(135565300,TIME_DATE|TIME_MINUTES);
			tts3=TimeToStr(138567300,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
			}
    return;
    } 
    
void _09_DateTimeFunctions100(){
    for(int i=0; i<100; i++){
	    //Возвращает текущий день месяца, т.е день месяца последнего известного времени сервера.
	    int day=Day();
	    //Возвращает порядковый номер дня недели (воскресенье-0,1,2,3,4,5,6) последнего известного времени сервера.
		int dayofweek=DayOfWeek();
		//Возвращает текущий день года (1-1 января,..,365(6) - 31 декабря), т.е день года последнего известного времени сервера.
		int dayofyear=DayOfYear();
	    //Возвращает текущий час (0,1,2,..23) последнего известного серверного времени на момент старта программы (в процессе выполнения программы это значение не меняется).
	    int hour=Hour();
		//Возвращает текущую минуту (0,1,2,..59) последнего известного серверного времени на момент старта программы (в процессе выполнения программы это значение не меняется).
		int minute=Minute();
	   	//Возвращает номер текущего месяца (1-Январь,2,3,4,5,6,7,8,9,10,11,12), т.е. номер месяца последнего известного времени сервера.
	   	int month=Month();
	   	//Возвращает количество секунд, прошедших с начала текущей минуты последнего известного серверного времени на момент старта программы (в процессе выполнения программы это значение не меняется).
	   	int sec=Seconds();
	   	//Возвращает последнее известное время сервера (время прихода последней котировки) в виде количества секунд, прошедших после 00:00 1 января 1970 года.
	   	int Curt=TimeCurrent();
	   	//Возвращает день месяца (1 - 31) для указанной даты.
	   	int Tday=TimeDay(D'2003.12.31');
	   	//Возвращает день недели (0-Воскресенье,1,2,3,4,5,6) для указанной даты.
	   	int weekday=TimeDayOfWeek(D'2004.11.2');
	   	//Возвращает день (1 - 1 января,..,365(6) - 31 декабря) года для указанной даты.
	   	int tdoy=TimeDayOfYear(TimeCurrent());
	   	//Возвращает час для указанного времени.
	   	int th=TimeHour(TimeCurrent());
	   	//Возвращает локальное компьютерное время в виде количества секунд, прошедших после 00:00 1 января 1970 года.
	   	datetime LocTim=TimeLocal();
	   	//Возвращает минуты для указанного времени.
	   	int m=TimeMinute(TimeCurrent());
		//Возвращает номер месяца для указанного времени (1-Январь,2,3,4,5,6,7,8,9,10,11,12).
		int MM=TimeMonth(TimeCurrent());
		//Возвращает количество секунд, прошедших с начала минуты для указанного времени.
		int seco=TimeSeconds(TimeCurrent());
		//Возвращает год для указанной даты. Возвращаемая величина может быть в диапазоне 1970-2037.
		int y=TimeYear(TimeCurrent());
		//Возвращает текущий год, т.е. год последнего известного времени сервера.
		int year=Year();
		}
    return;
    }
    
void _10_GlobalVariable100(){
	 for (int i=0; i<100; i++){
	    //Устанавливает новое значение глобальной переменной. Если переменная не существует, то система создает новую глобальную переменную. 
	    datetime gvs=GlobalVariableSet("x",50);
	//  Print(GetLastError());
		//Возвращает значение TRUE, если глобальная переменная существует, иначе возвращает FALSE.
		bool gvc=GlobalVariableCheck("x");
	//	Print(GetLastError());
		//Возвращает значение существующей глобальной переменной или 0 в случае ошибки.
		double gvg=GlobalVariableGet("x");
	//	Print(GetLastError());
		//Функция возвращает общее количество глобальных переменных.
		int gvt=GlobalVariablesTotal();
	//	Print(GetLastError());
		//Функция возвращает имя глобальной переменной по порядковому номеру в списке глобальных переменных.
		string name=GlobalVariableName(0);
	//	Print(GetLastError());
		//Устанавливает новое значение существующей глобальной переменной, если текущее значение переменной равно значению третьего параметра check_value.
		bool gvsoc=GlobalVariableSetOnCondition("x", 60, 50);
	//	Print(GetLastError());
		//Удаляет глобальную переменную. При успешном удалении функция возвращает TRUE, иначе FALSE.
		bool gvd=GlobalVariableDel("x");
	//	Print(GetLastError());
		//Удаляет глобальные переменные. Если префикс для имени не задан, то удаляются все глобальные переменные.
		int gvda=GlobalVariablesDeleteAll();
	//	Print(GetLastError());
	}
    return;
    }
    
void _11_AccountInformation100(){
	for(int i=0; i<100; i++){
		//Возвращает значение баланса активного счета (сумма денежных средств на счете).
		double AB=AccountBalance();
		//Возвращает значение кредита для активного счета.
		double AC=AccountCredit();
		//Возвращает название брокерской компании, в которой зарегистрирован текущий счет.
		string ACo=AccountCompany();
		//Возвращает наименование валюты для текущего счета.
		string ACu=AccountCurrency();
		//Возвращает сумму собственных средств для текущего счета. Расчет equity зависит от настроек торгового сервера.
		double AE=AccountEquity();
		//Возвращает значение свободных средств, разрешенных для открытия позиций на текущем счете.
		double AFM=AccountFreeMargin();
		//Возвращает размер свободных средств, которые останутся после открытия указанной позиции по текущей цене на текущем счете.
		double AFMC=AccountFreeMarginCheck(Symbol(), OP_BUY, 1);
		//Режим расчета свободных средств, разрешенных для открытия позиций на текущем счете. Режим расчета может принимать следующие значения:
		double AFMM=AccountFreeMargin();
		//Возвращает значение плеча для текущего счета.
		int AL=AccountLeverage();
		//Возвращает сумму залоговых средств, используемых для поддержания открытых позиций на текущем счете.
		double AM=AccountMargin();
		//Возвращает имя пользователя текущего счета.
		string AN=AccountName();
		//Возвращает номер текущего счета.
		int ANu=AccountNumber();
		//Возвращает значение прибыли для текущего счета в базовой валюте.
		double AP=AccountProfit();
		//Возвращает имя активного сервера.
		string AS=AccountServer();
		//Возвращает значение уровня, по которому определяется состояние Stop Out.
		int ASL=AccountStopoutLevel();
		//Возвращает режим расчета уровня Stop Out. Режим расчета может принимать следующие значения:
		int ASM=AccountStopoutMode();
		}
    return;
    }
    
void _12_ArrayFunctions(){
	for(int n=0; n<1; n++)
     {
	    	string symb=Symbol();
			int  Mas1[4]={4,5,6,8};
			double Mas2[3][4] = { 	9.3, 3.2, 2.1, 1.0, 
									10.1, 20.1, 12.3, 13.4,   
									11.2, 21.2, 22.3, 23.4 };
			string Mas3[2][2][3] ={"q", "w", "e",
									"a", "s", "d",
									
									"r", "t", "y",
									"g", "h", "j",};
			bool Mas4[5] ={1,0,1,0,1};
			int Mas5[4];
			double Mas6[][6];
			int vol[];
			double num_array[15]={4,1,6,3,9,4,1,6,3,9,4,1,6,3,9};
				
			//Сортировка числовых массивов по первому измерению. Массивы-таймсерии не могут быть отсортированы.
			int sortMas2=ArraySort(Mas2);
			//Возвращает индекс первого найденного элемента в первом измерении массива.
			int ArBs=ArrayBsearch(Mas2,13.4,0,0,MODE_DESCEND);
			//Копирует один массив в другой. 
			int ArCo=ArrayCopy(Mas5, Mas1);
			//Копирует в двухмерный массив, вида RateInfo[][6], данные баров текущего графика и возвращает количество скопированных баров
		//	int ArCR=ArrayCopyRates(Mas6, symb); //Будет переполнять потому как постоянно увеличивается
			//Копирует массив-таймсерию в пользовательский массив и возвращает количество скопированных элементов.
		//	int ArCS=ArrayCopySeries(vol,MODE_VOLUME,symb);
			//Возвращает ранг многомерного массива.
			int ArDi=ArrayDimension(Mas1);
			//	Возвращается TRUE, если массив организован как таймсерия (элементы массива индексируются от последнего к первому), иначе возвращается FALSE.
			bool Agss=ArrayGetAsSeries(Mas1);
			//Устанавливает все элементы числового массива в одну величину. Возвращает количество инициализированных элементов.
			int AI=ArrayInitialize(Mas1,5);
			//Возвращается TRUE, если проверяемый массив является массивом-таймсерией (Time[],Open[],Close[],High[],Low[] или Volume[]), иначе возвращается FALSE.
			bool AIS=ArrayIsSeries(vol);
			//Поиск элемента с максимальным значением. Функция возвращает позицию максимального элемента в массиве.
			int ARMax=ArrayMaximum(Mas1); //С хренали не работет не знаю, надо посмотреть после рекрафтинга
		//	int ARmax=ArrayMaximum(Mas1); //не правильно считает
			int maxValueIdx=ArrayMaximum(num_array);
			//Поиск элемента с минимальным значением. Функция возвращает позицию минимального элемента в массиве.
			int minValueidx=ArrayMinimum(num_array);
			//Возвращает число элементов в указанном измерении массива. Поскольку индексы начинаются с нуля, размер измерения на 1 больше, чем самый большой индекс.
			int ARr=ArrayRange(Mas3, 2);
			//Устанавливает направление индексирования в массиве.
			bool ArSeAsSer=ArraySetAsSeries(num_array,true);
			//Устанавливает новый размер в первом измерении массива
			int ArRes=ArrayResize(num_array,20);
			//Возвращает количество элементов массива.
			int ArSi=ArraySize(Mas3);
     	}
    return;
    }
    
void _13_Checkup100(){
	    int err;
		for(int i=0; i<100; i++){
			// TRUE - связь с сервером установлена, FALSE - связь с сервером отсутствует или прервана.
			bool con=IsConnected();
			err=GetLastError();
			//Возвращается TRUE, если программа работает на демонстрационном счете, в противном случае возвращает FALSE.
			bool dem=IsDemo();
			err=GetLastError();
			//Возвращает TRUE, если DLL вызов функции разрешены для эксперта, иначе возвращает FALSE.
			bool dll=IsDllsAllowed();
			err=GetLastError();
			//Возвращает TRUE, если в клиентском терминале разрешен запуск экспертов, иначе возвращает FALSE.
			bool ExpEn=IsExpertEnabled();
			err=GetLastError();
			//Возвращает TRUE, если эксперт может назвать библиотечную функцию, иначе возвращает FALSE.
			bool libAll= IsLibrariesAllowed();
			err=GetLastError();
			//Возвращается TRUE, если эксперт работает в режиме оптимизации тестирования, иначе возвращает FALSE.
			bool opt=IsOptimization();
			err=GetLastError();
			//Возвращается TRUE, если программа (эксперт или скрипт) получила команду на завершение своей работы, иначе возвращает FALSE.
			bool stop=IsStopped();
			err=GetLastError();
			//Возвращается TRUE, если эксперт работает в режиме тестирования, иначе возвращает FALSE.
			bool test=IsTesting();
			err=GetLastError();
			//Возвращается TRUE, если эксперту разрешено торговать и поток для выполнения торговых операций свободен, иначе возвращает FALSE.
			bool tral=IsTradeAllowed();
			err=GetLastError();
			//Возвращается TRUE, если поток для выполнения торговых операций занят, иначе возвращает FALSE.
			bool COntBusy=IsTradeContextBusy();
			err=GetLastError();
			//Возвращается TRUE, если эксперт тестируется в режиме визуализации, иначе возвращает FALSE.
			bool VisM=IsVisualMode();
			err=GetLastError();
			//Возвращает код причины завершения экспертов, пользовательских индикаторов и скриптов. Возвращаемые значения могут быть одним из кодов деинициализации.
			bool UnReas=UninitializeReason();
			err=GetLastError();
			}
    return;
    }
    
void _14_ClientTerminal10000(){
    for(int i=0;i<10000;i++){
	    //Возвращает наименование компании-владельца клиентского терминала.
		string q=TerminalCompany();
		//Возвращает имя клиентского терминала.
		string w=TerminalName();
		//Возвращает директорий, из которого запущен клиентский терминал.
		string у= TerminalPath();
	}
    return;
    }
    
void _15_CommonFunctions5(){
    for(int i=0; i<5; i++){
	    string symb=Symbol();
	    //Отображает диалоговое окно, содержащие пользовательские данные.
		Alert("DFGJK");
		//Функция выводит комментарий, определенный пользователем, в левый верхний угол графика.
		Comment("sddfsdfsfs");
		//Функция GetTickCount() возвращает количество миллисекунд, прошедших с момента старта системы. 
		int start=GetTickCount();
		//Возвращает различную информацию о финансовых инструментах, перечисленных в окне "Обзор рынка"
		double low		=MarketInfo(symb,MODE_LOW);
		double high 	=MarketInfo(symb,MODE_HIGH);
		double time		=MarketInfo(symb,MODE_TIME);
		double bid  	=MarketInfo(symb,MODE_BID);
		double ask  	=MarketInfo(symb,MODE_ASK);
		double point	=MarketInfo(symb,MODE_POINT);
		int    digits	=MarketInfo(symb,MODE_DIGITS);
		int    spread	=MarketInfo(symb,MODE_SPREAD);
		double stlevel	=MarketInfo(symb,MODE_STOPLEVEL);
		double lotsize	=MarketInfo(symb,MODE_LOTSIZE);
		double tickval	=MarketInfo(symb,MODE_TICKVALUE);
		double ticksize	=MarketInfo(symb,MODE_TICKSIZE);
		double swaplong	=MarketInfo(symb,MODE_SWAPLONG);
		double swapshort=MarketInfo(symb,MODE_SWAPSHORT);
		double starting	=MarketInfo(symb,MODE_STARTING);
		double expiration	=MarketInfo(symb,MODE_EXPIRATION);
		double tradeallowed	=MarketInfo(symb,MODE_TRADEALLOWED);
		double minblot		=MarketInfo(symb,MODE_MINLOT);
		double lotstep		=MarketInfo(symb,MODE_LOTSTEP);
		int    maxlot		=MarketInfo(symb,MODE_MAXLOT);
		double swaptupe		=MarketInfo(symb,MODE_SWAPTYPE);
		double profitalcmode	=MarketInfo(symb,MODE_PROFITCALCMODE);
		double margincalcmode	=MarketInfo(symb,MODE_MARGINCALCMODE);
		double marginit			=MarketInfo(symb,MODE_MARGININIT);
		double marginmaintance	=MarketInfo(symb,MODE_MARGINMAINTENANCE);
		double marginhedged		=MarketInfo(symb,MODE_MARGINHEDGED);
		double marginrequired	=MarketInfo(symb,MODE_MARGINREQUIRED);
		double freezlevel		=MarketInfo(symb,MODE_FREEZELEVEL);
	//		Print(low," ",high," ",time," ",bid," ",ask," ",point," ",digits," ",spread," ",stlevel," ",lotsize," ",tickval," ",ticksize,
	//	  		" ",swaplong," ",swapshort," ",starting," ",expiration," ",tradeallowed," ",minblot," ",lotstep," maxlot=",maxlot," ",swaptupe,
	//	  		" ",profitalcmode," ",margincalcmode," ",marginit," ",marginmaintance," ",marginhedged," ",marginrequired," ",freezlevel);
		//Функция воспроизводит звуковой файл. Файл должен быть расположен в каталоге каталог_терминала\sounds или его подкаталоге.
	//	PlaySound("update.wav"); //Очень тормозит процесс, потому пока избегаю
		//Печатает некоторое сообщение в журнал экспертов.
		Print("dfdfd");
		//Посылает файл по адресу, указанному в окне настроек на закладке "Публикация".
		bool SFTP=SendFTP("report.txt"); //Заведомо не работает.
		//Посылает электронное письмо по адресу, указанному в окне настроек на закладке "Почта".
	//	SendMail("FGHJKL:", "dfsfdfsdf"); //Cыпит в лог отчётами, отрубил
		//Посылает Push-уведомление на мобильные терминалы, чьи MetaQuotes ID указаны в окне настроек на закладке "Уведомления". 
	//	bool SN=SendNotification()  Нет такого у нас
		//Функция задерживает выполнение текущего эксперта или скрипта на определенный интервал.
		Sleep(100000);	//В АС всё равно не работает. Только для TSL
		}
    return;
    }
    
void _16_AllIndicators(){
	for(int n=0; n<1; n++)
     {
	    double q=		iAC(NULL, 0, 0);
		double w=		iAD(NULL, 0, 0);
		double e=		iAlligator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, 1);
		double r=		iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,0);
	//	double t=		iATR(NULL,0,12,0);
		double y=		iAO(NULL, 0, 2);
		double u=		iBearsPower(NULL, 0, 13,PRICE_CLOSE,0);
		double i=		iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,0);
	//	double o=		iBandsOnArray(ExtBuffer,total,2,0,0,MODE_LOWER,0);//Расчет индикатора Bollinger Bands на данных, хранящихся в массиве.
		double p=		iBullsPower(NULL, 0, 13,PRICE_CLOSE,0);
		double s=		iFractals(NULL, 0, MODE_UPPER, 3);
		double a=		iForce(NULL, 0, 13,MODE_SMA,PRICE_CLOSE,0);
	//	double d=	iEnvelopesOnArray(ExtBuffer,10,13,MODE_SMA,0,0.2,MODE_UPPER,0);//Расчет индикатора Envelopes на данных, хранящихся в массиве. 
		double f=		iEnvelopes(NULL, 0, 13,MODE_SMA,10,PRICE_CLOSE,0.2,MODE_UPPER,0);	
		double g=		iDeMarker(NULL, 0, 13, 1);
		double h=		iCustom(NULL, 0, "SampleInd",13,1,0);
	//	double j=	iCCIOnArray(ExtBuffer,total,12,0);//Расчет индикатора Commodity Channel Index на данных, хранящихся в массиве.
		double k=		iCCI(Symbol(),0,12,PRICE_TYPICAL,0);
	//	double l=	iStdDevOnArray(ExtBuffer,100,10,0,MODE_EMA,0);//Расчет индикатора Standard Deviation на данных, хранящихся в массиве
		double l=		iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0);
		double z=		iWPR(NULL,0,14,0);
		double x=		iStdDev(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,0);
		double c=		iRVI(NULL, 0, 10,MODE_MAIN,0);
	//	double v=	iRSIOnArray(ExtBuffer,1000,14,0);//Расчет индикатора Standard Deviation на данных, хранящихся в массиве
		double b=		iRSI(NULL,0,14,PRICE_CLOSE,0);
		double nn=		iSAR(NULL,0,0.02,0.2,0);
		double m=		iOBV(NULL, 0, PRICE_CLOSE, 1);
		double qq=		iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
		double ww=		iOsMA(NULL,0,12,26,9,PRICE_OPEN,1);
	//	double ee=	iMAOnArray(ExtBuffer,0,5,0,MODE_LWMA,0);//Расчет индикатора Standard Deviation на данных, хранящихся в массиве
		double rr=		iMA(NULL,0,13,8,MODE_SMMA,PRICE_MEDIAN,0);
		double tt=		iMFI(NULL,0,14,0);
	//	double yy=	iMomentumOnArray(mybuffer,100,12,0);//Расчет индикатора Momentum на данных, хранящихся в массиве.
		double uu=		iMomentum(NULL,0,12,PRICE_CLOSE,0);
		double ii=		iBWMFI(NULL, 0, 0);
		double oo=		iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, 1);
		double pp=		iGator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_UPPER, 1);
     	}
    return;
    }
    
void _17_CustomIndicator50(){
	   for(int j=0; j<50;j++){
		  int i,                           // Индекс бара
		       Counted_bars;                // Количество просчитанных баров 
		   double indicator=iMA(Symbol(),0,0,0,30,PRICE_CLOSE,0);
		//--------------------------------------------------------------------   
		   SetIndexBuffer(2,Buf_0);         // Назначение массива буферу
		   SetIndexStyle (2,DRAW_LINE,STYLE_SOLID,2);// Стиль линии
		   SetIndexBuffer(1,Buf_1);         // Назначение массива буферу
		   SetIndexStyle (1,DRAW_ARROW);	// Стиль линии
		   SetIndexArrow(0,217);			//Назначение значка для линии индикаторов, имеющей стиль DRAW_ARROW.
		//--------------------------------------------------------------------
			IndicatorBuffers(3);			//Распределяет память для буферов, используемых для вычислений пользовательского индикатора.2 дополнительных буфера, используемых для расчета.
			IndicatorDigits(7);				//Установка формата точности (количество знаков после десятичной точки) для визуализации значений индикатора. 
			IndicatorShortName("0_o");		//Установка "короткого" имени пользовательского индикатора для отображения в подокне индикатора и в окне DataWindow.
			SetIndexDrawBegin(0, indicator);
			SetIndexEmptyValue(1,0.0);		//Устанавливает значение пустой величины для линии индикатора. Не проверил, отбивало.
			SetIndexLabel(0,"HJK");			//Установка имени линии индикатора для отображения информации в окне DataWindow и всплывающей подсказке
			SetIndexLabel(1,"Tenkan");		//Установка имени линии индикатора для отображения информации в окне DataWindow и всплывающей подсказке
			SetIndexShift(0, 0);			//Установка смещения линии индикатора относительно начала графика.
		//	void SetLevelStyle(	int draw_style, int line_width, color clr=CLR_NONE) не использую пока
		//	void SetLevelValue(	int level, double value)тоже пока не юзаем
		//--------------------------------------------------------------------
		   Counted_bars=IndicatorCounted(); // Количество просчитанных баров. Функция возвращает количество баров, не измененных после последнего вызова индикатора.
		   i=Bars-Counted_bars-1;           // Индекс первого непосчитанного
		   while(i>=0)                      // Цикл по непосчитанным барам
		     {
		      Buf_0[i]=Close[i];             // Значение 0 буфера на i-ом баре
		      Buf_1[i]=Close[i]-1;
		      i--;                          // Расчёт индекса следующего бара
		     }
		     }
		//--------------------------------------------------------------------
    return;
    }
   
//Тут должна была быть проверка FileFunction но её нет так как там недо юзать все три метода АС.

//Раскоментить как сделают фикс 
void _18_MathTrig10000(){		
	for(int i=0; i<1000;i++){
		double q=10.123, w=-21.456, arc=0.5;
		double  abs=MathAbs(w);			//Функция возвращает абсолютное значение (значение по модулю) переданного ей числа
		double arccos=MathArccos(arc);	//Функция возвращает значение арккосинуса x в диапазоне 0 к ? в радианах. Если x меньше -1 или больше 1, функция возвращает NaN (неопределенное значение).
		double arcsin=MathArcsin(arc);	//Функция возвращает арксинус x в диапазоне от -?/2 до ?/2 радианов. Если x-, меньше -1 или больше 1, функция возвращает NaN (неопределенное значение).
		double arctan=MathArctan(arc);	//Функция возвращает арктангенс x. Если x равен 0, функция возвращает 0. MathArctan возвращает значение в диапазоне от -?/2 до ?/2 радианов.
		double ceil=MathCeil(q);		//Функция возвращает числовое значение, представляющее наименьшее целое число, которое больше или равно x.
		double cos=MathCos(arc);		//Функция возвращает косинус угла.
		double exp=MathExp(w);			//Функция возвращает значение числа e в степени d. При переполнении функция возвращает INF (бесконечность), в случае потери порядка MathExp возвращает 0.
	//	double floor=MathFloor(w);		//Функция возвращает числовое значение, представляющее наибольшее целое число, которое меньше или равно x.
		double log=MathLog(w);			//Функции возвращают натуральный логарифм x в случае успеха. Если x отрицателен, функция возвращает NaN (неопределенное значение). Если x равен 0, функция возвращает INF (бесконечность) .
		double max=MathMax(q,w);		//Функция возвращает максимальное из двух числовых значений.
		double min=MathMin(q,w);		//Функция возвращает минимальное из двух числовых значений.
		double mod=MathMod(w,q);		//Функция возвращает вещественный остаток от деления двух чисел.
		double pow=MathPow(w,q);		//Функция возвращает значение основания, возведенного в указанную степень.
		MathSrand(w);					//Функция устанавливает начальное состояние для генерации ряда псевдослучайных целых чисел. 
		int rand=MathRand();			//Функция возвращает псевдослучайное целое число в дипазоне от 0 до 32767. 
		double round=MathRound(w);		//Функция возвращает значение, округленное до ближайшего целого числа указанного числового значения.
		double sin=MathSin(arc);		//Функция возвращает синус указанного угла.
		double sqrt=MathSqrt(w);		//Функция возвращает квадратный корень x. Если x отрицателен, MathSqrt возвращает NaN (неопределенное значение).
		double tan=MathTan(q);			//Функция возвращает тангенс x. Если x больше или равен 263 или меньше или равен -263, то происходит потеря значения и функция возвращает неопределенное число.
		}
    return;
    }
    
void _19_AllStringFunctions(){
	 for(int n=0; n<100; n++)
	 	{
		//  Формирует строку из переданных параметров и возвращает её. Параметры могут иметь любой тип. Количество параметров не может превышать 64.  
		string SC1=StringConcatenate(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64);
		
		//  Поиск подстроки. Возвращает номер позиции в строке, с которой начинается искомая подстрока, либо -1, если подстрока не найдена.  
		string text="Быстрая коричневая собака перепрыгивает ленивую лисицу";
		int SF1=StringFind(text,"собака перепрыгивает",0);
		
		//Возвращает значение символа, расположенного в указанной позиции строки.
		int SGC=StringGetChar("Test3",3);
		
		//Возвращает число символов в строке.
		int SL=StringLen("123456789");
		
		//Возвращает копию строки с измененным значением символа в указанной позиции.
		string SSC1=StringSetChar("В этом предлИжении нет ошибок",12,'о');
		
		//Извлекает подстроку из текстовой строки, начинающейся c указанной позиции.
		string SS=StringSubstr("Быстрая коричневая собака перепрыгивает ленивую лисицу",8,10);
		
		//Функция урезает символы перевода каретки, пробелы и символы табуляции в левой части строки.
		string S1="   Test1   ";
		string STL1=StringTrimLeft(S1);
		
		//Функция урезает символы перевода каретки, пробелы и символы табуляции в правой части строки
		string S2="   Test2   ";
		string STL2=StringTrimRight(S2);
		}
    return;
    }

//Раскоментить функцию которая сейчас не работает.
void _20_AllWindowFunctions(){	
	for(int n=0; n<1; n++)
     {
		//Возвращает значение числа минут периода для текущего графика.
		int P=Period();
		//Возвращает значение числа минут периода для текущего графика.
		bool RR=RefreshRates();
		//Возвращает текстовую строку с именем текущего финансового инструмента.
		string S=Symbol(); 
		//Функция возвращает количество баров, помещающихся в окно текущего графика.
		int WBPC=WindowBarsPerChart();
		//Возвращает имя выполняющегося эксперта, скрипта, пользовательского индикатора или библиотеки, в зависимости от того, из какой MQL4-программы вызвана данная функция.
		string WEN=WindowExpertName();
		//Возвращает номер подокна графика, содержащего индикатор с указанным именем
		int WF1=WindowFind("iMACD");
		//Функция возвращает номер первого видимого бара в окне текущего графика.
		int WVB=WindowFirstVisibleBar();
		//Возвращает системный дескриптор окна
		int WH=WindowHandle("EURUSD",1);
		//Возвращает TRUE, если подокно графика видимо, иначе возвращает FALSE. Подокно графика может быть скрыто из-за свойств видимости помещенного в него индикатора.
		bool WIV=WindowIsVisible(1);
		//Возвращает максимальное значение вертикальной шкалы указанного подокна текущего графика
		double WPMax=WindowPriceMax(0);
		//Возвращает минимальное значение вертикальной шкалы указанного подокна текущего графика
		double WPMin=WindowPriceMin(0);
		//Принудительно перерисовывает текущий график. Обычно применяется после изменения свойств объектов.
//		WindowRedraw();
		//Сохраняет изображение текущего графика в файле формата GIF.
		bool WSS=WindowScreenShot("Screen",500,500,6);
		//Возвращает количество окон индикаторов на графике, включая главное окно графика.
		int WT=WindowsTotal();
     	}
    return;
    }

void _21_ObjectFunctions(){	
	for(int n=0; n<1; n++)
     {
		// Создание всех объектов   
		//--------------------------------------------- 
		bool OBJ_VLINE1=ObjectCreate("OBJ_VLINE1",OBJ_VLINE,0,DT1,1.3);
		bool OBJ_HLINE1=ObjectCreate("OBJ_HLINE1",OBJ_HLINE,0,D'2013.02.06 11:00:00',Price1);
		bool OBJ_TREND1=ObjectCreate("OBJ_TREND1",OBJ_TREND,0,DT1,Price1,DT2,Price2);
		bool OBJ_TRENDBYANGLE1=ObjectCreate("OBJ_TRENDBYANGLE1",OBJ_TRENDBYANGLE,0,DT1,Price1,DT2,Price2);
		bool OBJ_REGRESSION1=ObjectCreate("OBJ_REGRESSION1",OBJ_REGRESSION,0,DT1,Price1,DT2,Price2);
		bool OBJ_CHANNEL1=ObjectCreate("OBJ_CHANNEL1",OBJ_CHANNEL,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_STDDEVCHANNEL1=ObjectCreate("OBJ_STDDEVCHANNEL1",OBJ_STDDEVCHANNEL,0,DT1,Price1,DT2,Price2);
		bool OBJ_GANNLINE1=ObjectCreate("OBJ_GANNLINE1",OBJ_GANNLINE,0,DT1,Price1,DT2,Price2);
		bool OBJ_GANNFAN1=ObjectCreate("OBJ_GANNFAN1",OBJ_GANNFAN,0,DT1,Price1,DT2,Price2);
		bool OBJ_GANNGRID1=ObjectCreate("OBJ_GANNGRID1",OBJ_GANNGRID,0,DT1,Price1,DT2,Price2);
		bool OBJ_FIBO1=ObjectCreate("OBJ_FIBO1",OBJ_FIBO,0,DT1,Price1,DT2,Price2);
		bool OBJ_FIBOTIMES1=ObjectCreate("OBJ_FIBOTIMES1",OBJ_FIBOTIMES,0,DT1,Price1,DT2,Price2);
		bool OBJ_FIBOFAN1=ObjectCreate("OBJ_FIBOFAN1",OBJ_FIBOFAN,0,DT1,Price1,DT2,Price2);
		bool OBJ_EXPANSION1=ObjectCreate("OBJ_EXPANSION1",OBJ_EXPANSION,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_FIBOCHANNEL1=ObjectCreate("OBJ_FIBOCHANNEL1",OBJ_FIBOCHANNEL,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_RECTANGLE1=ObjectCreate("OBJ_RECTANGLE1",OBJ_RECTANGLE,0,DT1,Price1,DT2,Price2);
		bool OBJ_TRIANGLE1=ObjectCreate("OBJ_TRIANGLE1",OBJ_TRIANGLE,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_ELLIPSE1=ObjectCreate("OBJ_ELLIPSE1",OBJ_ELLIPSE,0,DT1,Price1,DT2,Price2);
		bool OBJ_PITCHFORK1=ObjectCreate("OBJ_PITCHFORK1",OBJ_PITCHFORK,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_CYCLES1=ObjectCreate("OBJ_CYCLES1",OBJ_CYCLES,0,DT1,Price1,DT2,Price2);
		bool OBJ_TEXT1=ObjectCreate("OBJ_TEXT1",OBJ_TEXT,0,DT1,Price1);
		bool OBJ_ARROW1=ObjectCreate("OBJ_ARROW1",OBJ_ARROW,0,DT1,Price1);
		bool OBJ_LABEL1=ObjectCreate("OBJ_LABEL1",OBJ_LABEL,0,DT1,Price1);
		//--------------------------------------------- 
		
		
		//ObjectDescription для объектов типа OBJ_TEXT и OBJ_LABEL
		//--------------------------------------------- 
		string OD1=ObjectDescription("OBJ_TEXT1");
		string OD2=ObjectDescription("OBJ_LABEL1");
		//--------------------------------------------- 
		
		
		//Поиск объекта с указанным именем.
		//--------------------------------------------- 
		bool OF=ObjectFind("OBJ_VLINE1");
		//--------------------------------------------- 
		
		
		//Возвращаем значение указанного свойства объекта.
		//--------------------------------------------- 
		datetime OG1=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_TIME1);
		double OG2=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_PRICE2);
		color OG3=ObjectGet("OBJ_VLINE1",OBJPROP_COLOR);
		double OG4=ObjectGet("OBJ_VLINE1",OBJPROP_STYLE);
		double OG5=ObjectGet("OBJ_VLINE1",OBJPROP_WIDTH);
		int OG6=ObjectGet("OBJ_ARROW1",OBJPROP_ARROWCODE);
		int OG7=ObjectGet("OBJ_ARROW1",OBJPROP_TIMEFRAMES);
		bool OG8=ObjectGet("OBJ_FIBOARC1",OBJPROP_ELLIPSE);
		int OG9=ObjectGet("OBJ_LABEL1",OBJPROP_FONTSIZE);
		int OG10=ObjectGet("OBJ_LABEL1",OBJPROP_CORNER);
		int OG11=ObjectGet("OBJ_LABEL1",OBJPROP_XDISTANCE);
		int OG12=ObjectGet("OBJ_LABEL1",OBJPROP_YDISTANCE);
		bool OG13=ObjectGet("OBJ_TREND1",OBJPROP_BACK);
		bool OG14=ObjectGet("OBJ_TREND1",OBJPROP_RAY);
		double OG15=ObjectGet("OBJ_TREND1",OBJPROP_SCALE);
		double OG16=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_FIBOLEVELS);
		color OG17=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELCOLOR);
		double OG18=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELSTYLE);
		double OG19=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELWIDTH);
		double OG20=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_FIRSTLEVEL+3);
		bool OG21=ObjectGet("OBJ_TRENDBYANGLE1",OBJPROP_ANGLE);
		bool OG22=ObjectGet("OBJ_STDDEVCHANNEL1",OBJPROP_DEVIATION);
		//--------------------------------------------- 
		
		
		//Функции Set/Get ObjectFiboDescription
		//--------------------------------------------- 
		bool OSFD=ObjectSetFiboDescription("OBJ_FIBOFAN1",2,"BVB");			//присваиваем новое описание уровню объекта Фибоначчи
		string OGFD=ObjectGetFiboDescription("OBJ_FIBOFAN1",2);				//Функция возвращает описание уровня объекта Фибоначчи.
		//--------------------------------------------- 
		
		//Функции  ObjectShiftByValue
		//--------------------------------------------- 
		int OGSBV=ObjectGetShiftByValue("OBJ_TREND1",Price1);				//Функция вычисляет и возвращает номер бара (смещение относительно текущего бара) для указанной цены.
		double OGVBS=ObjectGetValueByShift("OBJ_TREND1",2);					//Функция вычисляет и возвращает значение цены для указанного бара (смещение относительно текущего бара).
		//--------------------------------------------- 
		
		//Меняем одну из координат
		//--------------------------------------------- 
		bool OM1=ObjectMove("OBJ_FIBOCHANNEL1", 0,DT1+600,(Price1+30*Point));
		//--------------------------------------------- 
		
		//Устанавливаем новое значение
		//--------------------------------------------- 
		bool OS1=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_TIME1,DT1+600);
		bool OS2=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_PRICE2, (Price1+20*Point));
		bool OS3=ObjectSet("OBJ_VLINE1",OBJPROP_COLOR,447);
		bool OS4=ObjectSet("OBJ_VLINE1",OBJPROP_STYLE,2);
		bool OS5=ObjectSet("OBJ_VLINE1",OBJPROP_WIDTH,5);
		bool OS6=ObjectSet("OBJ_ARROW1",OBJPROP_ARROWCODE,138);
		bool OS7=ObjectSet("OBJ_ARROW1",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M30);
		bool OS8=ObjectSet("OBJ_FIBOARC1",OBJPROP_ELLIPSE,1);
		bool OS9=ObjectSet("OBJ_LABEL1",OBJPROP_FONTSIZE,15);
		bool OS10=ObjectSet("OBJ_LABEL1",OBJPROP_CORNER,1);
		bool OS11=ObjectSet("OBJ_LABEL1",OBJPROP_XDISTANCE,135);
		bool OS12=ObjectSet("OBJ_LABEL1",OBJPROP_YDISTANCE,235);
		bool OS13=ObjectSet("OBJ_TREND1",OBJPROP_BACK,1);
		bool OS14=ObjectSet("OBJ_TREND1",OBJPROP_RAY,1);
		bool OS15=ObjectSet("OBJ_TREND1",OBJPROP_SCALE,2);
		bool OS16=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_FIBOLEVELS,16);
		bool OS17=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELCOLOR,447);
		bool OS18=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELSTYLE,STYLE_DASHDOTDOT);
		bool OS19=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELWIDTH,5);
		bool OS20=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_FIRSTLEVEL+3,0.0268);
		bool OS21=ObjectSet("OBJ_TRENDBYANGLE1",OBJPROP_ANGLE,30);
		bool OS22=ObjectSet("OBJ_STDDEVCHANNEL1",OBJPROP_DEVIATION,5);
		bool OS23=ObjectSetText("OBJ_TEXT1","Проверка",17,"Times New Roman", Green);
		//--------------------------------------------- 
		
		//Возвращает общее число объектов указанного типа на графике.
		//--------------------------------------------- 
		int OT=ObjectsTotal();
		//--------------------------------------------- 
		
		//Возвращаем имя и тип объктов
		//--------------------------------------------- 
		for(int j=0;j<25;j++)
		{
		string ObjN=ObjectName(j);
		int ObjT=ObjectType(ObjN);
		}
		//--------------------------------------------- 
		
		
		//Удаление
		//--------------------------------------------- 
		bool ODel=ObjectDelete("OBJ_HLINE1");
		
		int ObDelA=ObjectsDeleteAll();
		//--------------------------------------------- 
     	}
    return;
    }

//Сепараторы для длоков
string separators(){
	string ModuleSeparator;
	if(T01_PrimitiveMath1000==1){ModuleSeparator=";";}
	else ModuleSeparator=";;;";
	return(ModuleSeparator);
	}
	
	
int init()
{	
    //Проверка на количество включённыйх чекбоксов, в случае если их больше или меньше 1, то выпадет окошко и дальше всё прсокипается.
    int ChackBoxSum=T01_PrimitiveMath1000+ T02_PrimitiveMath10000+ T03_PrimitiveMath100000+T04_PredefinedVariables1000+
					T05_TimeseriesAccess50+T06_Concatenatio100+T07_TradeFunction+T08_ConversionFunctions50+T09_DateTimeFunctions100+
					T10_GlobalVariable100+T11_AccountInformation100+T12_ArrayFunctions+T13_Checkup100+T14_ClientTerminal10000+T15_CommonFunctions5+
					T16_AllIndicators+T17_CustomIndicator50+T18_MathTrig10000+T19_AllStringFunctions+T20_AllWindowFunctions+T21_ObjectFunctions;
	if(ChackBoxSum>1){
    	int FirstMessage=MessageBox("Вы выбрали более чем один пункт для отчёта, повторите попытку заново ", "Question", MB_OK|MB_ICONQUESTION);	
    	One_Chose=false;
    	return(0);
    	}
	if(ChackBoxSum<1){
    	int SecondMessage=MessageBox("Вы не выбрали не одного чекбокса, повторите попытку заново ", "Question", MB_OK|MB_ICONQUESTION);
    	One_Chose=false;
    	return(0);
    	}
    	
    //открытие файла
   	file= FileOpen("D:\\report.csv",FILE_CSV|FILE_WRITE|FILE_READ,';');
	if(file==-1)Print(GetLastError());
	Start_time =GetTickCount();		//время начала БТ
  return(0);
}


int start()
{
    Quoute_counter++;
    if (One_Chose==false) return(0);	//следствие проверки в ините
    if (T01_PrimitiveMath1000==true) _01_PrimitiveMath1000();
    if (T02_PrimitiveMath10000==true) _02_PrimitiveMath10000();
    if (T03_PrimitiveMath100000==true) _03_PrimitiveMath100000();
    if (T04_PredefinedVariables1000==true) _04_PredefinedVariables1000();
    if (T05_TimeseriesAccess50==true) _05_TimeseriesAccess50();
    if (T06_Concatenatio100==true) _06_Concatenatio100();
    if (T07_TradeFunction==true) _07_TradeFunction();
    if (T08_ConversionFunctions50==true) _08_ConversionFunctions50();
    if (T09_DateTimeFunctions100==true) _09_DateTimeFunctions100();
    if (T10_GlobalVariable100==true) _10_GlobalVariable100();
    if (T11_AccountInformation100==true) _11_AccountInformation100();
    if (T12_ArrayFunctions==true) _12_ArrayFunctions();
    if (T13_Checkup100==true) _13_Checkup100();
    if (T14_ClientTerminal10000==true) _14_ClientTerminal10000();
    if (T15_CommonFunctions5==true) _15_CommonFunctions5();
    if (T16_AllIndicators==true) _16_AllIndicators();
    if (T17_CustomIndicator50==true) _17_CustomIndicator50();
    if (T18_MathTrig10000==true) _18_MathTrig10000();
    if (T19_AllStringFunctions==true) _19_AllStringFunctions();
    if (T20_AllWindowFunctions==true) _20_AllWindowFunctions();
    if (T21_ObjectFunctions==true) _21_ObjectFunctions();
  return(0);
}


int deinit()
{	
	//Если котировок мало или много тогда расчёты вестись не будут. ----------------------------------------------
	if(Quoute_counter<40000){
    	int answer1=MessageBox("Слишком мало квот, работа будет прервана, выберите меньший тайм фрейм или больший ренж", "Question", MB_OK|MB_ICONQUESTION);	
    	return(0);
		}
	if(Quoute_counter>10000000){		//Вернуть на 100000 по окончании теста
		int answer2=MessageBox("Слишком много квот, работа будет прервана, выберите больший тайм фрейм", "Question", MB_OK|MB_ICONQUESTION);	
    	return(0);
		}
		
	//-------------------------------------------------------------------------------------------
    //Блок расчёта статистических данных--------------------------------------------------------
	Stop_Time= GetTickCount();		//Время окончания БТ
	Passed_sec =(Stop_Time-Start_time )/1000; 		//Время которое работала стратегия (делим на 1000 потому что в милисекундах, получаем в секундах)
	QuotesPerSec=NormalizeDouble((Quoute_counter)/Passed_sec,0);//Квот в секунду.
	MksPerSec=Passed_sec*1000000/Quoute_counter;				//Количество микросекунд потраченных на 1 квоту
	Print ("Quote/sec: ",QuotesPerSec,"   #Quotes: ",Quoute_counter,"   mks/1K Quotes: ",MksPerSec,"   testing Time: ",Passed_sec); //Принтую для проверки, потом надо удалить
	string CalculationResult=(QuotesPerSec+";"+Quoute_counter+";"+MksPerSec+";"+Passed_sec);		//Принтуемый результат
	//---------------------------------------------------------------------------------------------
	
		//Работа с файлами----------------------------------------------------------------------------------------
		
		//Для начала проверим есть ли в файле уже записи.Если нет то пишем хедер
		int SizeFile=FileSize(file);
		int CycleNumber;		//ВЫношу глобально 
		if (SizeFile==0){	//Если размер файла 0 то создаём хедер
			CycleNumber=1;			//Индекс для первого цикла проверок
			string SecRowTemplate=("N;Date/Time;Quote/sec;#Quotes;mks/1K Quotes;testing Time;;");
			int WriteFileHeader=FileWrite(file, CycleNumber,"\n;T01_PrimitiveMath1000;;;;;;;;T02_PrimitiveMath10000;;;;;;;;T03_PrimitiveMath100000;;;;;;;;",
			"T04_PredefinedVariables1000;;;;;;;;T05_TimeseriesAccess50;;;;;;;;T06_Concatenatio100;;;;;;;;T07_TradeFunction;;;;;;;;T08_ConversionFunctions50;;;;;;;;",
			"T09_DateTimeFunctions100;;;;;;;;T10_GlobalVariable100;;;;;;;;T11_AccountInformation100;;;;;;;;T12_ArrayFunctions;;;;;;;;T13_Checkup100;;;;;;;;T14_ClientTerminal10000",
			"T14_ClientTerminal10000;;;;;;;;T14_ClientTerminal10000;;;;;;;;T15_CommonFunctions5;;;;;;;;T16_AllIndicators;;;;;;;;T17_CustomIndicator50;;;;;;;;",
			"T18_MathTrig10000;;;;;;;;T19_AllStringFunctions;;;;;;;;T20_AllWindowFunctions;;;;;;;;T21_ObjectFunctions\n",SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,
			SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,
			SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate,SecRowTemplate);	//Записываем хедер таблицы
			FileFlush(file);		//Сбрасываем хедер сразу в фаилб не дожитдаясь закрытия потока.
			}
				
			
		//---------------------------------------------------------------------------------------------
		//Проверка номера цикла, ввод нового значения.
		else {
			int CurrentCounter=StrToInteger(FileReadString(file));
			if (T01_PrimitiveMath1000==1){
				CycleNumber=CurrentCounter+1;
				bool SeekToStart=FileSeek(file, 0, SEEK_SET);	//Бросаю курсор в начало файла для перезаписи каунтера. Иначе он писался последовательно и перезатерал значения после него
				int WriteFileCounter=FileWrite(file,CycleNumber);
				bool SeekToEnd=FileSeek(file, 0, SEEK_END);
				FileFlush(file);
				}
			else CycleNumber=CurrentCounter;
			}
		//---------------------------------------------------------------------------------------------
				//Перебросим курсор на следующую строку после хедеров и пишем первые данные.
				if(T01_PrimitiveMath1000!=1){
					bool GoToEnd=FileSeek(file,-2,SEEK_END);
					}
				string time=TimeToStr(TimeCurrent());	//Возвращает текущее время
				int WriteFileBody=FileWrite(file,separators()+CycleNumber+";"+time+";"+CalculationResult);	//Записываем строку с результатами теста
		//Запись в фаил
		if(GetLastError()!=0)Print(GetLastError());
		//Закрытие файла, ранее открытого функцией FileOpen().
	    FileClose(file);
	    if(GetLastError()!=0)Print(GetLastError());
	    
	    //Блок 
  return(0);
}


