// NotificationManager.swift - Create this new file
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func schedulePriceAlert(symbol: String, price: Double, isAbove: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "Price Alert: \(symbol)"
        content.body = "\(symbol) is now \(isAbove ? "above" : "below") $\(String(format: "%.2f", price))"
        content.sound = UNNotificationSound.default
        
        // For demo purposes, trigger after 5 seconds
        // In a real app, this would be triggered by price checks
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "priceAlert-\(symbol)-\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
