double Balance=10000;							//начальный баланс
int i=0;										//счётчик сделок
static bool Disable_Expert;
int start()                                     // Спец.функция start
  {
   if(Disable_Expert) return(0);	
   string Symb=Symbol();                        // Финанс. инструмент
   while(true)                                  // Цикл открытия орд.
     {
         //-----Определение начальных переменных-----------------------------------------------------------
      double Profit=AccountProfit();					//Возвращает значение прибыли для текущего счета в базовой валюте.
      double Marg=AccountMargin();						//Возвращает сумму залоговых средств, используемых для поддержания открытых позиций на текущем счете.
      double Equity=Balance+Profit;						//Возвращает сумму собственных средств для текущего счета.
      double FreeMargin=Equity-Marg;					// Свободн средства
      double FreeMargin2=AccountFreeMargin();			// Свободн средства
      double Equity2=AccountEquity();					//Возвращает сумму собственных средств для текущего счета.
      double Lot_Size=MarketInfo(Symb,MODE_LOTSIZE); 	//Определение размера одного лота
      double One_Lot=MarketInfo(Symb,MODE_MARGINMAINTENANCE); 		//Стоим.1 лота
      int Lot=10;										//Размер лота
      double F;											//Маржа после следующей сделки
      int ticket;										//Номер сделки
      	//-------------------------------------------------------------------------------------------------
      	//-----Информационное сообщение по текущему статусу------------------------------------------------
      Alert("FreeMargin= ",FreeMargin,"   ",FreeMargin2,"\n","Margin= ",Marg,"\n","Equity= ",Equity,
      						"   ",Equity2,"\n","Profit= ",Profit,"\n");
      //-------------------------------------------------------------------------------------------------
      //-------Начало расчёта лота ----------------------------------------------------------------------
//      if(i<2){											//Начало условия для ограничения колчества сделаок
			//-----Область предсказывания-----------------------------------------------------------
	        double NextPL=(Bid-Ask)*Lot*Lot_Size;				//Расчёт ПЛ для следующей сделки
//	        F=FreeMargin-Lot*One_Lot+NextPL+Profit;				//Маржа после следующей сделки
			F=Balance+Profit-(Balance-FreeMargin)-Lot*One_Lot+NextPL;
	        Alert("Размер покупаемого лота ",Lot,"; Свободных средств было ",FreeMargin,
	        				"; Свободных средств после сделки ",F);
	      	ticket=OrderSend(Symb, OP_BUY, Lot, Bid, 2, 0, 0);	//Создание позиции
//      	i++;										
//      	}
      //Конец расчёта лота
      if (ticket>0)                             // Получилось :)
        {
         double Free=F;
			double Profit2=AccountProfit();					//Возвращает значение прибыли для текущего счета в базовой валюте.
    		double Marg2=AccountMargin();						//Возвращает сумму залоговых средств, используемых для поддержания открытых позиций на текущем счете.
      		double Equity3=Balance+Profit2;							//Возвращает сумму собственных средств для текущего счета.
      		double FreeMargin3=Equity3-Marg2;									// Свободн средства 
   	        Alert("Free= ", Free, "\n","FreeMargin= ",FreeMargin3,"\n","Margin= ",Marg2,"\n","Equity= ",Equity3,"\n", "Profit= ",Profit2,"\n", "-------------------------------------------------");      	    
//   	        if(FreeMargin2<(10+Lot*One_Lot))Disable_Expert = true;			//Проверка на окончание торговли	
         break;                                 // Выход из цикла
        }
        break;
    }
   return;                                      // Выход из start()
  }



