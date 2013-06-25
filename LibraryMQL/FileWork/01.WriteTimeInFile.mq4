int file1;
int init()
{
    file1= FileOpen("D:\\ptfile2.csv",FILE_CSV|FILE_READ|FILE_WRITE);
	if(file1==-1)Print(GetLastError());
	return(0);
	}
int start()
{ 
	return(0);
	}
int deinit(){
    bool end=FileIsEnding(file1);
    Print(GetLastError(),"  ", end);
    if (end!=1){
        bool seek=FileSeek(file1, 0, SEEK_END);
        Print(GetLastError(),"  ", seek);
        }
    int write=FileWrite(file1,"Time=",TimeToStr(Time));
    	Print(GetLastError(),"  ", write);
    FileClose(file1);
    	Print(GetLastError());
    return(0);
    }
    