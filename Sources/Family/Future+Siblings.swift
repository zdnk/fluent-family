import Fluent

extension Future where T: Collection, T.Element: Model & RelationshipFetching, T.Element.ID: Hashable {
    
    public func with<Sibling, P>(
        _ keyPath: KeyPath<T.Element, Siblings<T.Element, Sibling, P>>,
        on connectable: DatabaseConnectable
    ) throws -> Future<[T.Element]> where Sibling.ID: Hashable, P: Pivot, P.Left == T.Element, P.Right == Sibling {
        return flatMap {
            try $0.with(keyPath, on: connectable)
        }
    }
    
}
