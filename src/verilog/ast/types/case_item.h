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

#ifndef CASCADE_SRC_VERILOG_AST_CASE_ITEM_H
#define CASCADE_SRC_VERILOG_AST_CASE_ITEM_H

#include "src/verilog/ast/types/expression.h"
#include "src/verilog/ast/types/macro.h"
#include "src/verilog/ast/types/node.h"
#include "src/verilog/ast/types/statement.h"

namespace cascade {

class CaseItem : public Node {
  public:
    // Constructors:
    explicit CaseItem(Statement* stmt__);
    template<typename ExprsItr>
    CaseItem(ExprsItr exprs_begin__, ExprsItr exprs_end__, Statement* stmt__);
    ~CaseItem() override;

    // Node Interface:
    NODE(CaseItem)
    CaseItem* clone() const override;
    virtual std::string stringify() const override;

    // Get/Set:
    MANY_GET_SET(CaseItem, Expression, exprs)
    PTR_GET_SET(CaseItem, Statement, stmt)

  private:
    MANY_ATTR(Expression, exprs);
    PTR_ATTR(Statement, stmt);
};

inline std::string CaseItem::stringify() const {
    STRINGIFY_BEGIN(CaseItem);
    STRINGIFY_SUPER(Node);
    STRINGIFY_VECTOR(exprs);
    STRINGIFY_POINTER(stmt);
    STRINGIFY_END();
}

inline CaseItem::CaseItem(Statement* stmt__) : Node(Node::Tag::case_item) {
  MANY_DEFAULT_SETUP(exprs);
  PTR_SETUP(stmt);
  parent_ = nullptr;
}

template <typename ExprsItr>
inline CaseItem::CaseItem(ExprsItr exprs_begin__, ExprsItr exprs_end__, Statement* stmt__) : CaseItem(stmt__) {
  MANY_SETUP(exprs);
}

inline CaseItem::~CaseItem() {
  MANY_TEARDOWN(exprs);
  PTR_TEARDOWN(stmt);
}

inline CaseItem* CaseItem::clone() const {
  auto* res = new CaseItem(stmt_->clone());
  MANY_CLONE(exprs);
  return res;
}

} // namespace cascade 

#endif
