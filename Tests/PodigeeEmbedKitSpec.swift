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
        stubRequests()
        
        describe("embed data") {
            it("returns the correct podcast title") {
                var podcastTitle: String?
                PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                    podcastTitle = podcastEmbed?.podcast.title
                }
                expect(podcastTitle).toEventually(equal("Podigee Podcast News"))
            }
        }

    }
    
    private func stubRequests() {
        beforeSuite {
            stub(condition: isHost("podcast-news-embed.io"), response: { (request) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("podcast_news_embed.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type":"application/json"]
                )
            })
            stub(condition: isHost("podcast-news-playlist.io"), response: { (request) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("podcast_news_playlist.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type":"application/json"]
                )
            })
        }
        afterSuite {
            OHHTTPStubs.removeAllStubs()
        }
    }

}
