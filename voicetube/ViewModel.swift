//
//  ViewModel.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/16.
//

import RxCocoa
import RxSwift

class ViewModel: ViewModelType {
    struct Input {
        let timerInputText: Binder<String>
    }

    struct Output {
        let isTimerStartButtonEnabled: Driver<Bool>
    }
    
    private(set) lazy var input = Input(
        timerInputText: timerInputTextRelay.asBinder()
    )
    let output: Output

    private let timerInputTextRelay = BehaviorRelay<String>(value: "")
    private let isTimerStartButtonEnabledRelay = BehaviorRelay<Bool>(value: false)
    private let bag = DisposeBag()

    init() {
        output = Output(
            isTimerStartButtonEnabled: isTimerStartButtonEnabledRelay.asDriver()
        )

        timerInputTextRelay
            .map { !$0.isEmpty }
            .bind(to: isTimerStartButtonEnabledRelay)
            .disposed(by: bag)
    }
}
