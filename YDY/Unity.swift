//
//  Unity.swift
//  YDY
//
//  Created by David Spurlock on 11/21/22.
//  Copyright © 2022 GST.PID. All rights reserved.
//

import Foundation
import UnityFramework

class Unity: UIResponder, UIApplicationDelegate {

    static let shared = Unity()

    private let dataBundleId: String = "com.unity3d.framework"
    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"

    private var ufw : UnityFramework?
    private var hostMainWindow : UIWindow?

    private var isInitialized: Bool {
        ufw?.appController() != nil
    }
    
    private struct UnityMessage {
            let objectName: String?
            let methodName: String?
            let messageBody: String?
    }

    func show() {
        if isInitialized {
            showWindow()
        } else {
            initWindow()
        }
    }

    func setHostMainWindow(_ hostMainWindow: UIWindow?) {
        self.hostMainWindow = hostMainWindow
    }
    
    func sendMessage(
            _ objectName: String,
            methodName: String,
            message: String
        ) {
            let msg: UnityMessage = UnityMessage(
                objectName: objectName,
                methodName: methodName,
                messageBody: message
            )

            // Send the message right away if Unity is initialized, else cache it
            if isInitialized {
                ufw?.sendMessageToGO(
                    withName: msg.objectName,
                    functionName: msg.methodName,
                    message: msg.messageBody
                )
            }
//            else {
//                cachedMessages.append(msg)
//            }
        }

    private func initWindow() {
        if isInitialized {
            showWindow()
            return
        }

        guard let ufw = loadUnityFramework() else {
            print("ERROR: Was not able to load Unity")
            return unloadWindow()
        }

        self.ufw = ufw
        ufw.setDataBundleId(dataBundleId)
        ufw.register(self)
        ufw.runEmbedded(
            withArgc: CommandLine.argc,
            argv: CommandLine.unsafeArgv,
            appLaunchOpts: nil
        )
    }

    private func showWindow() {
        if isInitialized {
            ufw?.showUnityWindow()
        }
    }

    private func unloadWindow() {
        if isInitialized {
            ufw?.unloadApplication()
        }
    }
    
    func UnloadUnity(){
        if isInitialized {
            ufw?.unloadApplication()
        }
    }
    
    func QuitUnity(){
        if isInitialized {
            ufw?.quitApplication(0)
        }
    }
    
    

    private func loadUnityFramework() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + frameworkPath

        let bundle = Bundle(path: bundlePath)
        if bundle?.isLoaded == false {
            bundle?.load()
        }

        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
            machineHeader.pointee = _mh_execute_header

            ufw?.setExecuteHeader(machineHeader)
        }
        return ufw
    }
    
    
}

extension Unity: UnityFrameworkListener {

    func unityDidUnload(_ notification: Notification!) {
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
        hostMainWindow?.makeKeyAndVisible()
    }
}
