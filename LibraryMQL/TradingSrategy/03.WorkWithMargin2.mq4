//--------------------------------------------------------------------
// openbuy.mq4 
// Предназначен для использования в качестве примера в учебнике MQL4.
//--------------------------------------------------------------- 1 --
extern int Dist_SL =300;                             // Заданный SL (pt)
extern int Dist_TP =100;                              // Заданный TP (pt)
//double Free=10000;
double Balance=10000;
int start()                                     // Спец.функция start
  {
      
   double Prots=0.01;                       	// Процент своб. ср.
   string Symb=Symbol();                        // Финанс. инструмент
//--------------------------------------------------------------- 2 --
   while(true)                                  // Цикл открытия орд.
     {
      //Информационная часть выводимая в коменте
//      double FreeMargin=AccountFreeMargin();      		// Свободн средства
//      double Equity=AccountEquity();					//Возвращает сумму собственных средств для текущего счета.
//      double Marg=AccountMargin();						//Возвращает сумму залоговых средств, используемых для поддержания открытых позиций на текущем счете.
//      double Profit=AccountProfit();					//Возвращает значение прибыли для текущего счета в базовой валюте.
      double Profit=AccountProfit();					//Возвращает значение прибыли для текущего счета в базовой валюте.
      double Marg=AccountMargin();						//Возвращает сумму залоговых средств, используемых для поддержания открытых позиций на текущем счете.
      double Equity=Balance+Profit;							//Возвращает сумму собственных средств для текущего счета.
      double FreeMargin=Equity-Marg;									// Свободн средства
      Alert("FreeMargin= ",FreeMargin,"\n","Margin= ",Marg,"\n","Equity= ",Equity,"\n", "Profit= ",Profit,"\n");
      Comment("FreeMargin= ",FreeMargin,"\n","Margin= ",Marg,"\n","Equity= ",Equity,"\n", "Profit= ",Profit,"\n");
      //--------------------------------------------------------- 2,5 --
      int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);// Мин. дистанция
      double Min_Lot=MarketInfo(Symb,MODE_MINLOT);// Мин. размер лота
      double Step   =MarketInfo(Symb,MODE_LOTSTEP);//Шаг изменен лотов
      double One_Lot=MarketInfo(Symb,MODE_MARGINREQUIRED);//Стоим.1 лота
      //--------------------------------------------------------- 3 --
      double Lot=MathFloor(FreeMargin*Prots/One_Lot/Step)*Step;// Лоты
      if (Lot < Min_Lot)                        // Если меньше допуст
        {
         Alert(" Не хватает денег на ", Min_Lot," лотов");
         break;                                 // Выход из цикла
        }
      //--------------------------------------------------------- 4 --
      double SL = Bid - Dist_SL*Point;          // Заявленная цена SL
      if (Dist_SL<Min_Dist)                     // Если меньше допуст.
        {
         SL = Bid - Min_Dist*Point;             // Заявленная цена SL
         Alert(" Увеличена дистанция SL = ",Min_Dist," pt");
        }
      //--------------------------------------------------------- 5 --
	  double TP=Ask + Dist_TP*Point;            // Заявленная цена ТР
      if (Dist_TP < Min_Dist)                   // Если меньше допуст.
        {
         TP=Ask+Min_Dist*Point;// Установим допуст.
         Alert(" Увеличена дистанция TP = ",Dist_TP," pt");
        }
      //--------------------------------------------------------- 6 --
      Alert("+++Размер покупаемого лота ",Lot,"; Сывободной маржи. ",FreeMargin);
//      Alert("Торговый приказ отправлен на сервер. Ожидание ответа..");
      int ticket=OrderSend(Symb, OP_BUY, Lot, Bid, 2, SL, TP);
      //--------------------------------------------------------- 7 --
      if (ticket>0)                             // Получилось :)
        {
         Alert ("Открыт ордер Buy ",ticket);
		 	double Profit2=AccountProfit();					//Возвращает значение прибыли для текущего счета в базовой валюте.
    	 	double Marg2=AccountMargin();						//Возвращает сумму залоговых средств, используемых для поддержания открытых позиций на текущем счете.
      	 	double Equity2=Balance+Profit;							//Возвращает сумму собственных средств для текущего счета.
      	 	double FreeMargin2=Equity-Marg;									// Свободн средства
   	     	Alert("FreeMargin= ",FreeMargin2,"\n","Margin= ",Marg2,"\n","Equity= ",Equity2,"\n", "Profit= ",Profit2,"\n", "-------------------------------------------------");      	    
         break;                                 // Выход из цикла                             //Выход из цикла
        }
//      --------------------------------------------------------- 8 --
	if (GetLastError()!=0) Print(GetLastError(),"=", GetLastErrorDescription()); 
      break;                                    // Выход из цикла
     }
//--------------------------------------------------------------- 9 --
   Alert ("Скрипт закончил работу -----------------------------");
   return;                                      // Выход из start()
  }
//-------------------------------------------------------------- 10 --



