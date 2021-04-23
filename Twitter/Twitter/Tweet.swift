//
//  Tweet.swift
//  Twitter
//
//  Created by Тамирлан Абаев   on 18.04.2021.
//

import Foundation
import FirebaseDatabase

struct Tweet {
    var content:String?
    var author:String?
    var selectId:String!
    
    init(_ content:String,_ author:String,_ selectId:String) {
        self.content = content
        self.author = author
        self.selectId = selectId
    }
    
    var dict:[String:String] {
        return [
            "content": content!,
            "author": author!,
            "selectId": selectId!
        ]
    }
     
    init(snapshot:DataSnapshot) {
        if let value = snapshot.value as? [String:String] {
            content = value["content"]
            author = value["author"]
            selectId = value["selectId"]
        }
    }
    
}
