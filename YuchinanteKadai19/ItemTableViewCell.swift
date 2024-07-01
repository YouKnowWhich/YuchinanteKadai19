//
//  ItemTableViewCell.swift
//  YuchinanteKadai19
//  
//  Created by Yuchinante on 2024/07/02
//  
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    // アイテム名が選択されているかを表示する画像ビュー
    @IBOutlet weak var checkImageView: UIImageView!

    // アイテム名を表示するラベル
    @IBOutlet weak var nameLabel: UILabel!

    // セルの表示を設定するメソッド
    func configure(item: TableViewController.Item) {
        if item.isChecked {
            checkImageView.image = UIImage(named: "check")  // チェックマークの画像を表示
        } else {
            checkImageView.image = nil  // チェックマークの画像を非表示
        }
        // ラベルにアイテム名を表示
        nameLabel.text = item.name
    }
}
