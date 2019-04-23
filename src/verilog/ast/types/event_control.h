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

#ifndef CASCADE_SRC_VERILOG_AST_EVENT_CONTROL_H
#define CASCADE_SRC_VERILOG_AST_EVENT_CONTROL_H

#include "src/verilog/ast/types/event.h"
#include "src/verilog/ast/types/macro.h"
#include "src/verilog/ast/types/timing_control.h"

namespace cascade {

class EventControl : public TimingControl {
  public:
    // Constructors:
    EventControl();
    template <typename EventsItr>
    EventControl(EventsItr events_begin__, EventsItr events_end__);
    ~EventControl() override;

    // Node Interface:
    NODE(EventControl)
    EventControl* clone() const override;
    std::string stringify() const override;

    // Get/Set:
    MANY_GET_SET(EventControl, Event, events)

  private:
    MANY_ATTR(Event, events);
};

inline EventControl::EventControl() : TimingControl(Node::Tag::event_control) {
  MANY_DEFAULT_SETUP(events);
  parent_ = nullptr;
}

template <typename EventsItr>
inline EventControl::EventControl(EventsItr events_begin__, EventsItr events_end__) : EventControl() {
  MANY_SETUP(events);
}

inline EventControl::~EventControl() {
  MANY_TEARDOWN(events);
}

inline EventControl* EventControl::clone() const {
  auto* res = new EventControl();
  MANY_CLONE(events);
  return res;
}

std::string stringify() const {
  STRINGIFY_BEGIN(EventControl);
  STRINGIFY_SUPER(TimingControl);
  STRINGIFY_VECTOR(events);
  STRINGIFY_END();
}
} // namespace cascade 

#endif
