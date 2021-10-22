//
//  ThemesPopOverViewController.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/9/21.
//

import UIKit

class ThemesPopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    let themesArray = [
        (title:"iOS", theme: CalcTheme.iOS),
        (title: "Classic", theme: CalcTheme.classic)
    ]
    
    var observer: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        observer = UserDefaults.standard.observe(\.theme, options: [.initial, .new, .old], changeHandler: { defaults, _ in
            Themer.shared?.theme = defaults.theme
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        observer?.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell") as! ThemeCell
        cell.label.text = themesArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.theme = themesArray[indexPath.row].theme
        self.dismiss(animated: true)
    }

}

