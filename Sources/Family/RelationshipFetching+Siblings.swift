import Vapor
import Fluent

extension RelationshipFetching {
    
    public func relationship<Sibling, P>(_ keyPath: KeyPath<Self, Siblings<Self, Sibling, P>>) throws -> [Sibling] where Sibling: Model, P: Pivot {
        let optionalValue: [Sibling]? = relationshipCache.get(keyPath, default: nil)
        guard let value = optionalValue else {
            throw Abort(.notFound)
        }
        
        return value
    }
    
}
