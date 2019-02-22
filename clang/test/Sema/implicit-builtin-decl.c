// RUN: %clang_cc1 -fsyntax-only -verify %s
// RUN: not %clang_cc1 -fsyntax-only -ast-dump %s | FileCheck %s

void f() {
  int *ptr = malloc(sizeof(int) * 10); // expected-warning{{implicitly declaring library function 'malloc' with type}} \
  // expected-note{{include the header <stdlib.h> or explicitly provide a declaration for 'malloc'}} \
  // expected-note{{'malloc' is a builtin with type 'void *}}
}

void *alloca(__SIZE_TYPE__); // redeclaration okay

int *calloc(__SIZE_TYPE__, __SIZE_TYPE__); // expected-warning{{incompatible redeclaration of library function 'calloc'}} \
                    // expected-note{{'calloc' is a builtin with type 'void *}}


void g(int malloc) { // okay: these aren't functions
  int calloc = 1;
}

void h() {
  int malloc(int); // expected-warning{{incompatible redeclaration of library function 'malloc'}}
  int strcpy(int); // expected-warning{{incompatible redeclaration of library function 'strcpy'}} \
  // expected-note{{'strcpy' is a builtin with type 'char *(char *, const char *)'}}
}

void f2() {
  fprintf(0, "foo"); // expected-warning{{declaration of built-in function 'fprintf' requires inclusion of the header <stdio.h>}} \
   expected-warning {{implicit declaration of function 'fprintf' is invalid in C99}}
}

// PR2892
void __builtin_object_size(); // expected-error{{conflicting types}} \
// expected-note{{'__builtin_object_size' is a builtin with type}}

int a[10];

int f0() {
  return __builtin_object_size(&a); // expected-error {{too few arguments to function}}
}

void * realloc(void *p, int size) { // expected-warning{{incompatible redeclaration of library function 'realloc'}} \
// expected-note{{'realloc' is a builtin with type 'void *(void *,}}
  return p;
}

// PR3855
void snprintf(); // expected-warning{{incompatible redeclaration of library function 'snprintf'}} \
    // expected-note{{'snprintf' is a builtin}}

int
main(int argc, char *argv[])
{
  snprintf();
}

void snprintf() { }

// PR8316
void longjmp(); // expected-warning{{declaration of built-in function 'longjmp' requires inclusion of the header <setjmp.h>}}

extern float fmaxf(float, float);

struct __jmp_buf_tag {};
void sigsetjmp(struct __jmp_buf_tag[1], int); // expected-warning{{declaration of built-in function 'sigsetjmp' requires inclusion of the header <setjmp.h>}}

// CHECK:     FunctionDecl {{.*}} <line:[[@LINE-2]]:1, col:44> col:6 sigsetjmp '
// CHECK-NOT: FunctionDecl
// CHECK:     ReturnsTwiceAttr {{.*}} <{{.*}}> Implicit

int pthread_create(); // expected-warning{{declaration of built-in function 'pthread_create' requires inclusion of the header <pthread.h>}}
