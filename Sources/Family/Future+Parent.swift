import Vapor
import Fluent

extension Future where T: Collection, T.Element: Model & RelationshipFetching, T.Element.ID: Hashable {

    public func with<P>(
        _ keyPath: KeyPath<T.Element, Parent<T.Element, P>>,
        on connectable: DatabaseConnectable
    ) throws -> Future<[T.Element]> where P: Model {
        return flatMap {
            try $0.with(keyPath, on: connectable)
        }
    }
    
}
