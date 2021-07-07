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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell") as! ThemeCell
        cell.label.text = themesArray[indexPath.row].title
        return cell
    }

}
