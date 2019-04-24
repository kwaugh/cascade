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

#ifndef CASCADE_SRC_VERILOG_AST_CASE_GENERATE_ITEM_H
#define CASCADE_SRC_VERILOG_AST_CASE_GENERATE_ITEM_H

#include "src/verilog/ast/types/expression.h"
#include "src/verilog/ast/types/generate_block.h"
#include "src/verilog/ast/types/macro.h"
#include "src/verilog/ast/types/node.h"

namespace cascade {

class CaseGenerateItem : public Node {
  public:
    // Constructors:
    CaseGenerateItem();
    template <typename ExprsItr>
    CaseGenerateItem(ExprsItr exprs_begin__, ExprsItr exprs_end__, GenerateBlock* block__);
    ~CaseGenerateItem() override;

    // Node Interface:
    NODE(CaseGenerateItem)
    CaseGenerateItem* clone() const override;
    virtual std::string stringify() const override;

    // Get/Set:
    MANY_GET_SET(CaseGenerateItem, Expression, exprs)
    MAYBE_GET_SET(CaseGenerateItem, GenerateBlock, block)

  private:
    MANY_ATTR(Expression, exprs);
    MAYBE_ATTR(GenerateBlock, block);
};

std::string CaseGenerateItem::stringify() const {
    STRINGIFY_BEGIN(CaseGenerateItem);
    STRINGIFY_SUPER(Node);
    STRINGIFY_VECTOR(exprs);
    STRINGIFY_POINTER(block);
    STRINGIFY_END();
}

inline CaseGenerateItem::CaseGenerateItem() : Node(Node::Tag::case_generate_item) {
  MANY_DEFAULT_SETUP(exprs);
  MAYBE_DEFAULT_SETUP(block);
  parent_ = nullptr;
}

template <typename ExprsItr>
inline CaseGenerateItem::CaseGenerateItem(ExprsItr exprs_begin__, ExprsItr exprs_end__, GenerateBlock* block__) : CaseGenerateItem() {
  MANY_SETUP(exprs);
  MAYBE_SETUP(block);
}

inline CaseGenerateItem::~CaseGenerateItem() {
  MANY_TEARDOWN(exprs);
  MAYBE_TEARDOWN(block);
}

inline CaseGenerateItem* CaseGenerateItem::clone() const {
  auto* res = new CaseGenerateItem();
  MANY_CLONE(exprs);
  MAYBE_CLONE(block);
  return res;
}

} // namespace cascade 

#endif
