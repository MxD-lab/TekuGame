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
    var subType:Int;
     override init()
    {
        self.type = Types.empty;
        self.subType = 0;
        super.init();
    }
    init(t:Types)
    {
        self.type = t;
        self.subType = 0;
        super.init();
    }
    init(s:Int)
    {
        self.type = Types.empty;
        self.subType = s;
        super.init();
    }
    init(t:Types, s:Int)
    {
        self.type = t;
        self.subType = s;
        super.init();
    }
}