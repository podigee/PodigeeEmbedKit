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
    
    override func setUp() {
        stubRequests()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }

    override func spec() {        
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
                it("returns the correct title, subtitle and episode number") {
                    var title: String?
                    var subtitle: String?
                    var number: Int?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        title = podcastEmbed?.episode?.title
                        subtitle = podcastEmbed?.episode?.subtitle
                        number = podcastEmbed?.episode?.number
                    }
                    expect(title).toEventually(equal("Return of the Chaos Monkey"))
                    expect(subtitle).toEventually(equal("Podigee Bewerbungsprozess, iTunes Probleme, Podcasthype"))
                    expect(number).toEventually(equal(6))
                }
                it("returns the chapter marks") {
                    var chapters: [Episode.Chaptermark]?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        chapters = podcastEmbed?.episode?.chaptermarks
                    }
                    expect(chapters?.count).toEventually(equal(4))
                    expect(chapters?.first?.title).toEventually(equal("Intro"))
                }
                it("returns correct urls for cover, website and transcript") {
                    var coverUrl: URL?
                    var url: URL?
                    var transcript: URL?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        coverUrl = podcastEmbed?.episode?.coverUrl
                        url = podcastEmbed?.episode?.url
                        transcript = podcastEmbed?.episode?.transcript
                    }
                    expect(coverUrl).toEventually(equal(URL(string: "https://images.podigee.com/400x,sabagK4V_yGDanwc5brVBURwuLdbKAb5BQ1rx5zQcd9o=/https://cdn.podigee.com/uploads/u1/72b01048-d910-4809-8e97-3b25bb4561b1.png")!))
                    expect(url).toEventually(equal(URL(string: "https://podcast-news.podigee.io/6-return-of-the-chaos-monkey")!))
                    expect(transcript).toEventually(equal(URL(string: "https://podcast-news.podigee.io/6-return-of-the-chaos-monkey/transcript.json")!))
                }
                it("returns correctly scaled coverart urls") {
                    var coverUrl: URL?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        coverUrl = podcastEmbed?.episode?.coverartUrlFor(width: 720)
                    }
                    expect(coverUrl).toEventually(equal(URL(string: "https://images.podigee.com/720x,sabagK4V_yGDanwc5brVBURwuLdbKAb5BQ1rx5zQcd9o=/https://cdn.podigee.com/uploads/u1/72b01048-d910-4809-8e97-3b25bb4561b1.png")!))
                }
                context("specific episode path is set") {
                    it("returns the correct episode") {
                        var title: String?
                        var subtitle: String?
                        var number: Int?
                        PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed-episode-7.io", episodePath: "7-podcatcher-in-the-rye", complete: { (podcastEmbed, error) in
                            title = podcastEmbed?.episode?.title
                            subtitle = podcastEmbed?.episode?.subtitle
                            number = podcastEmbed?.episode?.number
                        })
                        expect(title).toEventually(equal("Podcatcher in the Rye"))
                        expect(subtitle).toEventually(equal("Wordpress-(Life-)Hacks und Statistiken Teil 3"))
                        expect(number).toEventually(equal(7))
                    }
                }
            }
            describe("extensions") {
                it("returns the correct states for all extensions") {
                    var chapterMarks, download, episodeInfo, playlist, share, transcript, subscribeBar: Bool?
                    PodigeeEmbedKit.embedDataForPodcastWith(domain: "podcast-news-embed.io") { (podcastEmbed, error) in
                        chapterMarks = podcastEmbed?.extensions.chapterMarks.disabled
                        download = podcastEmbed?.extensions.download.disabled
                        episodeInfo = podcastEmbed?.extensions.episodeInfo.disabled
                        playlist = podcastEmbed?.extensions.playlist.disabled
                        share = podcastEmbed?.extensions.share.disabled
                        transcript = podcastEmbed?.extensions.transcript.disabled
                        subscribeBar = podcastEmbed?.extensions.subscribeBar.disabled
                        
                    }
                    expect(chapterMarks).toEventually(beFalse())
                    expect(download).toEventually(beFalse())
                    expect(episodeInfo).toEventually(beFalse())
                    expect(playlist).toEventually(beFalse())
                    expect(share).toEventually(beFalse())
                    expect(transcript).toEventually(beFalse())
                    expect(subscribeBar).toEventually(beFalse())
                }
            }
        }
        
        describe("playlist") {
            it("returns the correct number of episodes") {
                var list: Playlist?
                PodigeeEmbedKit.playlistForPodcastWith(domain: "podcast-news-playlist.io", complete: { (playlist, error) in
                    list = playlist
                })
                expect(list?.episodes.count).toEventually(equal(6))
            }
            it("returns page size error for invalid page size") {
                var pageError: Error?
                PodigeeEmbedKit.playlistForPodcastWith(domain: "podcast-news-playlist.io", pageSize: -5, complete: { (playlist, error) in
                    pageError = error
                })
                expect(pageError).toEventually(matchError(PodigeeEmbedKit.PodigeeError.invalidPageSize))
            }
            it("returns offset error for invalid offset") {
                var pageError: Error?
                PodigeeEmbedKit.playlistForPodcastWith(domain: "podcast-news-playlist.io", offset: -10, complete: { (playlist, error) in
                    pageError = error
                })
                expect(pageError).toEventually(matchError(PodigeeEmbedKit.PodigeeError.invalidOffset))
            }
        }

    }
    
    private func makeDummyEpisode() -> Episode {
        return Episode(media: Episode.Media(mp3: URL(string: "https://podigee.io/file.audio")!), coverUrl: nil, title: "Title", subtitle: "Subtitle", description: "Some description", chaptermarks: [], url: URL(string: "https://podigee.io/podcast")!, transcript: nil, number: 4, duration: 1234)
    }
    
    private func stubRequests() {
        stub(condition: isHost("podcast-news-embed.io"), response: { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("podcast_news_embed.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        })
        stub(condition: isHost("podcast-news-embed-episode-7.io"), response: { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("podcast_news_embed.episode_7.json", type(of: self))!,
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

}
