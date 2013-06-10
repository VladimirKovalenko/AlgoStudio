int start()
{
    for (int i=0; i<100; i++){
    //”станавливает новое значение глобальной переменной. ≈сли переменна€ не существует, то система создает новую глобальную переменную. 
    datetime gvs=GlobalVariableSet("x",50);
//  Print(GetLastError());
	//¬озвращает значение TRUE, если глобальна€ переменна€ существует, иначе возвращает FALSE.
	bool gvc=GlobalVariableCheck("x");
//	Print(GetLastError());
	//¬озвращает значение существующей глобальной переменной или 0 в случае ошибки.
	double gvg=GlobalVariableGet("x");
//	Print(GetLastError());
	//‘ункци€ возвращает общее количество глобальных переменных.
	int gvt=GlobalVariablesTotal();
//	Print(GetLastError());
	//‘ункци€ возвращает им€ глобальной переменной по пор€дковому номеру в списке глобальных переменных.
	string name=GlobalVariableName(0);
//	Print(GetLastError());
	//”станавливает новое значение существующей глобальной переменной, если текущее значение переменной равно значению третьего параметра check_value.
	bool gvsoc=GlobalVariableSetOnCondition("x", 60, 50);
//	Print(GetLastError());
	//”дал€ет глобальную переменную. ѕри успешном удалении функци€ возвращает TRUE, иначе FALSE.
	bool gvd=GlobalVariableDel("x");
//	Print(GetLastError());
	//”дал€ет глобальные переменные. ≈сли префикс дл€ имени не задан, то удал€ютс€ все глобальные переменные.
	int gvda=GlobalVariablesDeleteAll();
//	Print(GetLastError());
}
  return(0);
}

;