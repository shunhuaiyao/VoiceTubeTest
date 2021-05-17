//
//  VideoCollectionViewCell.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import Kingfisher
import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    private let videoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let videoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 32, weight: .regular)
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 3
        return lb
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.layer.borderWidth = 0.5
        v.layer.cornerRadius = 3.0
        v.layer.borderColor = UIColor.black.cgColor
        v.clipsToBounds = true
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(videoImageView)
        containerView.addSubview(videoTitleLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        videoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        videoTitleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
    }

    func configure(with video: Video) {
        videoImageView.kf.setImage(
            with: video.imageURL,
            options: [
                .transition(ImageTransition.fade(0.5)),
                .forceTransition
            ]
        )
        videoTitleLabel.text = video.title
    }
}
