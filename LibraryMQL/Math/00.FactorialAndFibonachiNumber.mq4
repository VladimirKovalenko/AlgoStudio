void math()
{
	int s11=45+123;
    int s12=4561-2541;
    int s13=14*86;
	int s14=4564/153;
	double fact=20;
	int n=fact;
	for(int g=0; g<10; g++)
	{
		for(int count=1; count<n; count++)
		    fact=fact*(count);
		int x=0,y=1, FiboNumber=400;
		for(int counter=0; counter<FiboNumber-2; counter++)
		{
		  	y=y;
		   	y=x+y;
		   	x=y-x;
	   	}
	}
}

int start()
{
	for(int n1=0; n1<100; n1++)
		math();
	return;
}