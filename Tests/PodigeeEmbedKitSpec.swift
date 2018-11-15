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
        
        describe("podcast embed") {
            describe("podcast") {
                it("returns the correct podcast title") {
                    var podcastTitle: String?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        podcastTitle = podcastEmbed?.podcast.title
                    }
                    expect(podcastTitle).toEventually(equal("Podigee Podcast News"))
                }
                it("returns correct connection urls to itunes and spotify") {
                    var spotifyConnection: URL?
                    var itunesConnection: URL?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        spotifyConnection = podcastEmbed?.podcast.connections.spotify
                        itunesConnection = podcastEmbed?.podcast.connections.itunes
                    }
                    expect(spotifyConnection).toEventually(equal(URL(string: "https://open.spotify.com/show/2ZChoUyNqFitJKlsukcbEk?si=HsSsoAgeT0emvakB8nybbw")!))
                    expect(itunesConnection).toEventually(equal(URL(string: "https://itunes.apple.com/podcast/id1403134985")!))
                }
                it("returns the correct feed url") {
                    var feedUrl: URL?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        feedUrl = podcastEmbed?.podcast.feed
                    }
                    expect(feedUrl).toEventually(equal(URL(string: "https://podcast-news.podigee.io/feed/mp3")!))
                }
                
            }
            describe("episode") {
                it("returns nil for episode if no episode is published yet") {
                    var episode: Episode? = self.makeDummyEpisode()
                    var embed: PodcastEmbed?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed-empty-episode.io") { (podcastEmbed, error) in
                        embed = podcastEmbed
                        episode = podcastEmbed?.episode
                    }
                    expect(embed).toNotEventually(beNil())
                    expect(episode).toEventually(beNil())
                }
            }
            describe("extensions") {
                
            }
        }
        
        describe("playlist") {
            
        }

    }
    
    private func makeDummyEpisode() -> Episode {
        return Episode(media: Episode.Media(mp3: URL(string: "https://podigee.io/file.audio")!, aac: URL(string: "https://podigee.io/file.audio")!, vorbis: URL(string: "https://podigee.io/file.audio")!, opus: URL(string: "https://podigee.io/file.audio")!), coverUrl: nil, title: "Title", subtitle: "Subtitle", description: "Some description", chaptermarks: [], url: URL(string: "https://podigee.io/podcast")!, transcript: nil, number: 4, duration: 1234)
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
            stub(condition: isHost("podcast-news-embed-empty-episode.io"), response: { (request) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("podcast_news_embed.empty_episode.json", type(of: self))!,
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
