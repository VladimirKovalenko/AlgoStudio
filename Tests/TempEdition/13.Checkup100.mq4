int start()
{
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
  return(0);
}

