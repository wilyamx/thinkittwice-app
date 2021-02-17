//
//  ChatMembersViewController.swift
//  DailyTraining
//
//  Created by William Reña on 8/20/20.
//  Copyright © 2020 Think It Twice. All rights reserved.
//

import UIKit
import CRRefresh

class ChatMembersViewController: TITViewController, UITableViewDelegate, UITableViewDataSource {

    var members: [ChatPeopleVM] = [ChatPeopleVM]()
    var allowMultipleSelection: Bool = false
    
    public lazy var membersController = ChatPeopleController()
    
    @IBOutlet weak var tblMembers: UITableView!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Shortcut.appDelegate.themeManager?.getPeopleBg()
        
        self.tblMembers.register(UINib(nibName: "ChatPeopleTableViewCell",
                                 bundle: Bundle.main),
                           forCellReuseIdentifier: String(describing: ChatPeopleTableViewCell.self))
        
        self.tblMembers.rowHeight = UITableView.automaticDimension
        self.tblMembers.estimatedRowHeight = 74
        self.tblMembers.separatorStyle = .none
        self.tblMembers.dataSource = self
        self.tblMembers.delegate = self
        
        self.tblMembers.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tblMembers.resetRefreshing()

            // no internet
            strongSelf.membersController.checkConnection { (disconnected, error) in
                if disconnected {
                    strongSelf.tblMembers.endPullRefreshing()
                    return
                }
            }

            strongSelf.membersController.pullDown { people in
                strongSelf.tblMembers.bounceEnabled()

                DispatchQueue.background(delay: 0.05, background: {
                    strongSelf.members = people
                }) {
                    strongSelf.tblMembers.reloadData()
                    strongSelf.tblMembers.endPullRefreshing()
                }
            }
        }
        
        self.tblMembers.cr.addFootRefresh(animator: FastAnimator()) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tblMembers.resetRefreshing()
            
            strongSelf.membersController.pullUp(
                completion: { people in
                    strongSelf.tblMembers.bounceEnabled()
                    
                    if people.count == 0 {
                        strongSelf.tblMembers.stopRefreshing()
                        strongSelf.tblMembers.endRefreshing()
                        return
                    }
                    
                    DispatchQueue.background(delay: 0.05, background: {
                        strongSelf.members = people
                    }) {
                        strongSelf.tblMembers.reloadData()
                        strongSelf.tblMembers.endRefreshing()
                    }
                }
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // no internet
        self.membersController.checkConnection { (disconnected, error) in
            if disconnected {
                self.members.removeAll()
                
                self.tblMembers.stopRefreshing()
                self.tblMembers.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Public Methods
    
    func headerRefresh() {
        self.membersController.checkConnection { (disconnected, error) in
            if disconnected {
                self.tblMembers.reloadData()
                self.tblMembers.stopRefreshing()
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.tblMembers.scrollToFirstRow(animated: false)
                    self.tblMembers.cr.beginHeaderRefresh()
                }
            }
        }
    }
    
    func backgroundRefresh() {
        self.membersController.pullDown { people in
            DispatchQueue.background(delay: 0.05, background: {
                self.members = people
            }) {
                self.tblMembers.reloadData()
            }
        }
    }
    
    // MARK: - Private Methods
    
    func getSelectedMembers() -> [ChatPeopleVM] {
        return self.members.filter({$0.isSelected == true})
    }
    
	func selectedMembersId() -> [String] {
		return self.getSelectedMembers().map({ $0.userId })
	}
	
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.members.count == 0 {
            tableView.setEmptyMessage(message: "no_users_available".localized())
        }
        else {
            tableView.restoreFromEmptyMessage()
        }
        return self.members.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _ = ChatManager.userId else { return UITableViewCell() }

		let item = self.members[indexPath.row]
		
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChatPeopleTableViewCell.self),
            for: indexPath) as! ChatPeopleTableViewCell

        if item.isKind(of: ChatPeopleVM.self) {
            cell.configureView(vm: self.members[indexPath.row],
                               showStatus: false,
                               showCheckmark: self.allowMultipleSelection)
            cell.selectionStyle = .none
			cell.btnCheckmark.isSelected = item.isSelected
        }
		
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.members[indexPath.row]
        if item.isKind(of: ChatPeopleVM.self) {
            return ChatPeopleTableViewCell.HEIGHT
        }

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentUserId = ChatManager.userId else { return }

        let user = self.members[indexPath.row]

        if user.userId != currentUserId {
            user.isSelected = !user.isSelected
            tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
