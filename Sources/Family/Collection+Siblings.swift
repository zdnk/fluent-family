import Fluent
import Async

extension Collection where Element: RelationshipFetching & Model, Element.ID: Hashable {
    
    public func with<Sibling, P>(
        _ keyPath: KeyPath<Element, Siblings<Element, Sibling, P>>,
        on connectable: DatabaseConnectable
    ) throws -> Future<[Element]> where Sibling.ID: Hashable, P: Pivot, P.Left == Element, P.Right == Sibling {
        if count == 0 {
            return connectable.eventLoop.newSucceededFuture(result: Array(self))
        }
        
        let leftIds = try self.map { try $0.requireID() }
        let mappings = P.query(on: connectable)
            .filter(P.leftIDKey ~~ leftIds)
            .all()
        
        let rightIds = mappings.map { mappings in
            return mappings.map { $0[keyPath: P.rightIDKey] }
        }
        
        let siblings = rightIds.flatMap { ids in
            return Sibling.query(on: connectable)
                .filter(Sibling.idKey ~~ ids)
                .all()
        }
        
        return Async.map(mappings, siblings) { (pivots, siblings) -> ([Element]) in
            var elements = Array(self)
            let grouped = [Element.ID: [P]](grouping: pivots, by: { $0[keyPath: P.leftIDKey] })
            
            for (index, element) in elements.enumerated() {
                let pivs = grouped[try element.requireID()] ?? []
                let ids = pivs.map { $0[keyPath: P.rightIDKey] }
                let sibs = try siblings.filter { try ids.contains($0.requireID()) }
                
                elements[index].relationshipCache.set(keyPath, to: sibs)
            }
            
            return elements
        }
    }
    
}
