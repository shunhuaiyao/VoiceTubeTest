//
//  Videos.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import Foundation

struct Videos: Decodable {
    let videos: [Video]

    enum CodingKeys: String, CodingKey {
        case videos
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        videos = try container.decodeIfPresent([Video].self, forKey: .videos) ?? []
    }
}
