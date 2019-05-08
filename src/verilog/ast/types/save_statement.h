// Copyright 2017-2019 VMware, Inc.
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
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
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

#ifndef CASCADE_SRC_VERILOG_AST_SAVE_STATEMENT_H
#define CASCADE_SRC_VERILOG_AST_SAVE_STATEMENT_H

#include "src/verilog/ast/types/macro.h"
#include "src/verilog/ast/types/string.h"
#include "src/verilog/ast/types/system_task_enable_statement.h"

namespace cascade {

class SaveStatement : public SystemTaskEnableStatement {
  public:
    // Constructors:
    explicit SaveStatement(String* arg__);
    ~SaveStatement() override;

    // Node Interface:
    NODE(SaveStatement)
    SaveStatement* clone() const override;
    virtual std::string stringify() const override;

    // Get/Set:
    PTR_GET_SET(SaveStatement, String, arg)

  private:
    PTR_ATTR(String, arg);
};

inline SaveStatement::SaveStatement(String* arg__) : SystemTaskEnableStatement(Node::Tag::save_statement) {
  PTR_SETUP(arg);
  parent_ = nullptr;
}

inline SaveStatement::~SaveStatement() {
  PTR_TEARDOWN(arg);
}

inline SaveStatement* SaveStatement::clone() const {
  return new SaveStatement(arg_->clone());
}

inline std::string SaveStatement::stringify() const {
  return "";
  /* STRINGIFY_BEGIN(SaveStatement); */
  /* STRINGIFY_SUPER(SystemTaskEnableStatement); */
  /* STRINGIFY_POINTER(arg); */
  /* STRINGIFY_END(); */
}
} // namespace cascade 

#endif
