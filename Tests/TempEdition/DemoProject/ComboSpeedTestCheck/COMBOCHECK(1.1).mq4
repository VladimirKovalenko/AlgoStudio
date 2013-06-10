//Для корректного отображения времени в репортах надо делать БТ не на кастом инструментах.

/*При добавлении новых проверок есть много мест которые надо будет подправлять
1)А может быть и нет */



#include <WinUser32.mqh>
extern bool first=1, second, third;

//Присваивание переменных для статистики-----------------------
bool One_Chose=true;
int Quoute_counter=0;
double Start_time,Stop_Time,Passed_sec,QuotesPerSec,MksPerSec;	
//-------------------------------------------------------------
int file;

//Tests method-------------------------------------------------------------
void fir(){//дефаутовое количество циклов 1000
    for(int n=0; n<1; n++)
     {
	     int s1=45+123;
	     int s2=4561-2541;
	     int s3=14*86;
	     int s4=4564/153;
     	}
    return;
    }
void sec(){//дефаутовое количество циклов 10000
	for(int n=0; n<1; n++)
     {
	     int s1=45+123;
	     int s2=4561-2541;
	     int s3=14*86;
	     int s4=4564/153;
     	}
    return;
    }
void thir(){//дефаутовое количество циклов 100000(вроде)
	for(int n=0; n<1; n++)
     {
	     int s1=45+123;
	     int s2=4561-2541;
	     int s3=14*86;
	     int s4=4564/153;
     	}
    return;
    }
string separators(){
	string ModuleSeparator;
	if(first==1){ModuleSeparator=";";}
	if(second==1) ModuleSeparator=";;;";
	if(third==1) ModuleSeparator=";;;";
	return(ModuleSeparator);
	}
int init()
{	
    //Проверка на количество включённыйх чекбоксов, в случае если их больше или меньше 1, то выпадет окошко и дальше всё прсокипается.
    int sum=first+second+third;
	if(sum>1){
    	int FirstMessage=MessageBox("Вы выбрали более чем один пункт для отчёта, повторите попытку заново ", "Question", MB_OK|MB_ICONQUESTION);
    	One_Chose=false;
    	return(0);
    	}
	if(sum<1){
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
    if (first==true) fir();
    if (second==true) sec();
    if (third==true) thir();
  return(0);
}


int deinit()
{	
	//Если котировок мало или много тогда расчёты вестись не будут. ----------------------------------------------
	if(Quoute_counter<40000){
    	int answer1=MessageBox("Слишком мало квот, работа будет прервана, выберите больший тайм фрейм", "Question", MB_OK|MB_ICONQUESTION);
    	return(0);
		}
	if(Quoute_counter>100000){
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
			int WriteFileHeader=FileWrite(file, CycleNumber,"\n;FrstTest;;;;;;;;SecondTest;;;;;;;;ThirdTest;;;;;;;;\n",SecRowTemplate,SecRowTemplate,SecRowTemplate);	//Записываем хедер таблицы
			FileFlush(file);		//Сбрасываем хедер сразу в фаилб не дожитдаясь закрытия потока.
			}
		//---------------------------------------------------------------------------------------------
		//Проверка номера циклаи, ввод нового значения.
		else {
			int CurrentCounter=StrToInteger(FileReadString(file));
			if (first==1){
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
				if(first!=1){
					bool GoToEnd=FileSeek(file,-2,SEEK_END);
					}
				string time=TimeToStr(TimeCurrent());
				int WriteFileBody=FileWrite(file,separators()+CycleNumber+";"+time+";"+CalculationResult);	//Записываем строку с результатами теста
		//Запись в фаил
		if(GetLastError()!=0)Print(GetLastError());
		//Закрытие файла, ранее открытого функцией FileOpen().
	    FileClose(file);
	    if(GetLastError()!=0)Print(GetLastError());
	    
	    //Блок 
  return(0);
}


