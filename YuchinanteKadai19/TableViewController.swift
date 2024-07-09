//
//  TableViewController.swift
//  YuchinanteKadai19
//
//  Created by Yuchinante on 2024/06/27
//
//

import UIKit

class TableViewController: UITableViewController {

    // アイテムの構造体を定義
    struct Item: Codable {
        var name: String
        var isChecked: Bool

        mutating func toggleIsChecked() {
            isChecked.toggle()
        }
    }

    // アクセサリボタンがタップされたセルのインデックスパスを保持するプロパティ
    private var editIndexPath: IndexPath?

    // アイテムの配列を保持するプロパティ
    private var items: [Item] = [] {
        didSet {
            saveItems()
        }
    }

    // 画面がロードされた時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    // セルの数を返すメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // セルを構築するメソッド
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得し、カスタムセルにダウンキャスト
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ItemTableViewCell
        // アイテムを取得
        let item = items[indexPath.row]
        // セルの表示を設定するメソッドを呼び出してセルを更新
        cell.configure(item: item)
        // 更新されたセルを返す
        return cell
    }

    // ユーザーがテーブルビューのセルを選択した時の処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // チェック状態を反転させる
        items[indexPath.row].toggleIsChecked()
        // テーブルビューのセルを再読み込みして更新する
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // アクセサリボタンがタップされた時の処理
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 編集対象のセルのインデックスパスを保持する
        editIndexPath = indexPath
        // 編集画面に遷移する
        performSegue(withIdentifier: "EditSegue", sender: indexPath)
    }

    // テーブルビューから削除する機能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // アイテムを削除する
            items.remove(at: indexPath.row)
            // テーブルビューの行を削除する
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // セグエが実行される直前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let add = (segue.destination as? UINavigationController)?.topViewController as? AddItemViewController {
            switch segue.identifier ?? "" {
            case "AddSegue":
                // 追加モードを設定する
                add.mode = .add
            case "EditSegue":
                // 編集モードを設定する
                if let indexPath = sender as? IndexPath {
                    let item = items[indexPath.row]
                    // 編集対象のアイテム名を渡す
                    add.mode = .edit(item)
                }
            default:
                break
            }
        }
    }

    // 追加モードを押されたときのボタン
    @IBAction func exitFromAddByCancel(segue: UIStoryboardSegue) {
    }

    @IBAction func exitFromAddBySave(segue: UIStoryboardSegue) {
        if let add = segue.source as? AddItemViewController {
            // アイテム名を追加する
            guard let item = add.editedItem else { return }
            items.append(item)
            let indexPath = IndexPath(row: items.count - 1, section: 0)
            // テーブルビューに行を追加する
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    // 編集モードを押されたときのボタン
    @IBAction func exitFromEditByCancel(segue: UIStoryboardSegue) {
    }

    @IBAction func exitFromEditBySave(segue: UIStoryboardSegue) {
        if let add = segue.source as? AddItemViewController {
            if let indexPath = editIndexPath {
                // アイテム名を更新する
                guard let editedItem = add.editedItem else { return }
                items[indexPath.row] = editedItem
                // テーブルビューの行を再読み込みする
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    // UserDefaultsにアイテムを保存する
    private func saveItems() {
        let defaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: "items")
        }
    }

    // UserDefaultsからアイテムを読み込む
    private func loadItems() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "items"),
           let savedItems = try? JSONDecoder().decode([Item].self, from: data) {
            items = savedItems
        }
    }
}
