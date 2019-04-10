//
//  NewsCore
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation
struct NewsCore {
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
    let headline: String?
    let snippet: String?
    let date: Date?
    let dateFormatter = DateFormatter()
    let image: Data?
    let id: Int16?
    
    init?(newsCoreData : NewsCoredata) {
        
        let headlineCore = newsCoreData.headlineCore
        let snippetCore = newsCoreData.snippetCore
        let dateCore = newsCoreData.dateCore
        let imageCore = newsCoreData.imageCore
        let id = newsCoreData.idCore
        
        self.headline = headlineCore
        self.snippet = snippetCore
        self.date = dateCore as Date?
        self.image = imageCore as Data?
        self.id = id
    }
    
    
}
