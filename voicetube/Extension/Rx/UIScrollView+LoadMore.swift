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
    var loadMoreHorizontally: ControlEvent<Void> {
        let willEndDragginAndLoadMore = base.rx.willEndDragging
            .filter {
                $0.velocity.x > 0
            }
            .map { _ in () }
            .filter {
                let screenBottomX = self.base.contentOffset.x + self.base.bounds.width
                let loadMoreX = self.base.contentSize.width - 3 * self.base.bounds.width
                return loadMoreX < screenBottomX
            }
        let didScrollToBottomAndLoadMore = base.rx.didScroll
            .map { _ -> CGFloat in
                let screenBottomX = self.base.contentOffset.x + self.base.bounds.width - self.base.contentInset.right
                let loadMoreX = self.base.contentSize.width
                return screenBottomX - loadMoreX
            }
            .pairwise()
            .filter { $0 <= 0 && $1 > 0 }
            .map { _ in () }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
        let observable = Observable.merge(willEndDragginAndLoadMore, didScrollToBottomAndLoadMore)
        return ControlEvent(events: observable)
    }
}
