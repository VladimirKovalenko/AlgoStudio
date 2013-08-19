int file1;
int file2;

int errorLog()
{
	int err=GetLastError();
	if(err!=0)
	{
		Print("Order did not set, error: "+ err);
	}
}

int init()
{
	file1= FileOpen("D:\\ptfile2.csv",FILE_CSV|FILE_READ|FILE_WRITE);
	errorLog();
}

int deinit(){
	bool end=FileIsEnding(file1);
	errorLog();
	if (end!=1)
	{
		bool seek=FileSeek(file1, 0, SEEK_END);
		errorLog();
	}
	int write=FileWrite(file1,"Time=",TimeToStr(Time));
	errorLog();
	FileClose(file1);
	errorLog();
}
