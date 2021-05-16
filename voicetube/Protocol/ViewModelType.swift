//
//  ViewModelType.swift
//  voicetube
//
//  Created by Yao Shun-Huai on 2021/5/16.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
