int mas[3]={1,2,3}, integer=5;
double float=5.25;
string str="test string";
int arr[2]={3,2};
int file, file1, file2,writearray,DouStrInt;

string 	filelocation="D:\\ptfile.csv",
		filelocation1="D:\\ptfile2.csv",
		filelocation2="C:\\Program Files (x86)\\MetaTrader 4\\history\\default\\USDCHF240.hst",
		writearraylocation="D:\\writearray.csv",
		DouStrIntlocation="D:\\DouStrInt.csv";
		
int init()
{
    //Открывает Файл для ввода и/или вывода. 
    //1) Комбинация FILE_CSV|FILE_WRITE. Открываем как текстовый фаил нулевой длины.Даже если до открытия в файле были данные, то они будут уничтожены.
	file= FileOpen(filelocation,FILE_CSV|FILE_WRITE,' ');
	if(file==-1)Print(GetLastError(), " - ", GetLastError());
	//2) Комбинация FILE_READ | FILE_WRITE для того что б данные дописывались в фаил 
	file1= FileOpen(filelocation1,FILE_CSV|FILE_READ|FILE_WRITE,' ');
	if(file1==-1)Print(GetLastError(), " - ", GetLastError());
	//3) Открытие истории
	file2= FileOpen(filelocation2,FILE_CSV|FILE_WRITE,' ');
	if(file2==-1)Print(GetLastError(), " - ", GetLastError());
	//4) Запись масива в бинарный фаил
	writearray= FileOpen(writearraylocation,FILE_BIN|FILE_WRITE,' ');
	if(file2==-1)Print(GetLastError(), " - ", GetLastError());
	//5) Запись double+integer+string
	DouStrInt= FileOpen(DouStrIntlocation,FILE_BIN|FILE_WRITE,' ');
	if(DouStrInt==-1)Print(GetLastError(), " - ", GetLastError());
	return(0);
}
	
int start()
{ 
	//1) Проверка для первого кейса
//	FileWrite(file,TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS ),"Bid: ",Bid,"Ask ",Ask,"Time: ","Open[1]: ",Open[1] ,"Close[1]: ",Close[1]);
	int wr1=FileWrite(file,"Bid=", Bid, "Ask=", Ask);
	if(GetLastError()!=0)Print(GetLastError());
	//Сброс на диск всех данных, оставшихся в файловом буфере ввода-вывода.
	FileFlush(file);
	if(GetLastError()!=0)Print(GetLastError());
	//Возвращает TRUE, если файловый указатель находится в конце файла, иначе возвращает FALSE.
	bool end=FileIsEnding(file);
	if(GetLastError()!=0)Print(GetLastError());
	//Возвращает TRUE, если файловый указатель находится в конце строки файла формата CSV, иначе возвращает FALSE
	bool lineend=FileIsLineEnding(file);
	if(GetLastError()!=0)Print(GetLastError());
	//-----------------------------------------------------
	return(0);
	}
	
int deinit()
{
    //1) Проверка для первого кейса
    //Закрытие файла, ранее открытого функцией FileOpen().
    FileClose(file);
    if(GetLastError()!=0)Print(GetLastError());
    //Удаление указанного файла.
//    FileDelete(filelocation); //Надоедает когда фаил постоянно удаляет
//	  if(GetLastError()!=0) Print(GetLastError());
    //-----------------------------------------------------
    //2) Проверка для вторго кейса
	bool end=FileIsEnding(file1);
	if(GetLastError()!=0)Print(GetLastError());
    if (end!=1){
        bool seek=FileSeek(file1, 0, SEEK_END);
        if(GetLastError()!=0)Print(GetLastError());
        }
    bool lineend=FileIsLineEnding(file1);
    if(GetLastError()!=0)Print("FileIsLineEnding",GetLastError());
    int write=FileWrite(file1,"Time=",TimeToStr(Time));
    if(GetLastError()!=0)Print(GetLastError());
    FileClose(file1);
    if(GetLastError()!=0)Print(GetLastError());
    //-----------------------------------------------------
    //3) Проверка открытия истории
    FileClose(file2);
    //-----------------------------------------------------
    //4) Проверка записи масива данных в файл.
    int wrarr=FileWriteArray(writearray, arr, 0, 2); // запись последних 3 элементов
    if(GetLastError()!=0 || wrarr<=0)Print(GetLastError());
    FileClose(writearray);
    //-----------------------------------------------------
    //5) Проверка запись double+integer+string
    int floatwr=FileWriteDouble(DouStrInt, float, DOUBLE_VALUE);
    if(GetLastError()!=0 || floatwr<=0)Print("FileWriteDouble ", GetLastError());
    
    bool end2=FileIsEnding(DouStrInt);
	if(GetLastError()!=0)Print(GetLastError());
    if (end2!=1){
        bool seek2=FileSeek(DouStrInt, 0, SEEK_END);
        if(GetLastError()!=0)Print(GetLastError());
        }
        
    int intwr=FileWriteInteger(DouStrInt, integer, SHORT_VALUE);
    Print(intwr);
    if(GetLastError()!=0 || intwr<=0)Print("FileWriteInteger ", GetLastError());
    
    bool end3=FileIsEnding(DouStrInt);
	if(GetLastError()!=0)Print(GetLastError());
    if (end3!=1){
        bool seek3=FileSeek(DouStrInt, 0, SEEK_END);
        if(GetLastError()!=0)Print(GetLastError());
        }
    
    int stringwr=FileWriteString(DouStrInt, str, 12);
    Print(stringwr);
    if(GetLastError()!=0 || stringwr<=0)
    	Print("FileWriteString", GetLastError());
    
    bool end4=FileIsEnding(DouStrInt);
	if(GetLastError()!=0)Print(GetLastError());
    if (end4!=1)
    {
        bool seek4=FileSeek(DouStrInt, 0, SEEK_END);
        if(GetLastError()!=0)Print(GetLastError());
    }
    
    FileClose(DouStrInt);
    return(0);
}
    