//
//  ViewController.swift
//  TestNetService
//
//  Created by Naoyuki Kan on 2022/02/19.
//

import UIKit

class ViewController: UIViewController {
    var nsb: NetServiceBrowser?
    var serviceList = [NetService]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func startBrowsing() {
        nsb = NetServiceBrowser()
        nsb?.delegate = self
        nsb?.searchForServices(ofType: "_http._tcp", inDomain: "")

    }
}

extension ViewController: NetServiceDelegate, NetServiceBrowserDelegate {

    /// サービスが見つかった場合に呼ばれる
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        serviceList.append(service)
        if !moreComing {
            resolve()
        }
    }

    /// サービスが名前解決されたら呼ばれる
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("NetServiceが名前解決されました")
        print("名前は\(sender.name)")
    }


    func resolve() {
        for service in serviceList {
            if service.port == -1 {
                service.delegate = self
                service.resolve(withTimeout: 10)
            }
        }
    }

    func printServices() {
        for service in self.serviceList {
            print("")
            print("name = ", service.name)
            print("domain = ", service.domain)
            print("port = ", service.port)
            print("type = ", service.type)
            print("hostName = ", service.hostName ?? "unknown")
        }
    }
}
