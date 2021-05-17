//
//  VoiceTubeTargetType.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import Moya

enum VoiceTubeTask {
    case requestParameters(_ parameters: [String: Any])
}

protocol VoiceTubeTargetType: TargetType {
    var voiceTubeTask: VoiceTubeTask { get }
}

extension VoiceTubeTargetType {
    var baseURL: URL {
        return URL(string: "https://us-central1-lithe-window-713.cloudfunctions.net")!
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var task: Task {
        switch voiceTubeTask {
        case let .requestParameters(parameters):
            let encoding: ParameterEncoding
            switch method {
            case .post, .patch, .delete, .put:
                encoding = JSONEncoding.default
            default:
                encoding = URLEncoding.default
            }
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
    }
    
    var sampleData: Data {
        Data()
    }
}
