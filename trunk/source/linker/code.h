#ifndef _CODE_H_
#define _CODE_H_

#include "datatypes.h"
#include "module.h"

extern void InitTCode();
extern void LoadCode(int fd, struct Module_st* CMData);
extern void WriteCode(int fd);
extern void WriteCodeSize(int fd);
extern void LoadCodeSize(int fd, struct Module_st* CMData);

extern CodeInd MergeSubSequence(CodeInd a, CodeInd b,Byte n);
extern CodeInd MergeDefs(CodeInd a, CodeInd b);

extern int TidySwitchOnReg(CodeInd* pyounger);

extern void MakeCallName(CodeInd from, int arity, ConstInd to);
extern void MakeCall(CodeInd from, int arity, CodeInd to);

#endif
