//
//  ObservableType+Nwise.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import RxCocoa
import RxSwift

extension ObservableType {
    public func nwise(_ n: Int) -> Observable<[Element]> {
        assert(n > 1, "n must be greater than 1")
        return scan([]) { acc, item in Array((acc + [item]).suffix(n)) }
            .filter { $0.count == n }
    }

    public func pairwise() -> Observable<(Element, Element)> {
        return nwise(2)
            .map { ($0[0], $0[1]) }
    }
}
