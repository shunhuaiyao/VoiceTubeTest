//
//  UIScrollView+LoadMore.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {
    var loadMoreVertically: ControlEvent<Void> {
        let willEndDragginAndLoadMore = base.rx.willEndDragging
            .filter {
                $0.velocity.y > 0
            }
            .map { _ in () }
            .filter {
                let screenBottomY = self.base.contentOffset.y + self.base.bounds.height
                let loadMoreY = self.base.contentSize.height - self.base.bounds.height
                return loadMoreY < screenBottomY
            }
        let didScrollToBottomAndLoadMore = base.rx.didScroll
            .map { _ -> CGFloat in
                let screenBottomY = self.base.contentOffset.y + self.base.bounds.height - self.base.contentInset.bottom
                let loadMoreY = self.base.contentSize.height
                return screenBottomY - loadMoreY
            }
            .pairwise()
            .filter { $0 <= 0 && $1 > 0 }
            .map { _ in () }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
        let observable = Observable.merge(willEndDragginAndLoadMore, didScrollToBottomAndLoadMore)
        return ControlEvent(events: observable)
    }
}
