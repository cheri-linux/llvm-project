# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=btver2 -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=BTVER2 %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=znver1 -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=ZNVER1 %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=sandybridge -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=SANDYBRIDGE %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=ivybridge -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=IVYBRIDGE %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=haswell -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=HASWELL %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=broadwell -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=BROADWELL %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=knl -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=KNL %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=skylake -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=SKX %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=skylake-avx512 -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=SKX-AVX512 %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=slm -resource-pressure=false -instruction-info=false < %s | FileCheck --check-prefix=ALL --check-prefix=SLM %s

add %edi, %eax

# ALL:              Iterations:        100
# ALL-NEXT:         Instructions:      100
# ALL-NEXT:         Total Cycles:      103
# ALL-NEXT:         Total uOps:        100

# BROADWELL:        Dispatch Width:    4
# BROADWELL-NEXT:   uOps Per Cycle:    0.97
# BROADWELL-NEXT:   IPC:               0.97
# BROADWELL-NEXT:   Block RThroughput: 0.3

# BTVER2:           Dispatch Width:    2
# BTVER2-NEXT:      uOps Per Cycle:    0.97
# BTVER2-NEXT:      IPC:               0.97
# BTVER2-NEXT:      Block RThroughput: 0.5

# HASWELL:          Dispatch Width:    4
# HASWELL-NEXT:     uOps Per Cycle:    0.97
# HASWELL-NEXT:     IPC:               0.97
# HASWELL-NEXT:     Block RThroughput: 0.3

# IVYBRIDGE:        Dispatch Width:    4
# IVYBRIDGE-NEXT:   uOps Per Cycle:    0.97
# IVYBRIDGE-NEXT:   IPC:               0.97
# IVYBRIDGE-NEXT:   Block RThroughput: 0.3

# KNL:              Dispatch Width:    4
# KNL-NEXT:         uOps Per Cycle:    0.97
# KNL-NEXT:         IPC:               0.97
# KNL-NEXT:         Block RThroughput: 0.3

# SANDYBRIDGE:      Dispatch Width:    4
# SANDYBRIDGE-NEXT: uOps Per Cycle:    0.97
# SANDYBRIDGE-NEXT: IPC:               0.97
# SANDYBRIDGE-NEXT: Block RThroughput: 0.3

# SKX:              Dispatch Width:    6
# SKX-NEXT:         uOps Per Cycle:    0.97
# SKX-NEXT:         IPC:               0.97
# SKX-NEXT:         Block RThroughput: 0.3

# SKX-AVX512:       Dispatch Width:    6
# SKX-AVX512-NEXT:  uOps Per Cycle:    0.97
# SKX-AVX512-NEXT:  IPC:               0.97
# SKX-AVX512-NEXT:  Block RThroughput: 0.3

# SLM:              Dispatch Width:    2
# SLM-NEXT:         uOps Per Cycle:    0.97
# SLM-NEXT:         IPC:               0.97
# SLM-NEXT:         Block RThroughput: 0.5

# ZNVER1:           Dispatch Width:    4
# ZNVER1-NEXT:      uOps Per Cycle:    0.97
# ZNVER1-NEXT:      IPC:               0.97
# ZNVER1-NEXT:      Block RThroughput: 0.3
