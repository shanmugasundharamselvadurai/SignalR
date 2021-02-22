//
//  ViewController.swift
//  SignalRPushnotification
//
//  Created by Shanmugasundharam on 15/02/2021.
//

import UIKit
import SwiftSignalRClient

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
       private let serverUrl = "http://0.0.0.0:5000/chat"  // /chat or /chatLongPolling or /chatWebSockets
       private let dispatchQueue = DispatchQueue(label: "SignalRPushnotification.queue.dispatcheueuq")
      
       private var chatHubConnection: HubConnection?
       private var chatHubConnectionDelegate: HubConnectionDelegate?
       private var name = ""
       private var messages: [String] = []
       private var reconnectAlert: UIAlertController?

    var sendButton: UIButton!

    var msgTextField: UITextField!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
         tableView.dataSource = self
         subviews()
         constraints()
         setupTableView()
        }
    func setupTableView() {
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
     }
    }
    extension ViewController {
        func subviews() {
            view.addSubview(tableView)
        }
        
        func constraints() {
               NSLayoutConstraint.activate([
                   tableView.topAnchor.constraint(equalTo: view.topAnchor),
                   tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                   tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                   tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
               ])
           }

    override func viewDidAppear(_ animated: Bool) {
        self.chatHubConnectionDelegate = ChatHubConnectionDelegate(controller: self)
        self.chatHubConnection = HubConnectionBuilder(url: URL(string: self.serverUrl)!)
            .withLogging(minLogLevel: .debug)
            .withAutoReconnect()
            .withHubConnectionDelegate(delegate: self.chatHubConnectionDelegate!)
            .build()
        
        self.chatHubConnection!.on(method: "NewMessage", callback: {(user: String, message: String) in
            self.appendMessage(message: "\(user): \(message)")
        })
        self.chatHubConnection!.start()

        }
        @objc func dismissOnTapOutside(){
           self.dismiss(animated: true, completion: nil)
        }
    
        @objc func buttonAction(_ sender: Any) {
        let message = msgTextField.text
        if message != "" {
            chatHubConnection?.invoke(method: "Broadcast", name, message) { error in
                if let e = error {
                    self.appendMessage(message: "Error: \(e)")
                }
            }
            msgTextField.text = ""
        }
    }

        private func appendMessage(message: String) {
            self.dispatchQueue.sync {
                self.messages.append(message)
            }
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: IndexPath(item: messages.count-1, section: 0), at: .bottom, animated: true)
        }

       fileprivate func connectionDidOpen() {
           toggleUI(isEnabled: true)
       }

        fileprivate func connectionDidFailToOpen(error: Error) {
           blockUI(message: "Connection failed to start.", error: error)
       }

       fileprivate func connectionDidClose(error: Error?) {
           if let alert = reconnectAlert {
               alert.dismiss(animated: true, completion: nil)
           }
           blockUI(message: "Connection is closed.", error: error)
       }

       fileprivate func connectionWillReconnect(error: Error?) {
           guard reconnectAlert == nil else {
               print("Alert already present. This is unexpected.")
               return
           }

           reconnectAlert = UIAlertController(title: "Reconnecting...", message: "Please wait", preferredStyle: .alert)
           self.present(reconnectAlert!, animated: true, completion: nil)
       }

       fileprivate func connectionDidReconnect() {
           reconnectAlert?.dismiss(animated: true, completion: nil)
           reconnectAlert = nil
       }

       func blockUI(message: String, error: Error?) {
           var message = message
           if let e = error {
               message.append(" Error: \(e)")
           }
           appendMessage(message: message)
           toggleUI(isEnabled: false)
       }

       func toggleUI(isEnabled: Bool) {
          // sendButton.isEnabled = isEnabled
          // msgTextField.isEnabled = isEnabled
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           var count = -1
           dispatchQueue.sync {
               count = self.messages.count
           }
           return count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let row = indexPath.row
           cell.textLabel?.text = messages[row]
            self.appDelegate?.scheduleNotification(notificationType: messages[row])
            return cell
       }
   }

   class ChatHubConnectionDelegate: HubConnectionDelegate {

       weak var controller: ViewController?

       init(controller: ViewController) {
           self.controller = controller
       }

       func connectionDidOpen(hubConnection: HubConnection) {
           controller?.connectionDidOpen()
       }

       func connectionDidFailToOpen(error: Error) {
           controller?.connectionDidFailToOpen(error: error)
       }

       func connectionDidClose(error: Error?) {
           controller?.connectionDidClose(error: error)
       }

       func connectionWillReconnect(error: Error) {
           controller?.connectionWillReconnect(error: error)
       }

       func connectionDidReconnect() {
           controller?.connectionDidReconnect()
       }
    }


