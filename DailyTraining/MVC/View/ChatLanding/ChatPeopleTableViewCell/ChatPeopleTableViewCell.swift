//
//  ChatPeopleTableViewCell.swift
//  DailyTraining
//
//  Created by John Andrew Daugdaug on 7/2/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import UIKit

class ChatPeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var viewCountBg: UIView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var chatPhoto: UserProfilePhotoView!
    @IBOutlet weak var btnCheckmark: UIButton!
    
    @IBOutlet weak var viewPhotoBox: UIView!
    @IBOutlet weak var viewOnlineIndicatorBox: UIView!
    @IBOutlet weak var viewTitleBox: UIView!
    @IBOutlet weak var viewTitleBox2: UIView!

    
    static let HEIGHT = CGFloat(102.0)

    var isOnline: Bool = false {
        didSet {
            viewCountBg.backgroundColor = isOnline ? .green : .lightGray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewTitleBox.backgroundColor = .clear
        viewTitleBox2.backgroundColor = .clear
        viewOnlineIndicatorBox.backgroundColor = .clear
        viewPhotoBox.backgroundColor = .clear
        
        viewOuter.backgroundColor = Shortcut.appDelegate.themeManager?.getPeopleBg()
        viewInner.backgroundColor = Shortcut.appDelegate.themeManager?.getPeopleItemBg()
        viewInner.curveCorners()
        isOnline = false
        viewCountBg.roundCorners()
        
		// for multiple selection
		let checkmarkImage = UIImage(named: "chat_checkmark") ?? UIImage()
		let tintableCheckmarkImage = checkmarkImage.withRenderingMode(.alwaysTemplate)
		btnCheckmark.setImage(nil, for: .normal)
		btnCheckmark.setImage(tintableCheckmarkImage, for: .selected)
		btnCheckmark.tintColor = Shortcut.appDelegate.themeManager?.getPeopleItemText()
		btnCheckmark.isSelected = false
		btnCheckmark.isHidden = true
        
        lblTitle.textColor = Shortcut.appDelegate.themeManager?.getPeopleItemText()
        lblSubTitle.textColor = Shortcut.appDelegate.themeManager?.getPeopleItemText()
		lblSubTitle.font = UIFont.setLight(fontSize: 13.0)
    }
    
    func configureView(vm: ChatPeopleVM, showStatus: Bool = true, showCheckmark: Bool = false) {
        if vm.photoUrl.count > 0 {
            chatPhoto.userChatPhotoUrl = vm.photoUrl
        }
        else {
            chatPhoto.userChatDefaultImage = true
        }
        
        lblTitle.text = vm.name
        lblSubTitle.text = vm.position
        
        self.isOnline = vm.status
        self.viewCountBg.isHidden = !showStatus
        self.btnCheckmark.isHidden = !showCheckmark
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		chatPhoto.imgvPhoto.image = nil
		
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
