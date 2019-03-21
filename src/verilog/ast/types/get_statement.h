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

#ifndef CASCADE_SRC_VERILOG_AST_GET_STATEMENT_H
#define CASCADE_SRC_VERILOG_AST_GET_STATEMENT_H

#include "src/verilog/ast/types/macro.h"
#include "src/verilog/ast/types/system_task_enable_statement.h"
#include "src/verilog/ast/types/identifier.h"

namespace cascade {

class GetStatement : public SystemTaskEnableStatement {
  public:
    // Constructors:
    explicit GetStatement(Identifier* id__, Identifier* var__);
    ~GetStatement() override;

    // Node Interface:
    NODE(GetStatement)
    GetStatement* clone() const override;

    // Get/Set:
    PTR_GET_SET(GetStatement, Identifier, id)
    PTR_GET_SET(GetStatement, Identifier, var)

  private:
    PTR_ATTR(Identifier, id);
    PTR_ATTR(Identifier, var);
};

inline GetStatement::GetStatement(Identifier* id__, Identifier* var__) : SystemTaskEnableStatement(Node::Tag::get_statement) {
  PTR_SETUP(id);
  PTR_SETUP(var);
  parent_ = nullptr;
}

inline GetStatement::~GetStatement() {
  PTR_TEARDOWN(id);
  PTR_TEARDOWN(var);
}

inline GetStatement* GetStatement::clone() const {
  return new GetStatement(id_->clone(), var_->clone());
}

} // namespace cascade 

#endif