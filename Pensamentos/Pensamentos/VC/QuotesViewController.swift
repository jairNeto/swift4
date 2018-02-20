//
//  QuotesViewController.swift
//  Pensamentos
//
//  Created by Jair Guedes Ferreira Neto on 29/1/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    @IBOutlet weak var ivPhotobg: UIImageView!
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var labelQuotes: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var ctTop: NSLayoutConstraint!
    
    let quoteManager = QuoteManeger()
    let config = Configuration.shared
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
            self.formatView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareQuote()
    }
    
    func formatView() {
        view.backgroundColor = config.colorScheme == 0 ? .white : UIColor(red: 156.0/255.0, green: 68.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        labelQuotes.textColor = config.colorScheme == 0 ? .black : .white
        labelAuthor.textColor = config.colorScheme == 0 ? UIColor(red: 192.0/255.0, green: 96.0/255.0, blue: 49.0/255.0, alpha: 1.0) : .yellow
        prepareQuote()
    }
    
    func prepareQuote() -> Void {
        timer?.invalidate()
        if config.autoRefresh {
            timer = Timer.scheduledTimer(withTimeInterval: config.timeInterval, repeats: true) { (timer) in
                self.showRandomQuote()
            }
        }
        showRandomQuote()
    }
    
    func showRandomQuote() {
        let quotes = quoteManager.getRandomQuote()
        
        labelQuotes.text = quotes.quote
        labelAuthor.text = quotes.author
        ivPhoto.image = UIImage(named: quotes.image)
        ivPhotobg.image = ivPhoto.image
        
        labelQuotes.alpha = 0.0
        labelAuthor.alpha = 0.0
        ivPhoto.alpha = 0.0
        ivPhotobg.alpha = 0.0
        ctTop.constant = 50
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.5) {
            self.labelQuotes.alpha = 1.0
            self.labelAuthor.alpha = 1.0
            self.ivPhoto.alpha = 1.0
            self.ivPhotobg.alpha = 0.25
            self.ctTop.constant = 10
            self.view.layoutIfNeeded()
        }
    }

}
