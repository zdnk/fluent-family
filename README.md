# Family

Family is extension for your models to simply "pre-fetch" relationships on Arrays of your models.

## Example

**Video.swift**
```swift
import Vapor
import FluentPostgreSQL
import Family


struct Video: PostgreSQLModel, RelationshipFetching { // <=== Your model needs to conform to RelationshipFetching to work
    var id: Int?
    let languageId: Int
    let url: String
    
    var relationshipCache = RelationshipCache() // <=== The only requirement of RelationshipFetching protocol
}

extension Video {
    
    var language: Parent<Video, Language> { // <=== Here is your defined relationship Video:Language (N:1)
        return parent(\.languageId)
    }
    
}

extension Video: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLDatabase.Connection) -> Future<Void> {
        return PostgreSQLDatabase.create(Video.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.languageId)
            builder.field(for: \.url)
            
            builder.reference(
                from: \.languageId,
                to: \Language.id,
                onUpdate: .cascade,
                onDelete: .cascade
            )
        }
    }
}
```

**VideoController.swift**
```swift
import Vapor
import Family

struct VideoController {

    func show(_ req: Request) throws -> Future<[Video.Output]> {
        let campaign = try req.parameters.next(Campaign.self)
        
        return try Video
            .query(on: req)
            .filter(\Video.campaignId, .equal, $0.requireID())
            .all()
            .with(\.language, on: req) // <=== You are saying that you want your models 
                                       // to also pre-fetch its Language relationship models. 
                                       // It will execute single query to fetch all Language models 
                                       // for all videos and store them in inidividual models in the 
                                       // relationshipCache property defined in the Video model
            .map { videos in
                return videos.map { video in
                    let language = try video.relationship(\.language) // <=== This is the way you access 
                                                                      // the prefetched relationship on individual models

                    let context = Video.OutputContext(languageCode: language.code)
                    return try video.output(context: context)
                }
            }
    }
    
}
```
