//
//  UITextField+Combine+Publisher.swift
//  MovieCave
//
//  Created by Admin on 24.01.24.
//

import Combine
import UIKit


extension UITextField {
    
    /// A computed property that returns a `TextFieldPublisher` for the text field.
    /// The `publisher` property allows you to access a publisher that emits the text value of the text field whenever it changes.
    var publisher: Publishers.TextFieldPublisher {
        return Publishers.TextFieldPublisher(textField: self)
    }
}

extension Publishers {
    struct TextFieldPublisher: Publisher {
        typealias Output = String
        typealias Failure = Never
        
        private let textField: UITextField
        
        init(textField: UITextField) { self.textField = textField }
        
        
        /// A method that allows a subscriber to receive values from the publisher.
        /// - Parameter subscriber: The subscriber that will receive the values emitted by the publisher.
        func receive<S>(subscriber: S) where S : Subscriber, Publishers.TextFieldPublisher.Failure == S.Failure, Publishers.TextFieldPublisher.Output == S.Input {
            let subscription = TextFieldSubscription(subscriber: subscriber, textField: textField)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class TextFieldSubscription<S: Subscriber>: Subscription where S.Input == String, S.Failure == Never  {
        
        private var subscriber: S?
        private weak var textField: UITextField?
        
        init(subscriber: S, textField: UITextField) {
            self.subscriber = subscriber
            self.textField = textField
            subscribe()
        }
        
        
        /// Informs the publisher of the subscriber's demand for values.
        /// - Parameter demand: The demand requested by the subscriber.
        func request(_ demand: Subscribers.Demand) { }
        
        
        /// Cancels the subscription, releasing any resources associated with it.
        func cancel() {
            subscriber = nil
            textField = nil
        }
        
        
        /// Sets up the subscription to listen for text changes in the text field.
        private func subscribe() {
            textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }

        
        /// A target action method called when the text field's text changes.
        /// - Parameter textField: The text field that triggered the event.
        @objc private func textFieldDidChange(_ textField: UITextField) {
            _ = subscriber?.receive(textField.text ?? "")
        }
    }
}
