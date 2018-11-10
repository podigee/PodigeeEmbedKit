//
//  Model.swift
//  PodigeeEmbedKit-iOS
//
//  Created by Stefan Trauth on 10.11.18.
//  Copyright © 2018 podigee. All rights reserved.
//

import Foundation

public struct Playlist: Codable {
    let episodes: Episodes
}

public struct PodcastEmbed: Codable {
    public let episode: Episode
    public let podcast: Podcast
    public let extensions: Extensions
    public let options: Options
}

public typealias Episodes = [Episode]
public struct Episode: Codable {
    public let media: Media
    public let coverUrl: URL
    public let title: String
    public let subtitle: String
    public let description: String
    public let chaptermarks: [Chaptermark]
    public let url: URL
    public let transcript: URL
    public let number: Int
    public let duration: Int
    
    public struct Chaptermark: Codable {
        public let title: String
        public let start: String
    }
    
    public struct Media: Codable {
        public let mp3: URL
        public let aac: URL
        public let vorbis: URL
        public let opus: URL
    }
}

public struct Podcast: Codable {
    public let feed: URL
    public let title: String
    public let subtitle: String
    public let episodes: URL
    public let url: URL
    public let connections: Connections
    public let language: String
    
    public struct Connections: Codable {
        public let itunes: URL
        public let spotify: URL
    }
}


public struct Extensions: Codable {
    public struct ChapterMarks: Codable {
        public let disabled: Bool
    }
    public let chapterMarks: ChapterMarks
    public struct Download: Codable {
        public let disabled: Bool
    }
    public let download: Download
    public struct EpisodeInfo: Codable {
        public let disabled: Bool
    }
    public let episodeInfo: EpisodeInfo
    public struct Playlist: Codable {
        public let disabled: Bool
    }
    public let playlist: Playlist
    public struct Share: Codable {
        public let disabled: Bool
    }
    public let share: Share
    public struct Transcript: Codable {
        public let disabled: Bool
    }
    public let transcript: Transcript
    public struct SubscribeBar: Codable {
        public let disabled: Bool
    }
    public let subscribeBar: SubscribeBar
    private enum CodingKeys: String, CodingKey {
        case chapterMarks = "ChapterMarks"
        case download = "Download"
        case episodeInfo = "EpisodeInfo"
        case playlist = "Playlist"
        case share = "Share"
        case transcript = "Transcript"
        case subscribeBar = "SubscribeBar"
    }
}

public struct Options: Codable {
    public let theme: String
}
