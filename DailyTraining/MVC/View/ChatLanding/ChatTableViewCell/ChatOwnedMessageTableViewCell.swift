//
//  ChatOwnedMessageTableViewCell.swift
//  DailyTraining
//
//  Created by William Reña on 7/16/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import UIKit



class ChatOwnedMessageTableViewCell: BaseChatMessageTableViewCell {

    static let HEIGHT = CGFloat(60.0)
    static let HEIGHT_MIN = CGFloat(35.0)
	

    @IBOutlet weak var messageBoxTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewMessageBox.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatSenderBg()
        self.lblMessage.textColor = Shortcut.appDelegate.themeManager?.getMainChatSenderText()
		self.lblMessage.urlDetectorWithCustomColor(color: Shortcut.appDelegate.themeManager?.getMainChatSenderText() ?? .white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configureView(vm: ChatMessageVM, showMessageGrouping: Bool? = true) {
        super.configureView(vm: vm, showMessageGrouping: showMessageGrouping)
        
        // regular attributes for sender details
        let messageCreated = vm.messageCreated.toDate().formatChatMessageCreate()
        let senderDetails = "\(messageCreated)"
        
        let messageCreatedRange = (senderDetails as NSString).range(of: messageCreated)
        
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.setRegular(fontSize: 10.0),
            NSAttributedString.Key.foregroundColor: Shortcut.appDelegate.themeManager?.getMainChatSubContent()
        ]
        
        let attributedString = NSMutableAttributedString(string: senderDetails)
        attributedString.addAttributes(regularAttribute as [NSAttributedString.Key : Any], range: messageCreatedRange)
        
        self.lblSenderDetails.attributedText = attributedString
        
        // show/hide for no message grouping
        if let showStatus = showMessageGrouping {
            self.lblSenderDetails.isHidden = !showStatus
            
            if showStatus {
                self.messageBoxTopConstraint.constant = 27
            }
            else {
                self.messageBoxTopConstraint.constant = 5
            }
        }
        
        // admin message
        if vm.userId.count == 0 && vm.name.count == 0 {
            self.viewMessageBox.backgroundColor = ChatManager.ADMIN_MESSAGE_BG_COLOR
        }
        else {
            self.viewMessageBox.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatSenderBg()
			
			// editing mode
			if let isEditing = vm.isEditable, isEditing == true {
				self.viewMessageBox.backgroundColor = .lightGray
			}
        }
		
    }

}
