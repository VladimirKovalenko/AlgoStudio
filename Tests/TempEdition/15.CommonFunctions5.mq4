int start()
{
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
  return(0);
}

