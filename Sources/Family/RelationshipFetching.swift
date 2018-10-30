import Foundation
import Vapor

public typealias RelationshipCache = Extend

public protocol RelationshipFetching {
    
    var relationshipCache: RelationshipCache { get set }
    
}

extension RelationshipFetching where Self: Extendable {
    
    public var relationshipCache: RelationshipCache {
        get {
            return extend
        }
        
        set {
            extend = newValue
        }
    }
    
}
