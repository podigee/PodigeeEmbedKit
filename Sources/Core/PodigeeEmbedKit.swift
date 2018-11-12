//
//  PodigeeEmbedKit.swift
//  PodigeeEmbedKit
//
//  Created by Podigee on 02/10/17.
//  Copyright © 2017 podigee. All rights reserved.
//

import Foundation

/// Contains API calls to request podcast and episode embed information from Podigee.
public class PodigeeEmbedKit {
    
    public enum PodigeeError: Error {
        case invalidPodcastDomain
    }
    
    private static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    /**
     Request embed data information for a podcast. This contains information about the podcast and data for the most recent published episode.
     - Parameter domain: The domain of the podcast, e.g. `bananaland.podigee.io`.
     - Parameter complete: The closure called when the network request is finished.
     - returns: Void
    */
    public static func embedDataForPodcastWith(domain: String, complete: @escaping (_ embed: PodcastEmbed?, _ error: Error?) -> Void) {
        var components = URLComponents()
        components.host = domain
        components.path = "/embed"
        components.queryItems = [URLQueryItem(name: "context", value: "external")]
        components.scheme = "https"
        
        guard let url = components.url else {
            complete(nil, PodigeeError.invalidPodcastDomain)
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let embed = try? jsonDecoder.decode(PodcastEmbed.self, from: data) else {
                complete(nil, error)
                return
            }
            complete(embed, nil)
        }.resume()
    }
    
    /**
     Request the episode playlist for a podcast. This returns an array of episodes.
     - Parameter domain: The domain of the podcast, e.g. `bananaland.podigee.io`.
     - Parameter complete: The closure called when the network request is finished. If successfull you receive an array of episodes.
     - returns: Void
     */
    public static func playlistForPodcastWith(domain: String, complete: @escaping (_ episodes: Episodes?, _ error: Error?) -> Void) {
        var components = URLComponents()
        components.host = domain
        components.path = "/embed/playlist"
        components.queryItems = [URLQueryItem(name: "context", value: "external")]
        components.scheme = "https"
        
        guard let url = components.url else {
            complete(nil, PodigeeError.invalidPodcastDomain)
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let embed = try? jsonDecoder.decode(Episodes.self, from: data) else {
                complete(nil, error)
                return
            }
            complete(embed, nil)
        }.resume()
    }
    
    
}
