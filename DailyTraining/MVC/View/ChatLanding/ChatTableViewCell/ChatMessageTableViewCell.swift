//
//  ChatMessageTableViewCell.swift
//  DailyTraining
//
//  Created by William Reña on 7/15/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: BaseChatMessageTableViewCell {

    static let HEIGHT = CGFloat(60.0)
    static let HEIGHT_MIN = CGFloat(40.0)
    
    @IBOutlet weak var imgSender: UIImageView!
    @IBOutlet weak var messageBoxTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgFile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // make rounded
        self.imgSender.setCircularProperties()
      
        self.viewMessageBox.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatRecipientBg()
        self.lblMessage.textColor = Shortcut.appDelegate.themeManager?.getMainChatRecipientText()
		self.lblMessage.urlDetectorWithCustomColor(color: Shortcut.appDelegate.themeManager?.getMainChatRecipientText() ?? .black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configureView(vm: ChatMessageVM, showMessageGrouping: Bool? = true) {
        super.configureView(vm: vm, showMessageGrouping: showMessageGrouping)
        
        // regular attributes for sender details
        let messageCreated = vm.messageCreated.toDate().formatChatMessageCreate()
        let senderDetails = "\(vm.name)  \(messageCreated)"

        let senderRange = (senderDetails as NSString).range(of: vm.name)
        let messageCreatedRange = (senderDetails as NSString).range(of: messageCreated)
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.setMedium(fontSize: 12.0),
            NSAttributedString.Key.foregroundColor: Shortcut.appDelegate.themeManager?.getMainChatContent()
        ]
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.setRegular(fontSize: 10.0),
            NSAttributedString.Key.foregroundColor: Shortcut.appDelegate.themeManager?.getMainChatSubContent()
        ]
        
        let attributedString = NSMutableAttributedString(string: senderDetails)
        attributedString.addAttributes(boldAttribute as [NSAttributedString.Key : Any], range: senderRange)
        attributedString.addAttributes(regularAttribute as [NSAttributedString.Key : Any], range: messageCreatedRange)
        
        self.lblSenderDetails.attributedText = attributedString
        
        if vm.photoUrl.count > 0 {
            self.imgSender.chatProfileLoadFromUrl(
                imageUrl: vm.photoUrl,
                bgColor: Shortcut.appDelegate.themeManager?.getMainChatRecipientBg(),
                isCircularView: true
            )
        }
        else {
            let coverImage = UIImage(named: "chat_user_small") ?? UIImage()
            let tintableImage = coverImage.withRenderingMode(.alwaysTemplate)

            self.imgSender.contentMode = .center
            self.imgSender.image = tintableImage
            self.imgSender.tintColor = Shortcut.appDelegate.themeManager?.getChatPhIcon()
            self.imgSender.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatRecipientBg()
        }

        if vm.fileUrl.count > 0 {
            self.imgFile.loadFromUrl(imageUrl: vm.fileUrl)
            self.imgFile.isHidden = false;
        }else {
            self.imgFile.isHidden = true;
        }
        
        // show/hide for no message grouping
        if let showStatus = showMessageGrouping {
            self.lblSenderDetails.isHidden = !showStatus
            self.imgSender.isHidden = !showStatus
            
            if showStatus {
                self.messageBoxTopConstraint.constant = 30
            }
            else {
                self.messageBoxTopConstraint.constant = 5
            }
        }
        
        // admin message
        if vm.userId.count == 0 && vm.name.count == 0 {
            self.viewMessageBox.backgroundColor = ChatManager.ADMIN_MESSAGE_BG_COLOR
            self.lblMessage.textColor = Shortcut.appDelegate.themeManager?.getMainChatSenderText()
        }
        else {
            self.viewMessageBox.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatRecipientBg()
            self.lblMessage.textColor = Shortcut.appDelegate.themeManager?.getMainChatRecipientText()
        }
		
    }
    
}
