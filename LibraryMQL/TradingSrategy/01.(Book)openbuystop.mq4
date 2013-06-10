//--------------------------------------------------------------- 1 --
int start()                                     // Спец.функция start
  {
   int Dist_SL =10;                             // Заданный SL (pt)
   int Dist_TP =3;                              // Заданный TP (pt)
   double Prots=0.35;                           // Процент своб. ср.
   string Symb=Symbol();                        // Финанс. инструмент
   double Win_Price=WindowPriceOnDropped();     // Здесь брошен скрипт
   Alert("Мышкой задана цена Price = ",Win_Price);// Задано мышей
//--------------------------------------------------------------- 2 --
   while(true)                                  // Цикл открытия орд.
     {
      int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);// Мин. дистанция
      double Min_Lot=MarketInfo(Symb,MODE_MINLOT);// Мин. стоим. лотов
      double Free   =AccountFreeMargin();       // Свободн средства
      double One_Lot=MarketInfo(Symb,MODE_MARGINREQUIRED);//Стоим.лота
      double Lot=MathFloor(Free*Prots/One_Lot/Min_Lot)*Min_Lot;// Лоты
      //--------------------------------------------------------- 3 --
      double Price=Win_Price;                   // Цена задана мышей
      if (NormalizeDouble(Price,Digits)<        // Если меньше допуст.
         NormalizeDouble(Ask+Min_Dist*Point,Digits))
        {                                       // Только для BuyStop!
         Price=Ask+Min_Dist*Point;              // Ближе нельзя
         Alert("Изменена заявленная цена: Price = ",Price);
        }
      //--------------------------------------------------------- 4 --
      double SL=Price - Dist_SL*Point;          // Заявленная цена SL
      if (Dist_SL<Min_Dist)                     // Если меньше допуст.
        {
         SL=Price - Min_Dist*Point;             // Заявленная цена SL
         Alert(" Увеличена дистанция SL = ",Min_Dist," pt");
        }
      //--------------------------------------------------------- 5 --
      double TP=Price + Dist_TP*Point;          // Заявленная цена ТР
      if (Dist_TP<Min_Dist)                     // Если меньше допуст.
        {
         TP=Price + Min_Dist*Point;             // Заявленная цена TP
         Alert(" Увеличена дистанция TP = ",Min_Dist," pt");
        }
      //--------------------------------------------------------- 6 --
      Alert("Торговый приказ отправлен на сервер. Ожидание ответа..");
      int ticket=OrderSend(Symb, OP_BUYSTOP, Lot, Price, 0, SL, TP);
      //--------------------------------------------------------- 7 --
      if (ticket>0)                             // Получилось :)
        {
         Alert ("Установлен ордер BuyStop ",ticket);
         break;                                 // Выход из цикла
        }
      //--------------------------------------------------------- 8 --
      int Error=GetLastError();                 // Не получилось :(
      switch(Error)                             // Преодолимые ошибки
        {
         case 129:Alert("Неправильная цена. Пробуем ещё раз..");
            RefreshRates();                     // Обновим данные
            continue;                           // На след. итерацию
         case 135:Alert("Цена изменилась. Пробуем ещё раз..");
            RefreshRates();                     // Обновим данные
            continue;                           // На след. итерацию
         case 146:Alert("Подсистема торговли занята. Пробуем ещё..");
            Sleep(500);                         // Простое решение
            RefreshRates();                     // Обновим данные
            continue;                           // На след. итерацию
        }
      switch(Error)                             // Критические ошибки
        {
         case 2 : Alert("Общая ошибка.");
            break;                              // Выход из switch
         case 5 : Alert("Старая версия клиентского терминала.");
            break;                              // Выход из switch
         case 64: Alert("Счет заблокирован.");
            break;                              // Выход из switch
         case 133:Alert("Торговля запрещена");
            break;                              // Выход из switch
         default: Alert("Возникла ошибка ",Error);// Другие варианты   
        }
      break;                                    // Выход из цикла
     }
//--------------------------------------------------------------- 9 --
   Alert ("Скрипт закончил работу -----------------------------");
   return;                                      // Выход из start()
  }
//-------------------------------------------------------------- 10 --