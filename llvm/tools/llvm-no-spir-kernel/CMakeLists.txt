set(LLVM_LINK_COMPONENTS
  Core
  Demangle
  IRReader
  Support
  )

add_llvm_tool(llvm-no-spir-kernel
  llvm-no-spir-kernel.cpp

  DEPENDS
  intrinsics_gen
  )
