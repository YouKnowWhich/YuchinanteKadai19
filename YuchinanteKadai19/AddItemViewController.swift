//
//  AddItemViewController.swift
//  YuchinanteKadai19
//  
//  Created by Yuchinante on 2024/07/01
//  
//

import UIKit

class AddItemViewController: UIViewController {
    // 追加モードと編集モードを定義する列挙体
    enum Mode {
        case add, edit(TableViewController.Item)

        var  saveButtonSegueIdentifier: String {
            switch self {
            case .add:
                return "exitFromAddBySaveSegue"
            case .edit(let oldItem):
                return "exitFromEditBySaveSegue"
            }
        }

        var cancelButtonSegueIdentifier: String {
            switch self {
            case .add:
                return "exitFromAddByCancelSegue"
            case .edit(let oldItem):
                return "exitFromEditByCancelSegue"
            }
        }
    }

    // デフォルトは追加モード
    var mode = Mode.add

    // アイテム名を入力するテキストフィールド
    @IBOutlet weak var nameTextField: UITextField!

    // 入力されたアイテム名を保持するプロパティ
    private(set) var editedItem: TableViewController.Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 変更モードの場合はテキストフィールドに既存のアイテム名を表示する
        switch mode {
        case .add:
            break
        case .edit(let item):
            nameTextField.text = item.name
        }
    }

    // セーブボタンが押されたときの処理
    @IBAction func pressSaveButton(_ sender: Any) {
        let isChecked: Bool

        switch mode {
        case .add:
            isChecked = false
        case .edit(let oldItem):
            isChecked = oldItem.isChecked
        }

        editedItem = .init(name: nameTextField.text ?? "", isChecked: isChecked)

        // セグエを実行して遷移する
        performSegue(withIdentifier: mode.saveButtonSegueIdentifier, sender: sender)
    }

    // キャンセルボタンが押されたときの処理
    @IBAction func pressCancelButton(_ sender: Any) {
        // セグエを実行して遷移する
        performSegue(withIdentifier: mode.cancelButtonSegueIdentifier, sender: sender)
    }
}
