int calculator(int a, int b,char op)
{
	int ans;
	switch(op)
	{
		case '+':
		{
			ans = a+b;
			break;
		}
		case '-':
		{
			ans = a-b;
			break;
		}
	}
	return ans;	 	
}
