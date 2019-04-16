/* This is a wrapper class around the rhash hash functions to make it more c++
 * friendly
 */

#include <string>

class Hash {
public:
    static std::string sha3_224(std::string msg);
    static std::string sha3_256(std::string msg);
    static std::string sha3_384(std::string msg);
    static std::string sha3_512(std::string msg);
};
