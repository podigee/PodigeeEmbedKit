//
//  PodigeeEmbedKitSpec.swift
//  PodigeeEmbedKit
//
//  Created by Podigee on 04/10/16.
//  Copyright © 2017 podigee. All rights reserved.
//

import Quick
import Nimble
@testable import PodigeeEmbedKit

class PodigeeEmbedKitSpec: QuickSpec {

    override func spec() {
        describe("embed data") {
            it("returns the correct podcast title") {
                var podcastTitle: String?
                PodigeeEmbedKit.embedDataForPodcastWith(domain: "bananaland.podigee.io") { (podcastEmbed, error) in
                    podcastTitle = podcastEmbed?.podcast.title
                }
                expect(podcastTitle).toEventually(equal("Bananaland"))
            }
        }

    }

}
