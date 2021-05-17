//
//  ViewModel.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/16.
//

import RxCocoa
import RxSwift
import CoreData

class ViewModel: ViewModelType {
    struct Input {
        let timerInputText: Binder<String>
        let didStartButtonTap: Binder<Void>
    }

    struct Output {
        let isTimerStartButtonEnabled: Driver<Bool>
        let timerCount: Driver<String>
        let isTimerCounting: Driver<Bool>
        let videos: Driver<[Video]>
    }
    
    internal enum TimerState {
        case suspended
        case resumed
    }
    
    private(set) lazy var input = Input(
        timerInputText: timerInputTextRelay.asBinder(),
        didStartButtonTap: didStartButtonTapRelay.asBinder()
    )
    let output: Output
    private let appQuizService: AppQuizService

    private let timerInputTextRelay = BehaviorRelay<String>(value: "")
    private let isTimerStartButtonEnabledRelay = BehaviorRelay<Bool>(value: false)
    private let didStartButtonTapRelay = PublishRelay<Void>()
    private(set) var timerStateRelay = BehaviorRelay<TimerState>(value: .suspended)
    private(set) var timerCountRelay = BehaviorRelay<Int>(value: .zero)
    private let videosRelay = BehaviorRelay<[Video]>(value: [])
    private let bag = DisposeBag()
    
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now() + 1.0, repeating: 1.0)
        return timer
    }()

    init(
        appQuizService: AppQuizService = APIServices.appQuiz
    ) {
        output = Output(
            isTimerStartButtonEnabled: isTimerStartButtonEnabledRelay.asDriver(),
            timerCount: timerCountRelay.asDriver().map { String($0) + " s" },
            isTimerCounting: timerCountRelay.asDriver().map { $0 > .zero },
            videos: videosRelay.asDriver()
        )
        self.appQuizService = appQuizService

        getVideosCache()
        setupNotifications()

        timerInputTextRelay
            .withLatestFrom(timerCountRelay) {
                !$0.isEmpty && $1 == .zero
            }
            .bind(to: isTimerStartButtonEnabledRelay)
            .disposed(by: bag)
        
        didStartButtonTapRelay
            .withLatestFrom(timerStateRelay)
            .filter { $0 == .suspended }
            .withLatestFrom(timerInputTextRelay)
            .map { Int($0) }
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [weak self] seconds in
                self?.startTimer(from: seconds)
            })
            .disposed(by: bag)
    }
    
    func startTimer(from seconds: Int) {
        timerCountRelay.accept(seconds)
        timer.setEventHandler { [weak self] in
            guard let timerCount = self?.timerCountRelay.value, timerCount > .zero else {
                self?.suspendTimer()
                return
            }
            let newTimerCount = timerCount - 1
            self?.timerCountRelay.accept(newTimerCount)
        }
        resumeTimer()
    }
    
    private func resumeTimer() {
        guard timerStateRelay.value == .suspended else { return }
        timer.resume()
        timerStateRelay.accept(.resumed)
    }
    
    private func suspendTimer() {
        guard timerStateRelay.value == .resumed else { return }
        timer.suspend()
        timerStateRelay.accept(.suspended)
    }
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(appMovedToBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(appMovedToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func fetchVideos() {
        appQuizService.videos()
            .map { $0.videos }
            .subscribe(onSuccess: { [weak self] videos in
                self?.videosRelay.accept(videos)
                self?.saveVideosToCache(videos)
            })
            .disposed(by: bag)
    }
    
    private func getVideosCache() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "ManagedVideo")
        do {
            let managedVideos = try context.fetch(request)
            if managedVideos.isEmpty {
                fetchVideos()
            } else {
                var videos: [Video] = []
                managedVideos.forEach {
                    if let title = $0.value(forKey: "title") as? String,
                       let imageURL = $0.value(forKey: "imageURL") as? String {
                        videos.append(
                            Video(title: title, imageURL: URL(string: imageURL))
                        )
                    }
                }
                videosRelay.accept(videos)
            }
        } catch let error as NSError {
            print("Could not fetch with \(error).")
        }
    }
    
    private func saveVideosToCache(_ videos: [Video]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let entity = NSEntityDescription.entity(forEntityName: "ManagedVideo", in: appDelegate.persistentContainer.viewContext) else { return }
        videos.forEach {
            let video = NSManagedObject(entity: entity, insertInto: appDelegate.persistentContainer.viewContext)
            video.setValue($0.title, forKey: "title")
            if let imageURL = $0.imageURL?.absoluteString {
                video.setValue(imageURL, forKey: "imageURL")
            }
        }
        do {
            try appDelegate.persistentContainer.viewContext.save()
            
        } catch let error as NSError {
            print("Could not save with \(error).")
        }
    }
    
    @objc func appMovedToBackground() {
        suspendTimer()
    }

    @objc func appMovedToForeground() {
        resumeTimer()
    }
}
