//
//  AppDelegate.swift
//  LK ToDo
//
//  Created by Lívia Carvalho Keller on 12/09/2022.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // momento que o app é carregado (aberto)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // localmente onde fica salvo os dados
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }

    // app em segundo plano (quando sai do app, ou abre outro app)
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    // quando encerra o app
    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

