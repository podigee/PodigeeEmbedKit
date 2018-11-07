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

        describe("PodigeeEmbedKitSpec") {
            it("works") {
                expect(PodigeeEmbedKit.name) == "PodigeeEmbedKit"
            }
        }

    }

}
