//
//  CommonMethods.swift
//  Moviez
//
//  Created by Ankit Nandal on 13/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import Foundation
import UIKit

func print(_ object: Any) {
    #if DEBUG
        Swift.print(object)
    #endif
}
