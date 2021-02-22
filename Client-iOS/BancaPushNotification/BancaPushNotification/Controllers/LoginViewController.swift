//  LoginViewController.swift
//  BancaPushNotification
//
//  Created by Shanmugasundharam on 17/02/2021.
//
import UIKit

class LoginViewController: UIViewController {
    
    let uView  = UIView()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //background view
        view.backgroundColor = UIColor(hexString: "#f2f2f2")

        // Navigation Bar:
        navigationController?.navigationBar.barTintColor = .red
        // Navigation Bar Text:
        navigationItem.title = "Banca"
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        tabBarController?.tabBar.barTintColor = .brown
        // Tab Bar Text:
        tabBarController?.tabBar.tintColor = .yellow
        // View
        LoginUI()
        

    }
    
    func LoginUI() {
            uView.layer.backgroundColor = UIColor(hexString: "#ffffff").cgColor
            uView.layer.borderWidth = 1
            uView.layer.shadowOpacity = 10
            uView.layer.shadowOffset = .zero
            uView.layer.shadowRadius = 20
            uView.layer.cornerRadius = 10
            uView.layer.shouldRasterize = true
            uView.layer.rasterizationScale = UIScreen.main.scale
            uView.layer.shadowPath = UIBezierPath(rect: uView.bounds).cgPath
            uView.layer.borderColor = UIColor.lightText.cgColor
            view.addSubview(uView,anchors:[
                       .leading(330), .trailing(-330), .centerX(0),
                                .centerY(0),.height(400)])
       
                        let label = UILabel()
                        label.textColor  = .black
                        label.text = "Login"
                        label.font = label.font.withSize(50)
                        label.textAlignment = NSTextAlignment.center
                        label.backgroundColor = .clear
                        uView.addSubview(label, anchors:[
                                            .leading(40), .trailing(-40),.height(80),.top(20) ])
            
                    let userName = CusTextField()
                    userName.tintColor  = .black
                    //userName.beginFloatingCursor(at: 10)
                    userName.layer.cornerRadius = 10
                    userName.textColor = .black
                    userName.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                    userName.backgroundColor = UIColor(hexString: "#f2f2f2")
                    uView.addSubview(userName, anchors:[
                                        .leading(50), .trailing(-50),.height(60),.top(120)])
    
                    let passWord = CusTextField()
                    passWord.tintColor  = .black
                    passWord.layer.cornerRadius = 10
                    passWord.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                    passWord.backgroundColor = UIColor(hexString: "#f2f2f2")
                    uView.addSubview(passWord, anchors:[ .leading(50), .trailing(-50), .height(60),.top(200)])
            
                    let butons = UIButton()
                    butons.setTitle("Login", for: .normal)
                    butons.setTitleColor(.white,for: .normal)
                    butons.addTarget(self,action: #selector(buttonAction),for: .touchUpInside)
                    butons.backgroundColor = UIColor(hexString: "#ff3333")
                    butons.layer.cornerRadius = 10
                    uView.addSubview(butons, anchors:[ .leading(50), .trailing(-50), .centerY(150), .height(60)])
            
    }
    
    
//

    @objc
    func buttonAction(){
        let homeView = ViewController()
        navigationController?.pushViewController(homeView, animated:true)
        print("Button pressed")
    }
}
