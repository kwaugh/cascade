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

#ifndef CASCADE_SRC_VERILOG_AST_FOREVER_STATEMENT_H
#define CASCADE_SRC_VERILOG_AST_FOREVER_STATEMENT_H

#include "src/verilog/ast/types/loop_statement.h"
#include "src/verilog/ast/types/macro.h"
#include "src/verilog/ast/types/statement.h"

namespace cascade {

class ForeverStatement : public LoopStatement {
  public:
    // Constructors:
    explicit ForeverStatement(Statement* stmt__);
    ~ForeverStatement() override;

    // Node Interface:
    NODE(ForeverStatement)
    ForeverStatement* clone() const override;
    std::string stringify() const override;

    // Get/Set:
    PTR_GET_SET(ForeverStatement, Statement, stmt)

  private:
    PTR_ATTR(Statement, stmt);
};

inline ForeverStatement::ForeverStatement(Statement* stmt__) : LoopStatement(Node::Tag::forever_statement) {
  parent_ = nullptr;
  PTR_SETUP(stmt);
}

inline ForeverStatement::~ForeverStatement() {
  PTR_TEARDOWN(stmt);
}

inline ForeverStatement* ForeverStatement::clone() const {
  return new ForeverStatement(stmt_->clone());
}

std::string stringify() const {
    STRINGIFY_BEGIN(ForeverStatement);
    STRINGIFY_SUPER(LoopStatement);
    STRINGIFY_POINTER(stmt);
    STRINGIFY_END();
}
} // namespace cascade 

#endif
