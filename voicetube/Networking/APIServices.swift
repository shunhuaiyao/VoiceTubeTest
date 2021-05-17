//
//  APIServices.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/17.
//

import Moya

class APIServices {
    static let networkLoggerPlugin = NetworkLoggerPlugin(
        configuration: .init(
            formatter: .init(
                responseData: JSONResponseDataFormatter
            ),
            logOptions: .verbose
        )
    )

    private static let defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    private static let provider: MoyaProvider<MultiTarget> = {
        let plugins: [PluginType] = [networkLoggerPlugin]
        return MoyaProvider<MultiTarget>(plugins: plugins)
    }()
    
    private static func JSONResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String()
        } catch {
            return String()
        }
    }
}

extension APIServices {
    static let appQuiz = AppQuizService(provider: provider, defaultDecoder: defaultDecoder)
}
