//
//  APIBaseService.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import Moya
import RxCocoa
import RxSwift

class APIBaseService<Target> where Target: VoiceTubeTargetType {

    private var provider: MoyaProvider<MultiTarget>
    private var defaultDecoder: JSONDecoder

    init(provider: MoyaProvider<MultiTarget>, defaultDecoder: JSONDecoder) {
        self.provider = provider
        self.defaultDecoder = defaultDecoder
    }

    func requestDecoded<T: Decodable>(target: Target) -> Single<T> {
        return provider.rx.request(MultiTarget(target))
            .flatMap { [weak self] moyaResponse -> Single<T> in
                guard let self = self else { return .never() }
                do {
                    let jsonDecoder = self.defaultDecoder
                    let decodable = try moyaResponse
                        .filterSuccessfulStatusCodes()
                        .map(T.self, atKeyPath: nil, using: jsonDecoder, failsOnEmptyData: true)
                    return .just(decodable)
                } catch {
                    return .error(error)
                }
            }
    }
}
