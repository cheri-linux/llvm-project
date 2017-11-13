// RUN: %cheri_cc1 -fsyntax-only %s -target-abi purecap -verify
void *a(long b)
{
	return (void*)b; // expected-warning {{cast from provenance-free integer type to pointer type will give pointer that can not be dereferenced.}} expected-note {{insert cast to intptr_t to silence this warning}}
}
void *a_fixed(long b)
{
	return (void*)(__intcap_t)b;
}
void *c(__intcap_t b)
{
	return (void*)b;
}
