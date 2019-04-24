// SPDX-License-Identifier: BSD-2-Clause
//
// The BSD-2 license (the License) set forth below applies to all parts of the
// Cascade project.  You may not use this file except in compliance with the
// License.
//
// BSD-2 License
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


// This file is intended to be used for building the string representation for
// the AST that is used for adding cache entries for the AST. These are then
// used to determine if the structure of the AST has changed, in which case the
// program should be recompiled.
// These macros manage the underlying ostringstream that is created in
// STRINGIFY_BEGIN to encourage the programmer to use these macros exclusively
// instead of managing his/her own state.

#ifndef CASCADE_SRC_VERILOG_AST_STRINGIFY_H
#define CASCADE_SRC_VERILOG_AST_STRINGIFY_H

#include <sstream>
#include <string>
#include <typeinfo>
#include "src/verilog/ast/types/macro.h"

#define STRINGIFY_BEGIN(type) \
    std::ostringstream ss; \
    ss << "{" << typeid(type).name() << ",";

#define STRINGIFY_END() \
    ss << "}"; \
    return ss.str();

#define STRINGIFY_BASE_VAL(field) \
    ss << "VAL{" << typeid(PRIVATE(field)).name() << "," << PRIVATE(field) << "},";

#define STRINGIFY_VAL(field) \
    ss << "VAL" << PRIVATE(field).stringify() << ",";

#define STRINGIFY_SUPER(super) \
    ss << "SUPER" << super::stringify() << ",";

#define STRINGIFY_POINTER(pointer) \
    ss << "POINTER" << PRIVATE(pointer)->stringify() << ",";

#define STRINGIFY_TOKEN(tok) \
    ss << "TOKEN" << Tokenize::unmap(PRIVATE(tok)) << ",";

#define STRINGIFY_VECTOR(v) \
    for (const auto& it : PRIVATE(v)) { \
        ss << it->stringify(); \
    }

#endif
