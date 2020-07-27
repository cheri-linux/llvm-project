// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature
// RUN: %cheri_purecap_cc1 -o - -emit-llvm  %s
// RUN: %cheri_purecap_cc1 -o - -emit-llvm  %s | FileCheck %s
// RUN: %clang_cc1 -triple x86_64 -o - -emit-llvm  %s | FileCheck %s --check-prefix NOCHERI
// This code was previously crashing in qmetaobjectbuilder.cpp due to an incorrect
// cap->int conversion assertion. Check that we generate the same code as x86 and don't assert:

namespace QtPrivate {
struct QMetaTypeInterface;
}

class QMetaType {
public:
  QMetaType(int type);

private:
  QtPrivate::QMetaTypeInterface *d_ptr = nullptr;
};

// CHECK-LABEL: define {{[^@]+}}@_Z4testPPN9QtPrivate18QMetaTypeInterfaceEi
// CHECK-SAME: (%"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)* [[TYPES:%.*]], i32 signext [[METATYPE:%.*]]) addrspace(200) #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPES_ADDR:%.*]] = alloca %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)*, align 16, addrspace(200)
// CHECK-NEXT:    [[METATYPE_ADDR:%.*]] = alloca i32, align 4, addrspace(200)
// CHECK-NEXT:    [[MT:%.*]] = alloca [[CLASS_QMETATYPE:%.*]], align 16, addrspace(200)
// CHECK-NEXT:    store %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)* [[TYPES]], %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)* addrspace(200)* [[TYPES_ADDR]], align 16
// CHECK-NEXT:    store i32 [[METATYPE]], i32 addrspace(200)* [[METATYPE_ADDR]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32 addrspace(200)* [[METATYPE_ADDR]], align 4
// CHECK-NEXT:    call void @_ZN9QMetaTypeC1Ei(%class.QMetaType addrspace(200)* [[MT]], i32 signext [[TMP0]])
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast [[CLASS_QMETATYPE]] addrspace(200)* [[MT]] to %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)*
// CHECK-NEXT:    [[TMP2:%.*]] = load %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)*, %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)* [[TMP1]], align 16
// CHECK-NEXT:    [[TMP3:%.*]] = load %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)*, %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)* addrspace(200)* [[TYPES_ADDR]], align 16
// CHECK-NEXT:    store %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* [[TMP2]], %"struct.QtPrivate::QMetaTypeInterface" addrspace(200)* addrspace(200)* [[TMP3]], align 16
// CHECK-NEXT:    ret void
//
// NOCHERI-LABEL: define {{[^@]+}}@_Z4testPPN9QtPrivate18QMetaTypeInterfaceEi
// NOCHERI-SAME: (%"struct.QtPrivate::QMetaTypeInterface"** [[TYPES:%.*]], i32 [[METATYPE:%.*]]) #0
// NOCHERI-NEXT:  entry:
// NOCHERI-NEXT:    [[TYPES_ADDR:%.*]] = alloca %"struct.QtPrivate::QMetaTypeInterface"**, align 8
// NOCHERI-NEXT:    [[METATYPE_ADDR:%.*]] = alloca i32, align 4
// NOCHERI-NEXT:    [[MT:%.*]] = alloca [[CLASS_QMETATYPE:%.*]], align 8
// NOCHERI-NEXT:    store %"struct.QtPrivate::QMetaTypeInterface"** [[TYPES]], %"struct.QtPrivate::QMetaTypeInterface"*** [[TYPES_ADDR]], align 8
// NOCHERI-NEXT:    store i32 [[METATYPE]], i32* [[METATYPE_ADDR]], align 4
// NOCHERI-NEXT:    [[TMP0:%.*]] = load i32, i32* [[METATYPE_ADDR]], align 4
// NOCHERI-NEXT:    call void @_ZN9QMetaTypeC1Ei(%class.QMetaType* [[MT]], i32 [[TMP0]])
// NOCHERI-NEXT:    [[TMP1:%.*]] = bitcast %class.QMetaType* [[MT]] to %"struct.QtPrivate::QMetaTypeInterface"**
// NOCHERI-NEXT:    [[TMP2:%.*]] = load %"struct.QtPrivate::QMetaTypeInterface"*, %"struct.QtPrivate::QMetaTypeInterface"** [[TMP1]], align 8
// NOCHERI-NEXT:    [[TMP3:%.*]] = load %"struct.QtPrivate::QMetaTypeInterface"**, %"struct.QtPrivate::QMetaTypeInterface"*** [[TYPES_ADDR]], align 8
// NOCHERI-NEXT:    store %"struct.QtPrivate::QMetaTypeInterface"* [[TMP2]], %"struct.QtPrivate::QMetaTypeInterface"** [[TMP3]], align 8
// NOCHERI-NEXT:    ret void
//
void test(QtPrivate::QMetaTypeInterface **types, int metatype) {
  QMetaType mt(metatype);
  // This reinterprets QMetaType -> QtPrivate::QMetaTypeInterface *
  // Not sure why they used this cast instead of a friend declaration but it is permitted
  *types = reinterpret_cast<QtPrivate::QMetaTypeInterface *&>(mt);
}

// CHECK-LABEL: define {{[^@]+}}@_Z5test2v() addrspace(200) #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[FOO:%.*]] = alloca i32, align 4, addrspace(200)
// CHECK-NEXT:    [[BAR:%.*]] = alloca i32, align 4, addrspace(200)
// CHECK-NEXT:    store i32 1, i32 addrspace(200)* [[FOO]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 addrspace(200)* [[FOO]] to i8 addrspace(200)*
// CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8 addrspace(200)* [[TMP0]], align 4
// CHECK-NEXT:    [[CONV:%.*]] = sext i8 [[TMP1]] to i32
// CHECK-NEXT:    store i32 [[CONV]], i32 addrspace(200)* [[BAR]], align 4
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32 addrspace(200)* [[BAR]], align 4
// CHECK-NEXT:    ret i32 [[TMP2]]
//
// NOCHERI-LABEL: define {{[^@]+}}@_Z5test2v() #0
// NOCHERI-NEXT:  entry:
// NOCHERI-NEXT:    [[FOO:%.*]] = alloca i32, align 4
// NOCHERI-NEXT:    [[BAR:%.*]] = alloca i32, align 4
// NOCHERI-NEXT:    store i32 1, i32* [[FOO]], align 4
// NOCHERI-NEXT:    [[TMP0:%.*]] = bitcast i32* [[FOO]] to i8*
// NOCHERI-NEXT:    [[TMP1:%.*]] = load i8, i8* [[TMP0]], align 4
// NOCHERI-NEXT:    [[CONV:%.*]] = sext i8 [[TMP1]] to i32
// NOCHERI-NEXT:    store i32 [[CONV]], i32* [[BAR]], align 4
// NOCHERI-NEXT:    [[TMP2:%.*]] = load i32, i32* [[BAR]], align 4
// NOCHERI-NEXT:    ret i32 [[TMP2]]
//
int test2() {
  int foo = 1;
  // This previously (incorrectly) triggered a cap->non-cap conversion assertion
  int bar{(char &)foo};
  return bar;
}

int global_foo;
int global_bar{(char &)global_foo};

// Manual checks for the global var until https://reviews.llvm.org/D83004 lands
// UTC_ARGS: --disable
// CHECK-LABEL: define internal void @__cxx_global_var_init() addrspace(200) #2 {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    %0 = load i8, i8 addrspace(200)* bitcast (i32 addrspace(200)* @global_foo to i8 addrspace(200)*), align 4
// CHECK-NEXT:    %conv = sext i8 %0 to i32
// CHECK-NEXT:    store i32 %conv, i32 addrspace(200)* @global_bar, align 4
// CHECK-NEXT:    ret void
// CHECK-NEXT:  }
//
// CHECK-LABEL: define internal void @_GLOBAL__sub_I_lvaluebitcast_init.cpp() addrspace(200) #2 {
// CHECK-NEXT: entry:
// CHECK-NEXT:   call void @__cxx_global_var_init()
// CHECK-NEXT:   ret void
// CHECK-NEXT: }

// NOCHERI-LABEL: define internal void @__cxx_global_var_init()
// NOCHERI-NEXT:  entry:
// NOCHERI-NEXT:    %0 = load i8, i8* bitcast (i32* @global_foo to i8*), align 4
// NOCHERI-NEXT:    %conv = sext i8 %0 to i32
// NOCHERI-NEXT:    store i32 %conv, i32* @global_bar, align 4
// NOCHERI-NEXT:    ret void
// NOCHERI-NEXT:  }
//
// NOCHERI-LABEL: define internal void @_GLOBAL__sub_I_lvaluebitcast_init.cpp()
// NOCHERI-NEXT: entry:
// NOCHERI-NEXT:   call void @__cxx_global_var_init()
// NOCHERI-NEXT:   ret void
// NOCHERI-NEXT: }

// UTC_ARGS: --enable
