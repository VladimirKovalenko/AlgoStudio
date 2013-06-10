//---------------------------------------------------
// Project: Untitled15
// Language: MQL4
// Type: Strategy
// Author: 
// Company: 
// Copyright: 
// Created: 12.11.2012
//---------------------------------------------------

int init()
{

  return(0);
}

int deinit()
{

  return(0);
}

int start()
{
	//1)Обьявление одномерного массива.
//	int Mas1[10];
//	Print(Mas1);
	//2)Обьявление двумерного массива. 
//	double Mas2[10][10];
//	Print(Mas2);
	//3)Обьявление трёхмерного массива. 
//	double Mas3[5][15][25];
//	Print(Mas3);

//    //1) Запускать с тайм фреймом день. Показывает бар с каким временем относится к какому дню и дате.
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
  return(0);
}

