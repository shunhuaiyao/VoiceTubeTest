//
//  AppQuizService.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import RxSwift

class AppQuizService: APIBaseService<AppQuizAPI> {
    func videos() -> Single<Videos> {
        return requestDecoded(target: .videos)
    }
}
