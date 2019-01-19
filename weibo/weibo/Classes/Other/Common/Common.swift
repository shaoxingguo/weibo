//
//  Common.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import Foundation

func XGPrint(_ item : Any, file : String = #file, lineNum : Int = #line)
{
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("fileName:\(fileName)" + "\t" + "lineNum:\(lineNum)" + "\t" + "\(item)")
    #endif
}
