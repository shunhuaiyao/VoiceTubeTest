//
//  AppQuizAPI.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import Moya

enum AppQuizAPI {
    case videos
}

extension AppQuizAPI: VoiceTubeTargetType {
    var path: String {
        switch self {
        case .videos:
            return "/appQuiz"
        }
    }

    var method: Method {
        switch self {
        case .videos:
            return .post
        }
    }

    var voiceTubeTask: VoiceTubeTask {
        switch self {
        case .videos:
            let params: [String: Any] = [
                "username": "VoiceTube",
                "password": "interview"
            ]
            return .requestParameters(params)
        }
    }
}
