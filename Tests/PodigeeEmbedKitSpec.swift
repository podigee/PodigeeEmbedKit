//
//  PodigeeEmbedKitSpec.swift
//  PodigeeEmbedKit
//
//  Created by Podigee on 04/10/16.
//  Copyright © 2017 podigee. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import PodigeeEmbedKit

class PodigeeEmbedKitSpec: QuickSpec {

    override func spec() {
        describe("embed data") {
            
            let embedStub = stub(condition: isHost("podcast-news.podigee.io"), response: { (request) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("podcast_news_embed.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type":"application/json"]
                )
            })
            
            it("returns the correct podcast title") {
                var podcastTitle: String?
                PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news.podigee.io") { (podcastEmbed, error) in
                    podcastTitle = podcastEmbed?.podcast.title
                }
                expect(podcastTitle).toEventually(equal("Podigee Podcast News"))
            }
            
            OHHTTPStubs.removeStub(embedStub)
        }

    }

}
