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

#ifndef CASCADE_SRC_VERILOG_AST_DECLARATION_H
#define CASCADE_SRC_VERILOG_AST_DECLARATION_H

#include "src/base/container/vector.h"
#include "src/verilog/ast/types/attributes.h"
#include "src/verilog/ast/types/expression.h"
#include "src/verilog/ast/types/identifier.h"
#include "src/verilog/ast/types/macro.h"
#include "src/verilog/ast/types/module_item.h"

namespace cascade {

class Declaration : public ModuleItem {
  public:
    // Constructors:
    Declaration(Node::Tag tag);
    ~Declaration() override;

    // Node Interface:
    Declaration* clone() const override = 0;
    virtual std::string stringify() const override;
    void accept(Visitor* v) const override = 0;
    void accept(Editor* e) override = 0;
    Declaration* accept(Builder* b) const override = 0;
    Declaration* accept(Rewriter* r) override = 0;

    // Get/Set:
    PTR_GET_SET(Declaration, Attributes, attrs)
    PTR_GET_SET(Declaration, Identifier, id)

  protected:
    PTR_ATTR(Attributes, attrs);
    PTR_ATTR(Identifier, id);

    friend class Inline;
    friend class Resolve;
    DECORATION(Vector<const Expression*>*, uses);
};

inline std::string Declaration::stringify() const {
  STRINGIFY_BEGIN(Declaration);
  STRINGIFY_SUPER(ModuleItem);
  STRINGIFY_POINTER(attrs);
  STRINGIFY_POINTER(id);
  STRINGIFY_END();
}

inline Declaration::Declaration(Node::Tag tag) : ModuleItem(tag) { 
  uses_ = nullptr;
}

inline Declaration::~Declaration() {
  if (uses_ != nullptr) {
    delete uses_;
  }
}

} // namespace cascade 

#endif
