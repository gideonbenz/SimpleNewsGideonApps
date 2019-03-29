//
//  CurrentNews.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation
struct CurrentNews {
    /*
     -. Judul   (✓)-
     -. Snippet (✓)
     -. Gambar  (✓)-
     example https://static01.nyt.com/images/2019/03/25/opinion/25thaksin/merlin_152557818_545d11b8-6444-4541-9780-771a945c31af-articleLarge.jpg?quality=75&amp;auto=webp&amp;disable=upscale
     -. Tanggal (✓)
    */
    
    /*
     web_url            :    https://www.nytimes.com/2019/03/25/opinion/thaksin-shinawatra-the-election-in-thailand-was-rigged.html
     snippet (✓)        :    The junta is ready to destroy an entire system just to stay in power.
     lead_paragraph     :    The junta is ready to destroy an entire system just to stay in power.
     print_page         :    23
     blog                    {0}
     source             :    The New York Times
     multimedia         :    0 {11}
     
                             rank               :  0
                             subtype            :  xlarge
                             caption            :  null
                             credit             :  null
                             type               :  image
                             url (✓)            :  images/2019/03/25/opinion/25thaksin/merlin_152557818_545d11b8-6444-4541-9780-771a945c31af-articleLarge.jpg
                             height             :   380
                             width              :   600
                             legacy             :   {3}
                             subType            :   xlarge
                             crop_name          :   articleLarge
                             headline           :   {7}
                             keywords           :   [7]
                             pub_date           :   2019-03-25T11:21:09+0000
                             document_type      :   article
                             news_desk          :   OpEd
                             section_name       :   Opinion
                             byline             :   {3}
                             type_of_material   :   Op-Ed
                             _id                :   5c98b9fe49f0eacbf105ee18
                             word_count         :   680
                             score              :   0
                             uri                :   nyt://article/a9fd5a21-553b-581c-85df-cc5d7430e3cc
     
                            1 {11}
                            2 {11}
                            3 {11}
                            4 - 68
     
     headline           :   {7}
                            main (✓)            :   Thaksin Shinawatra: The Election in Thailand Was Rigged
                            kicker              :   null
                            content_kicker      :   null
                            print_headline      :   The Election in Thailand Was Rigged
                            name                :    null
                            seo                 :    null
                            sub                 :    null

     keywords           :   [7]
     pub_date (✓)       :   2019-03-25T11:21:09+0000
     document_type      :   article
     news_desk          :   OpEd
     section_name       :   Opinion
     byline             :   {3}
     type_of_material   :   Op-Ed
     _id                :   5c98b9fe49f0eacbf105ee18
     word_count         :   680
     score              :   0
     uri                :   nyt://article/a9fd5a21-553b-581c-85df-cc5d7430e3cc


    */
    let headline: String
    let snippet: String
    let date: Date?
    let dateFormatter = DateFormatter()
    
    // image here
//    let rank: Int
//    let subtype: String
//    let type: String
//    let url: String
//    let height: Int
//    let width: Int
    
    private struct NewsKeys {
        static let headlines = "headline"
        static let headline = "main"
        static let snippet = "snippet"
        static let image = "url"
        static let date = "pub_date"
        static let multimedia = "multimedia"
    }
    
    private struct MultimediaKeys {
        static let rank = "rank"
        static let subType = "subtype"
        static let type = "type"
        static let url = "url"
        static let height = "height"
        static let width = "width"
    }
    
    init?(json : JSON) {
        
//        guard let multimedia = json[NewsKeys.multimedia] as? arrayJSON else { return nil }
//        guard let date = multimedia[]
//        print(multimedia)
//        get headline
        
        guard let headlines = json[NewsKeys.headlines] as? JSON else { return nil }
        guard let headline = headlines[NewsKeys.headline] as? String else { return nil }
        self.headline = headline
        
//        get snippet
        
        guard let snippet = json[NewsKeys.snippet] as? String else { return nil }
        self.snippet = snippet
        
//        get date
        
        guard let dateString = json[NewsKeys.date] as? String else { return nil }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        self.date = dateFormatter.date(from: dateString)
        
//        get imageURL
        
        
//        guard let multimedia = json[]
//
//        guard let rank = json[MultimediaKeys.rank] as? Int,
//            let subtype = json[MultimediaKeys.subType] as? String,
//            let type = json[MultimediaKeys.type] as? String,
//            let urlString = json[MultimediaKeys.url] as? String,
//            let height = json[MultimediaKeys.height] as? Int,
//            let width = json[MultimediaKeys.width] as? Int
//            else { return nil }
//
//        self.rank = rank
//        self.subtype = subtype
//        self.type = type
//        self.url = urlString
//        self.height = height
//        self.width = width
        
        
//        -------------------------------------------------------------
        
        
//        guard let title = json[NewsKeys.title] as? String,
//            let snippet = json[NewsKeys.snippet] as? String,
//            let imageURLString = json[NewsKeys.image] as? String,
//            let dateString = json[NewsKeys.date] as? String else {
//            return nil
//        }
        
//        self.title = title
//        self.snippet = snippet
//        self.image = URL(string: imageURLString)
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//        self.date = dateFormatter.date(from: dateString)
    }
}
