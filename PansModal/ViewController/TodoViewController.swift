//
//  TodoViewController.swift
//  PansModal
//
//  Created by Serkan Mehmet Malagiç on 26.01.2022.
//

import UIKit
import SnapKit

class TodoViewController: UIViewController {

    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    private var todoViewModel = TodoViewModel()

    let refreshControl = UIRefreshControl()
    
    lazy var panView : UIView = {
       let panview = UIView()
        panview.backgroundColor = UIColor.init(displayP3Red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        panview.layer.cornerRadius = 4
        return panview
    }()
    
    lazy var headerLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Get values from web service"
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = UIFont(name: "Avenir", size: 35)
        return lbl
    }()
    
    lazy var tableView : UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .lightGray
        tableView.layer.cornerRadius = 15
        tableView.layer.borderWidth = 0.5
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBindings()

        setUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Fetch"
    }
    
    private func setUpBindings() {
                
        todoViewModel.todos.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        todoViewModel.title.listen {
            print("value has been changed \($0)")
        }
        
        todoViewModel.backgroundColor.listen { color in
            self.view.backgroundColor = color
        }
        
        let activityView = self.view.createSpinner()
        
        todoViewModel.isLoading.listen { val in
            if val { activityView.startAnimating() }
            else   { activityView.stopAnimating() }
        }
        
    }
    
    func setUI () {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        self.hideKeyboardWhenTappedAround()

        navigationController?.navigationBar.topItem?.title = "Fetch"
        
        view.addSubview(panView)
        view.addSubview(tableView)
        view.addSubview(headerLbl)

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        panView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(5)
        }
        headerLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerLbl.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        todoViewModel.fetchData(vc: self)
        
    }

    @objc func refresh(_ sender: AnyObject) {
        todoViewModel.fetchData(vc: self)
        refreshControl.endRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
}

extension TodoViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                
        let todos = todoViewModel.todos.value

        cell.textLabel?.text = todos?[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoViewModel.getTodosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            
            let alert = UIAlertController(title: "Are you sure to delete?", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("deleted")
                    self.todoViewModel.todos.value?.remove(at: indexPath.row)
                }))
                alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
