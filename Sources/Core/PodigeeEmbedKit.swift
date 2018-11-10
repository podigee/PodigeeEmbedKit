//
//  PodigeeEmbedKit.swift
//  PodigeeEmbedKit
//
//  Created by Podigee on 02/10/17.
//  Copyright © 2017 podigee. All rights reserved.
//

import Foundation

public class PodigeeEmbedKit {
    
    private static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    public static func embedDataForPodcastWith(domain: String, complete: @escaping (_ embed: PodcastEmbed?, _ error: Error?) -> Void) {
        var components = URLComponents()
        components.host = domain
        components.path = "embed"
        components.queryItems = [URLQueryItem(name: "context", value: "external")]
        components.scheme = "https"
        
        guard let url = components.url else {
            #warning("return invalid domaint error")
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
    
    public static func playlistForPodcastWith(domain: String, complete: @escaping (_ episodes: Episodes?, _ error: Error?) -> Void) {
        var components = URLComponents()
        components.host = domain
        components.path = "embed/playlist"
        components.queryItems = [URLQueryItem(name: "context", value: "external")]
        components.scheme = "https"
        
        guard let url = components.url else {
            #warning("return invalid domaint error")
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
