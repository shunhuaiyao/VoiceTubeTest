//
//  Video.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import Foundation

struct Video: Decodable {
    let title: String
    let imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "img"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
    }
}
