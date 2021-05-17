//
//  ViewController.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ViewController: UIViewController {
    
    private let timerInputTextView: UITextView = {
        let tv = UITextView()
        tv.keyboardType = .numberPad
        tv.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 8, right: 10)
        tv.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        tv.layer.cornerRadius = 3.0
        tv.layer.borderWidth = 1.0
        return tv
    }()
    
    private let timerStartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.setTitle("Start", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundImage(.fillColor(with: .black), for: .normal)
        btn.setBackgroundImage(.fillColor(with: UIColor.lightGray.withAlphaComponent(0.5)), for: .disabled)
        btn.tintColor = .clear
        btn.layer.cornerRadius = 3.0
        btn.clipsToBounds = true
        return btn
    }()
    
    private let timerLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray.withAlphaComponent(0.3)
        lb.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        lb.textAlignment = .center
        lb.text = "0 s"
        return lb
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: VideoCollectionViewCell.self))
        cv.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 120, right: 16)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        cv.delegate = self
        return cv
    }()
    
    private let viewModel: ViewModel
    private let bag = DisposeBag()

    init() {
        viewModel = ViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupBindings()
    }

    private func setupSubviews() {
        view.addSubview(timerInputTextView)
        view.addSubview(timerStartButton)
        view.addSubview(timerLabel)
        view.addSubview(collectionView)
        
        timerInputTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.left.equalToSuperview().inset(16)
        }
        timerStartButton.snp.makeConstraints {
            $0.top.equalTo(timerInputTextView)
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(timerInputTextView.snp.right).offset(20)
            $0.height.equalTo(timerInputTextView)
        }
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timerInputTextView.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview().offset(130)
            $0.height.equalTo(280)
        }
    }
    
    private func setupBindings() {
        timerInputTextView.rx.text.orEmpty
            .bind(to: viewModel.input.timerInputText)
            .disposed(by: bag)
        
        viewModel.output.isTimerStartButtonEnabled
            .drive(timerStartButton.rx.isEnabled)
            .disposed(by: bag)
        
        timerStartButton.rx.tap
            .do(onNext: { [weak self] in
                self?.timerInputTextView.resignFirstResponder()
            })
            .bind(to: viewModel.input.didStartButtonTap)
            .disposed(by: bag)

        viewModel.output.timerCount
            .drive(timerLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.output.isTimerCounting
            .drive(onNext: { [weak self] isTimerCounting in
                if isTimerCounting {
                    self?.timerStartButton.isEnabled = false
                    self?.timerLabel.textColor = .black
                } else {
                    self?.timerStartButton.isEnabled = true
                    self?.timerLabel.textColor = UIColor.lightGray.withAlphaComponent(0.3)
                }
            })
            .disposed(by: bag)
        
        viewModel.output.videos
            .drive(collectionView.rx.items) { cv, item, video in
                let cell: VideoCollectionViewCell = cv.dequeueReusableCell(
                    withReuseIdentifier: String(describing: VideoCollectionViewCell.self),
                    for: IndexPath(item: item, section: 0)
                ) as! VideoCollectionViewCell
                cell.configure(with: video)
                return cell
            }
            .disposed(by: bag)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
