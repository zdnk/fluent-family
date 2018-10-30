import Vapor
import Fluent

extension Collection where Element: RelationshipFetching & Model, Element.ID: Hashable {
    
    public func with<M>(
        _ keyPath: KeyPath<Element, Parent<Element, M>>,
        on connectable: DatabaseConnectable
    ) throws -> Future<[Element]> where M: Model {
        if count == 0 {
            return connectable.eventLoop.newSucceededFuture(result: Array(self))
        }
        
        let ids = self.map { $0[keyPath: keyPath].parentID }
        let parents = M.query(on: connectable)
            .filter(M.idKey ~~ ids)
            .all()
        
        return parents.map { parents in
            var elements = Array(self)
            
            for (index, element) in elements.enumerated() {
                let optionalParent = try parents.first {
                    return try $0.requireID() == element[keyPath: keyPath].parentID
                }
                
                guard let parent = optionalParent else {
                    throw Abort(.notFound)
                }
                
                elements[index].relationshipCache.set(keyPath, to: parent)
            }
            
            return elements
        }
    }
    
}
