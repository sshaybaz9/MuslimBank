//
//  main.swift
//  MBank
//
//  Created by Mac on 12/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

CommandLine.unsafeArgv.withMemoryRebound(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
{   argv in
    _ = UIApplicationMain(CommandLine.argc, argv, NSStringFromClass(InterractionUIApplication.self), NSStringFromClass(AppDelegate.self))
}
