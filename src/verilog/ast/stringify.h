#ifndef CASCADE_SRC_VERILOG_AST_STRINGIFY_H
#define CASCADE_SRC_VERILOG_AST_STRINGIFY_H

#include <string>
#include <typeinfo>

#define stringify_begin(type) \
    ostringstream ss;\
    ss << "{" << typeid(type).name()

#define stringify_end() \
    ss << "}";\
    return ss.str()

#define stringify_base_field(field) \
    ss << "VAL{" << typeid(field).name() << "," << field << "}"

#define stringify_super(super) \
    ss << "SUPER" << super::stringify()

#define stringify_pointer(pointer) \
    ss << "POINTER" << pointer->stringify()

namespace cascade {

template <typename T>
std::string stringify_vector(std::vector<T>& v) {
    ostringstream ss;
    for (auto& it : v) {
        ss << it.stringify();
        if (it != --v.end()) {
            ss << ",";
        }
    }
    return ss.str();
}

}
#endif
