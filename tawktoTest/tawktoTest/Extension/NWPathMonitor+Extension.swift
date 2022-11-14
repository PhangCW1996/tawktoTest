//
//  NWPathMonitor+Extension.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Combine
import Network

extension NWPathMonitor {
    
    struct NetworkStatusPublisher: Publisher {
        
        typealias Output = NWPath.Status
        typealias Failure = Never

        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
            
        init(monitor: NWPathMonitor, queue: DispatchQueue) {
            
            self.monitor = monitor
            self.queue = queue
        }
            
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, NWPath.Status == S.Input {
            let subscription = NetworkStatusSubscription(subscriber: subscriber, monitor: monitor, queue: queue)
            subscriber.receive(subscription: subscription)
        }
    }
        
    func publisher(queue: DispatchQueue) -> NWPathMonitor.NetworkStatusPublisher {
        
        return NetworkStatusPublisher(monitor: self, queue: queue)
    }

    class NetworkStatusSubscription<S: Subscriber>: Subscription where S.Input == NWPath.Status {
        
        private let subscriber: S?
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
        
        init(subscriber: S, monitor: NWPathMonitor, queue: DispatchQueue) {

            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }
          
        func request(_ demand: Subscribers.Demand) {
            self.monitor.pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                _ = self.subscriber?.receive(path.status)
            }
            
            self.monitor.start(queue: queue)
        }
          
        func cancel() {
            self.monitor.cancel()
        }
    }
}
