#define x 5 
#define y 7

int main() {
	short int s = 0;
	short int a = 9;
	short int b = -2;
	short int *ps;

	s = a + b;
	s = s + 1;
	ps = &s;
	(*ps)--;
	s = x + y;
	return 0;
}