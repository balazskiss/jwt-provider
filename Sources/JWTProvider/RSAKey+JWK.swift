import Foundation
import CTLS
import JWT

public extension RSAKey {

    public init(n: String, e: String, d: String? = nil) throws {

        func parseBignum(_ s: String) -> UnsafeMutablePointer<BIGNUM> {
            return s.makeBytes().base64URLDecoded.withUnsafeBufferPointer { p in
                return BN_bin2bn(p.baseAddress, Int32(p.count), nil)
            }
        }

        let rsa = RSA_new()!
        rsa.pointee.n = parseBignum(n)
        rsa.pointee.e = parseBignum(e)

        if let d = d {
            rsa.pointee.d = parseBignum(d)
            self = .private(rsa)
        } else {
            self = .public(rsa)
        }
    }
}
