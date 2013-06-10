int start()
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
  return(0);
}

//void temp(){
//    //Использовать в случае опасности
//    //		1)Обьявление одномерного массива.
//	int Mas1[5];
//	Print(Mas1);
//	//2)Обьявление двумерного массива. 
//	double Mas2[5][5];
//	Print(Mas2);
//	//3)Обьявление трёхмерного массива. 
//	double Mas3[2][5][5];
//	Print(Mas3);
//
////    //1) Запускать с тайм фреймом день. Показывает бар с каким временем относится к какому дню и дате.
//	datetime daytimes[];		//Определение масива в который заносятся времнные данные 
//	int  shift=10,dayshift;		// Зачем шифт=10 ещё не понял, 
//	// Все Time[] серии времени отсортировано в направлении убывания
//	int g0=ArrayCopySeries(daytimes,MODE_TIME,Symbol(),PERIOD_D1); //выдаёт чсило скопированных эллементов.
//	datetime g1=Time[shift];
//	datetime g2=daytimes[0];
//	if(Time[shift]>=daytimes[0]) dayshift=0;
//	else
//  		{
//   		dayshift=ArrayBsearch(daytimes,Time[shift],WHOLE_ARRAY,0,MODE_DESCEND);
//   		if(Period()<PERIOD_D1) dayshift++;
//  		}
//	Print(TimeToStr(Time[shift])," corresponds to ",dayshift," day bar opened at ",TimeToStr(daytimes[dayshift]));
//    return(0);
//    }
