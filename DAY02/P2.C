#define x 5 
#define y 7

short int d = 0;

void inter(short int* px, short int* py);



int main() {
 short int s = 0;
 short int a = 9;
 short int b = -2;
 short int *ps;

 inter(&a, &b);

 s = a + b;
 s = s + 1;
 ps = &s;
 (*ps)--;
 s = x + y;
     d++;
    
 return 0;
}

void inter(short int* px, short int* py) {
    short int aux;
    aux = *px;
    *px = *py;
    *py = aux;
}