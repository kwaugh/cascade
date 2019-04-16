#include "hash.h"
#include "sha3.h"

std::string Hash::sha3_224(std::string msg) {
    sha3_ctx ctx;
    rhash_sha3_224_init(&ctx);
    rhash_sha3_update(&ctx, (unsigned char*)msg.c_str(), msg.size());
    unsigned char result[sha3_224_hash_size];
    rhash_sha3_final(&ctx, result);
    return std::string((char*)result);
}

std::string Hash::sha3_256(std::string msg) {
    sha3_ctx ctx;
    rhash_sha3_256_init(&ctx);
    rhash_sha3_update(&ctx, (unsigned char*)msg.c_str(), msg.size());
    unsigned char result[sha3_256_hash_size];
    rhash_sha3_final(&ctx, result);
    return std::string((char*)result);
}

std::string Hash::sha3_384(std::string msg) {
    sha3_ctx ctx;
    rhash_sha3_384_init(&ctx);
    rhash_sha3_update(&ctx, (unsigned char*)msg.c_str(), msg.size());
    unsigned char result[sha3_384_hash_size];
    rhash_sha3_final(&ctx, result);
    return std::string((char*)result);
}

std::string Hash::sha3_512(std::string msg) {
    sha3_ctx ctx;
    rhash_sha3_512_init(&ctx);
    rhash_sha3_update(&ctx, (unsigned char*)msg.c_str(), msg.size());
    unsigned char result[sha3_512_hash_size];
    rhash_sha3_final(&ctx, result);
    return std::string((char*)result);
}
