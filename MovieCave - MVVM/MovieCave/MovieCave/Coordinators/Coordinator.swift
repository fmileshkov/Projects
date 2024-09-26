//
//  Coordinator.swift
//  MovieCave
//
//  Created by Admin on 20.09.23.
//

import Foundation

public protocol CoordinatableViewModel {
    /// Starts the viewModel logic
    func start()
}

public extension CoordinatableViewModel {
    func start() {}
}

class Coordinator: NSObject {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    
    /// Unique string value to identify a coordinator
    var identifier: String?
    
    weak var parentCoordinator: Coordinator?
    
    // MARK: - Initializer
    public override init() {}
    
    // MARK: - Public
    /// Starts the coordinator. This method should be overridden in each subclass.
    func start() {
        preconditionFailure("This method needs to be overridden by a concrete subclass.")
    }
    
    /// Finishes the coordinator.
    /// The base class automatically handles memory management by removing `self` from the parent coordinator's `childCoordinators` array.
    /// Subclasses should provide custom navigation actions such as pop, dismiss, etc.
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    /// Adds a child coordinator to the current `childCoordinators` array.
    /// - Parameter coordinator: The coordinator to add.
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func addChildCoordinators(_ coordinators: [Coordinator]) {
        coordinators.forEach { addChildCoordinator($0) }
    }
    
    /// Removes a child coordinator from the `childCoordinators` array if it exists.
    /// - Parameter coordinator: The coordinator to remove.
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    /// Removes all child coordinators of a specific type from the `childCoordinators` array.
    /// - Parameter type: The type by which the array is filtered.
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T == false }
    }
    
    /// Removes all child coordinators from the `childCoordinators` array.
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    /// Returns the first parent coordinator of a specific type.
    /// - Parameters:
    ///   - type: The type of the parent coordinator to search for.
    ///   - identifier: The desired identifier of the parent coordinator. (Optional)
    /// - Returns: The first parent coordinator of the specified type, or nil if not found.
    func firstParent<T: Coordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        if isCorrectCoordinator(parentCoordinator as? T, with: identifier) {
            return parentCoordinator as? T
        }
        
        return parentCoordinator?.firstParent(of: type, with: identifier)
    }
    
    /// Returns the first child coordinator of a specific type.
    /// - Parameters:
    ///   - type: The type of the child coordinator to search for.
    ///   - identifier: The desired identifier of the child coordinator. (Optional)
    /// - Returns: The first child coordinator of the specified type, or nil if not found.
    func firstChildCoordinator<T: Coordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        for coordinator in childCoordinators {
            if isCorrectCoordinator(coordinator as? T, with: identifier) {
                return coordinator as? T
            }
        }
        
        return nil
    }
    
    /// Returns the first child coordinator of a specific type recursively.
    /// - Parameters:
    ///   - type: The type of the child coordinator to search for.
    ///   - identifier: The desired identifier of the child coordinator. (Optional)
    /// - Returns: The first child coordinator of the specified type, or nil if not found.
    func firstChildCoordinatorRecursive<T: Coordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        for coordinator in childCoordinators {
            if isCorrectCoordinator(coordinator as? T, with: identifier) {
                return coordinator as? T
            }
            
            if !coordinator.childCoordinators.isEmpty {
                return coordinator.firstChildCoordinatorRecursive(of: type, with: identifier)
            }
        }
        
        return nil
    }
    
    // MARK: - Private
    /// Checks if the given coordinator is not nil (which means it is of the correct type),
    /// and then checks if the identifier is correct.
    /// - Parameters:
    ///   - coordinator: The coordinator to check.
    ///   - identifier: The desired identifier to match. (Optional)
    /// - Returns: A boolean value indicating if the coordinator is correct.
    private func isCorrectCoordinator(_ coordinator: Coordinator?, with identifier: String?) -> Bool {
        guard let coordinator = coordinator else { return false }
        
        return identifier == nil || coordinator.identifier == identifier
    }
}

extension Coordinator {
    public static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        lhs === rhs
    }
}
