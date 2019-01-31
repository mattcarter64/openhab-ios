import Foundation

enum NotificationName: String {
	case SessionRefreshed
	case pushNotificationPerformAction
	case pushNotificationPresentPushAlert
	case AlarmUIUpdateNotification
	case alarmChangingState
	case NoteThermSchedularUpdate
	case NoteThermSchedularFailedToUpdate
	case PresentNamedController
	case NotificationStopAllCameras
	case RestartCameraWidget
	case ResizeWidget
	case reloadWidget
	case updateWidgetUI
	case finishDashboardCustomization
	case resetCustomDashboard
	case dashboardDidCompleteLoading
	case deviceLogsUpdated
	case vdbLogsUpdated
	case menuHidden
	case currentController
	case loadDeviceSettings
	case updateButtonBadges
	case reloadDashboard
	case showDeviceLogMedia
	case loginComplete
	case outageDetected
	case LoggedOut = "NKey_App_Logout"
	case checkForAppReview
	case weatherDataNeedsUpdate
	case snapshotVideoCaptured
	case pushNotificationStatusChanged
	case locationServicesStatusChanged
	case videoStartBuffer
	case videoStartRender
	case suspendMoviePlayer
	case locationServicesError
    case NoteAllProgramsUpdated = "Program/All"
    case ShowCameraArchive
}

enum UserInfoKey {
	static let error = "error"
	static let region = "region"
}

class NotificationManager {
	fileprivate var observers = [String: AnyObject]()

	deinit {
		removeAllObservers()
	}

	func observerCount() -> Int {
		return observers.count
	}

	/**
	 Posts a notification with the given name and optional userInfo through the defaultCenter
	 - parameter name: NotificationName from enumeration
	 - parameter userInfo: (optional) dictionary of information to be passed in the notification
	 */
	func postNotificationWithName(_ name: NotificationName, userInfo: [AnyHashable: Any]? = nil) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: name.rawValue), object: nil, userInfo: userInfo)
	}

	/**
	 Posts a notification with the given name and optional userInfo through the defaultCenter
	 - parameter name: Name of notification that is not enumerated.
	 - parameter userInfo: (optional) dictionary of information to be passed in the notification
	 */
	func postNotificationWithName(_ name: String, userInfo: [AnyHashable: Any]? = nil) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: userInfo)
	}
	
	/**
	 Adds a notification observer with the given name and a block to perform when the notification is received
	 - parameter name: NotificationName from enumeration
	 - parameter block: code to be executed when notification is received. Notification recevied is the passed parameter.
	 */
	func addObserverForName(_ name: NotificationName, block: @escaping (Notification) -> Void) {
		// if observer is already in place for this name, remove it
		removeObserverForName(name)

		let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name.rawValue), object: nil, queue: OperationQueue.main, using: block)
		self.observers[name.rawValue] = observer
	}

	/**
	 Adds a notification observer with the given name and a block to perform when the notification is received
	 - parameter name: Name of notification that is not enumerated
	 - parameter block: code to be executed when notification is received. Notification recevied is the passed parameter.
	 */
	func addObserverForName(_ name: String, block: @escaping (Notification) -> Void) {
		// if observer is already in place for this name, remove it
		removeObserverForName(name)

		let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: nil, queue: OperationQueue.main, using: block)
		self.observers[name] = observer
	}

	/**
	 Removes a notification with the given name
	 - parameter name: NotificationName from enumeration
	 */
	func removeObserverForName(_ name: NotificationName) {
		guard let observer = self.observers[name.rawValue] else { return }

		NotificationCenter.default.removeObserver(observer)
		self.observers.removeValue(forKey: name.rawValue)
	}

	/**
	 Removes a notification with the given name
	 - parameter name: Name of notification that is not enumerated
	 */
	func removeObserverForName(_ name: String) {
		guard let observer = self.observers[name] else { return }

		NotificationCenter.default.removeObserver(observer)
		self.observers.removeValue(forKey: name)
	}

	/**
	 Removes all observers
	 */
	func removeAllObservers() {
		for observer in self.observers.values {
			NotificationCenter.default.removeObserver(observer)
		}

		self.observers = [:]
	}
}

extension NotificationCenter {
	/**
	 Posts a notification with the given name and optional userInfo through the defaultCenter
	 - parameter name: NotificationName from enumeration
	 - parameter userInfo: (optional) dictionary of information to be passed in the notification
	 */
	static func postNotificationWithName(_ name: NotificationName, userInfo: [AnyHashable: Any]? = nil) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: name.rawValue), object: nil, userInfo: userInfo)
	}
}
