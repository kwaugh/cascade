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

#ifndef CASCADE_SRC_VERILOG_AST_RANGE_EXPRESSION_H
#define CASCADE_SRC_VERILOG_AST_RANGE_EXPRESSION_H

#include <sstream>
#include "src/verilog/ast/types/expression.h"
#include "src/verilog/ast/types/macro.h"

namespace cascade {

class RangeExpression : public Expression {
  public:
    // Supporting Concepts:
    enum class Type : uint8_t {
      CONSTANT = 0,
      PLUS,
      MINUS
    };

    // Constructors:
    RangeExpression(size_t i__, size_t j__ = 0);
    RangeExpression(Expression* upper__, Type type__, Expression* lower__);
    ~RangeExpression() override;

    // Node Interface:
    NODE(RangeExpression)
    RangeExpression* clone() const override;
    virtual std::string stringify() const override;

    // Get/Set:
    PTR_GET_SET(RangeExpression, Expression, upper)
    VAL_GET_SET(RangeExpression, Type, type)
    PTR_GET_SET(RangeExpression, Expression, lower)

  private:
    PTR_ATTR(Expression, upper);
    VAL_ATTR(Type, type);
    PTR_ATTR(Expression, lower);
};

inline std::string RangeExpression::stringify() const {
  STRINGIFY_BEGIN(RangeExpression);
  STRINGIFY_SUPER(Expression);
  STRINGIFY_POINTER(upper);
  STRINGIFY_BASE_VAL((uint8_t) type);
  STRINGIFY_POINTER(lower);
  STRINGIFY_END();
}

inline RangeExpression::RangeExpression(size_t i__, size_t j__) : Expression(Node::Tag::range_expression) {
  std::stringstream ssu;
  ssu << (i__-1);
  std::stringstream ssl;
  ssl << j__;

  upper_ = new Number(ssu.str(), Number::Format::UNBASED, 32, false);
  type_ = RangeExpression::Type::CONSTANT;
  lower_ = new Number(ssl.str(), Number::Format::UNBASED, 32, false);
}

inline RangeExpression::RangeExpression(Expression* upper__, Type type__, Expression* lower__) : Expression(Node::Tag::range_expression) {
  parent_ = nullptr;
  PTR_SETUP(upper);
  VAL_SETUP(type);
  PTR_SETUP(lower);
}

inline RangeExpression::~RangeExpression() {
  PTR_TEARDOWN(upper);
  VAL_TEARDOWN(type);
  PTR_TEARDOWN(lower);
}

inline RangeExpression* RangeExpression::clone() const {
  return new RangeExpression(upper_->clone(), type_, lower_->clone());
}

} // namespace cascade 

#endif
