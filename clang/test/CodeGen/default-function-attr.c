// RUN: %clang_cc1 -default-function-attr foo=bar -emit-llvm %s -o - | FileCheck %s

// CHECK: define void @foo() #[[X:[0-9]+]]
void foo() {}

// CHECK: attributes #[[X]] = {{.*}} "foo"="bar"
