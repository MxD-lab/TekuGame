//
//  Enemy.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

class enemy:Entity
{
    var type:Types;
    init()
    {
        self.type = Types.empty;
        super.init();
    }
}