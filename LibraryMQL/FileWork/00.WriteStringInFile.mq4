int file;

#import <sdf.dll>;

int init()
{
	file= FileOpen("D:\\TestReport.csv",FILE_CSV|FILE_WRITE|FILE_READ,';');
  return(0);
}

int deinit()
{
	int size=FileSize(file);
	string str1=("sdgfdf;");
	int wr;
	if (size==0)wr=FileWrite(file, str1);
	
	bool seek=FileSeek(file,-3,SEEK_END);
	wr=FileWrite(file, str1);
	FileClose(file);
  return(0);
}

