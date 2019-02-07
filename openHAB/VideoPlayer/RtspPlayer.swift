//

import os
import Foundation

@objc class RtspPlayer: VideoPlayer, LIFEPLAYER_AppPlayerProtocol {
    
    static let _sharedVideoPlayer = RtspPlayer()
    
    let restartTimeout = 3.0
    let startTimeout = 10.0
    let zoomLevels: [Float] = [1.0, 1.5, 2.0, 2.5, 3.0, 4.0]
    
    lazy var lpDLPlayer: LIFEPLAYER_DLPlayer = {
        return LIFEPLAYER_DLPlayer(appPlayer: self, restartTimeout: self.restartTimeout, startTimeout: self.startTimeout)
    }()
    
    var cameraDict: [String:String] = [:]
    var currentZoomIndex = 0
    let notifications = NotificationManager()
    
    @nonobjc override var currentVCPlaying: UIViewController! {
        set {
            super.currentVCPlaying = newValue
        }
        
        get {
            return super.currentVCPlaying
        }
    }
    
    @nonobjc override var viewContentMode: UIView.ContentMode {
        set {
            super.viewContentMode = newValue
        }
        
        get {
            return super.viewContentMode
        }
    }
    
    override class func shared() -> RtspPlayer {
        return _sharedVideoPlayer
    }
    
    override init() {
        if #available(iOS 10.0, *) {
            os_log("RtspPlayer: init")
        } else {
            // Fallback on earlier versions
        }
        
        super.init()
        
        viewContentMode = .scaleAspectFit
    }
    
    func mapCameraGuid(camera: String) {
        cameraDict[camera] = camera
    }
    
    func cameraForGuid(guid: String) -> String? {
        return cameraDict[guid]
    }
    
    func setCurrentCameraByGuid(_ cameraGuid: String?) {
        if let cameraGuid = cameraGuid, let camera = cameraForGuid(guid: cameraGuid) {
            currentCamera = camera
        } else {
            currentCamera = nil
        }
    }
    
    func setKeepChargedTimeout(value: Int32) {
        lpDLPlayer.setKeepChargedTimeout(value)
    }
    
    override func keepChargedTimeout() -> Int32 {
        return lpDLPlayer.keepChargedTimeout()
    }
    
    func getCurrentCameraGuid() -> String? {
        if let currentCamera = currentCamera {
            return currentCamera
        } else {
            return nil
        }
    }
    
    func setPlayerView(_ view: UIView) {
        playView = view
    }
    
    func invalidateURL(_ url: URL) {
        guard let scheme = url.scheme, scheme == "rtsps" else { return }
        
        var queryStringDictionary: [String:String] = [:]
        let urlComponents = url.absoluteString.components(separatedBy: "&")
        for keyValuePair in urlComponents {
            let pairComponents = keyValuePair.components(separatedBy: "=")
            if let key = pairComponents.first?.removingPercentEncoding, let value = pairComponents.last?.removingPercentEncoding {
                queryStringDictionary[key] = value
            }
        }
        
        guard let iiwc = queryStringDictionary["IIWC_SID"] else { return }
        let urlPart1 = url.absoluteString.components(separatedBy: "/")[1]
        let urlPart2 = url.absoluteString.components(separatedBy: "/")[2]
        let invalidateCameraSessionURL = "https://\(urlPart1)\(urlPart2)/iiwc/invalidate?IIWC_SID=\(iiwc)"
        
        guard let invalidateURL = URL(string: invalidateCameraSessionURL) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: invalidateURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func super_start(_ url: URL, on view: UIView, withCamera cameraGuid: String, andFeedVC feedVC: UIViewController) {
        
        if #available(iOS 10.0, *) {
            os_log("RtspPlayer: super_start: url = %@", url as CVarArg)
        } else {
            // Fallback on earlier versions
        }
        
        guard let camera = cameraForGuid(guid: cameraGuid) else { return }
        super.start(url, on: view, withCamera: camera, andFeedVC: feedVC)
    }
    
    func super_stop() {
        super.stop()
    }
    
    override func setUrlFetchCallback(_ urlFetchBlock: URLFetchBlock?) {
        lpDLPlayer.setUrlFetchCallback(urlFetchBlock)
    }
    
    override func precharge(_ cameraIds: [String]) {
        lpDLPlayer.precharge(cameraIds)
    }
    
    override func change(_ view: UIView, andPresentingVC vc: UIViewController) {
        lpDLPlayer.change(view, andPresentingVC: vc)
    }
    
    override func start(_ url: URL, on view: UIView, withCamera camera: String, andFeedVC feedVC: UIViewController) {
        
        if #available(iOS 10.0, *) {
            os_log("RtspPlayer: start: url = %@, camera = %@", url as CVarArg, camera)
        } else {
            // Fallback on earlier versions
        }
        
        currentZoomIndex = 0
        mapCameraGuid(camera: camera)
        lpDLPlayer.start(url, on: view, withCamera: camera, andFeedVC: feedVC)
    }
    
    override func restart(_ view: UIView, withCamera camera: String, andFeedVC feedVC: UIViewController, onfailure failureblock: (() -> Void)?) {
        
        if #available(iOS 10.0, *) {
            os_log("RtspPlayer: restart: camera = %@", camera)
        } else {
            // Fallback on earlier versions
        }
        
        currentZoomIndex = 0
        mapCameraGuid(camera: camera)
        lpDLPlayer.restart(view, withCamera: camera, andFeedVC: feedVC, onfailure: failureblock)
    }
    
    override func pause() {
        
        if #available(iOS 10.0, *) {
            os_log("RtspPlayer: pause:")
        } else {
            // Fallback on earlier versions
        }
        
        lpDLPlayer.stop(false)
    }
    
    override func stop() {
        
        if #available(iOS 10.0, *) {
            os_log("RtspPlayer: stop:")
        } else {
            // Fallback on earlier versions
        }
        
        lpDLPlayer.stop(true)
    }
    
    override func discharge() {
        
        if #available(iOS 10.0, *) {
            os_log("RtspPlayer: discharge:")
        } else {
            // Fallback on earlier versions
        }
        
        lpDLPlayer.discharge()
    }
    
    override func zoomIn() {
        if currentZoomIndex < zoomLevels.count - 1 {
            currentZoomIndex += 1
            lpDLPlayer.setZoomScale(zoomLevels[currentZoomIndex])
        }
    }
    
    override func zoomOut() {
        if currentZoomIndex > 0 {
            currentZoomIndex -= 1
            lpDLPlayer.setZoomScale(zoomLevels[currentZoomIndex])
        }
    }
    
    override func resetToZoomDefault() {
        if currentZoomIndex > 0 {
            currentZoomIndex = 0
            lpDLPlayer.setZoomScale(zoomLevels[currentZoomIndex])
        }
    }
    
    override func disableAudioStream() {
        lpDLPlayer.mute(true)
    }
    
    override func enableAudioStream() {
        lpDLPlayer.mute(false)
    }
    
    func addStartNotifications() {
        notifications.addObserverForName(.suspendMoviePlayer) {[weak self] (notification) in
            self?.stop()
        }
    }
    
    func removeStartNotifications() {
        notifications.removeObserverForName(.suspendMoviePlayer)
    }
    
    func setPlayerStateOpen() {
        playerStatus = playerStateOpen
        errorType = ""
    }
    
    func setPlayerStateBufferring() {
        playerStatus = playerStateBuffer
        errorType = ""
        notifications.postNotificationWithName(.videoStartBuffer)
    }
    
    func setPlayerStatePlaying() {
        playerStatus = playerStatePlay
        errorType = ""
        notifications.postNotificationWithName(.videoStartRender)
    }
    
    func setPlayerStateError(_ error: String) {
        playerStatus = playerStateError
        errorType = error
        playerStatus = playerStateStop
    }
    
    func setPlayerStateStopped() {
        playerStatus = playerStateStop
        errorType = ""
    }
    
//    func setViewContentMode(_ viewContentMode: UIView.ContentMode) {
//        //
//    }
//    
//    func setCurrentVCPlaying(_ vc: UIViewController!) {
//        //
//    }
}
