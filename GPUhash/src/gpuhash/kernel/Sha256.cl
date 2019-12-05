#ifndef uint32_t
#define uint32_t unsigned int
#endif

#define H0 0x6a09e667
#define H1 0xbb67ae85
#define H2 0x3c6ef372
#define H3 0xa54ff53a
#define H4 0x510e527f
#define H5 0x9b05688c
#define H6 0x1f83d9ab
#define H7 0x5be0cd19

uint rotr (uint x, uint n) {
    return (x >> n) | (x << (32 - n));
}

// Ch(x,y,z)=(x&y)xor(!x&z)
uint ch (uint x, uint y, uint z) {
    return (x & y) ^ (~x & z);
}

// Maj(x,y,z)=(x&y)xor(x&z)xor(y&z)
uint maj (uint x, uint y, uint z) {
    return (x & y) ^ (x & z) ^ (y & z); 
}

// Sigma0(x)=ROTR2(x) xor ROTR13(x) xor ROTR22(x)
uint sigma0 (uint x) {
    return rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22);
}

// Sigma1(x)=ROTR6(x) xor ROTR11(x) xor ROTR25(x)
uint sigma1 (uint x) {
    return rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25);
}

// Sig0(x)=ROTR7(x) xor ROTR18(x) xor ROTR3(x)
uint sig0 (uint x) {
    return rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3);
}

// Sig1(x)=ROTR17(x) xor ROTR19(x) xor ROTR10(x)
uint sig1 (uint x) {
    return rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10);
}

kernel void sha256Kernel (global uint *data_info, global char *data, global uint *Hash) { // H for 8 hash word values
    uint i, t, len, N; // i is iteration for N blocks, t is 64 iterations, len is data string length, N is total number of blocks
    uint W[64], temp, A,B,C,D,E,F,G,H,T1,T2; // W is message schedule, A-H 8 working variables, T1&T2 2 value used
    int block, used; // Current block of message, used length of message
    int gid = get_global_id(0); // global id
    int origin = gid * 8;
    
    uint K[64]={
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }; // 64 32-bit constants
    
    len = data_info[2]; // Data string length
    N = ( len%64>=56?2:1 ) + len/64; // (l+1+k)%512=448, add one 1 and k 0 after l and extra 64 for l
    // Setting H0(0)-H7(0)
    Hash[0 + origin] = H0;
    Hash[1 + origin] = H1;
    Hash[2 + origin] = H2;
    Hash[3 + origin] = H3;
    Hash[4 + origin] = H4;
    Hash[5 + origin] = H5;
    Hash[6 + origin] = H6;
    Hash[7 + origin] = H7;
    
    // Do for N message blocks
    for (i = 0; i < N; i++) {
        // Initialize working variables
        A = Hash[0 + origin];
        B = Hash[1 + origin];
        C = Hash[2 + origin];
        D = Hash[3 + origin];
        E = Hash[4 + origin];
        F = Hash[5 + origin];
        G = Hash[6 + origin];
        H = Hash[7 + origin];
        
        // --------------Preprocessing-----------------
        #pragma unroll
        for (t = 0; t < 64; t++){
            W[t] = 0x00000000;
        }
        used = i * 64; // 512 bits/block, 64 bytes
        // Set real message size in current block
        if (len > used) {
            block = (len-used)>64?64:(len-used);
        } else {
            block = -1;
        }
        if (block > 0) {
            used *= 2;
            // Wt=Mt(i), 0<=t<=15
            for (t = 0; t < block/4; t++) {
                W[t] = ((uchar) data[used + t * 8]) << 24; // The first 8 bits (1 byte)
                W[t] |= ((uchar) data[used + t * 8 + 2]) << 16; // The second 8 bits (1 byte)
                W[t] |= ((uchar) data[used + t * 8 + 4]) << 8; // The third 8 bits (1 byte)
                W[t] |= (uchar) data[used + t * 8 + 6]; // The last 8 bits (1 byte)
                //printf("W[%u]=%x\n", t, W[t]);
            }
            if (block%4 == 3) {
                W[t] = ((uchar) data[used + t * 8]) << 24; // The first 8 bits (1 byte)
                W[t] |= ((uchar) data[used + t * 8 + 2]) << 16; // The second 8 bits (1 byte)
                W[t] |= ((uchar) data[used + t * 8 + 4]) << 8; // The third 8 bits (1 byte)
                W[t] |= 0x80; // An 1 and seven 0s
            } else if (block%4 == 2) {
                W[t] = ((uchar) data[used + t * 8]) << 24; // The first 8 bits (1 byte)
                W[t] |= ((uchar) data[used + t * 8 + 2]) << 16; // The second 8 bits (1 byte)
                W[t] |= 0x8000; // An 1 and fifteen 0s
            } else if (block%4 == 1) {
                W[t] = ((uchar) data[used + t * 8]) << 24; // The 8 bits (1 byte)
                W[t] |= 0x800000; // An 1 and twenty three 0s
            } else {
                W[t] |= 0x80000000; // An 1 and thirty one 0s
            }
            
            if (block < 56) {
                W[15] = len*8; // We assume length is less than 2^32
                //printf("ulen avlue 2 :w[15] :%x\n", W[15]);
            }
        } else if (block < 0) {
            if (len%64 == 0) {
                W[0] = 0x80000000;
            }
            W[15] = len*8;
        }
        // --------------End Preprocessing-----------------
        
        
        // --------------Hashing-----------------
        for (t = 0; t < 64; t++) {
            if (t > 15) {
                W[t] = sig1(W[t-2]) + W[t-7] + sig0(W[t-15]) + W[t-16];
            }
            T1 = H + sigma1(E) + ch(E, F, G) + K[t] + W[t];
            T2 = sigma0(A) + maj(A, B, C);
            H = G;
            G = F;
            F = E;
            E = D + T1;
            D = C;
            C = B;
            B = A;
            A = T1 + T2;
        }
        Hash[0 + origin] += A;
        Hash[1 + origin] += B;
        Hash[2 + origin] += C;
        Hash[3 + origin] += D;
        Hash[4 + origin] += E;
        Hash[5 + origin] += F;
        Hash[6 + origin] += G;
        Hash[7 + origin] += H;
    }
}
