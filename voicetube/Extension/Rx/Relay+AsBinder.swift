//
//  Relay+AsBinder.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/16.
//

import RxCocoa
import RxSwift

extension PublishRelay {
    func asBinder() -> Binder<Element> {
        return Binder<Element>(self) { relay, e in
            relay.accept(e)
        }
    }
}

extension BehaviorRelay {
    func asBinder() -> Binder<Element> {
        return Binder<Element>(self) { relay, e in
            relay.accept(e)
        }
    }
}
