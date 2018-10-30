import Fluent

extension RelationshipFetching {
    
    public func relationship<M: Model>(_ keyPath: KeyPath<Self, Parent<Self, M>>) throws -> M {
        let optionalValue: M? = relationshipCache.get(keyPath, default: nil)
        guard let value = optionalValue else {
            throw NotFound()
        }
        
        return value
    }
    
}
