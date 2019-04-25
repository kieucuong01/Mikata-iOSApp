//
//  ConfirmImagePopupVIew.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/15/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ConfirmImagePopupViewDelegate: class {
    func didConfirmSelectedImage(popup: ConfirmImagePopupVIew, imageSelected: UIImage)
}

class ConfirmImagePopupVIew: UIView {
    // Delegate
    weak var delegate: ConfirmImagePopupViewDelegate? = nil

    // Subviews
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    // Variables
    var parentView: UIView? = nil
    var frameCurrent: CGRect = CGRect.zero

    // MARK: - View Lifecycle

    override init(frame: CGRect) {
        self.frameCurrent = frame
        self.frameCurrent.origin = CGPoint.zero

        // Call super
        super.init(frame: frame)

        // Configure self
        self.configureSelf()

        // Configure subviews
        self.configureSubviews()

        // Disable multi touch
        self.enableExclusiveTouchForViewAndSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    func configureSelf() {
        // Configure self
        Bundle.main.loadNibNamed(String(describing: ConfirmImagePopupVIew.self), owner: self, options: nil)
        self.titleLabel.text = NSLocalizedString("confirmimagepopup_label_title", comment: "")
        self.cancelButton.setTitle(NSLocalizedString("common_button_cancel", comment: ""), for: .normal)
        self.addSubview(self.mainView)
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    func configureSubviews() {
        // Configure subviews
        self.configureMainView()
        self.configureContainerView()
        self.configureTitleLabel()
        self.configureConfirmImageView()
    }

    /*
     * Created by: hoangnn
     * Description: Configure mainView
     */
    func configureMainView() {
        // Set attributes
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.backgroundColor = UIColor(white: 0.0, alpha: 0.55)

        // Init constraints
        let centerXConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.centerX,
                                                                       relatedBy: NSLayoutRelation.equal,
                                                                       toItem: self, attribute: NSLayoutAttribute.centerX,
                                                                       multiplier: 1.0, constant: 0.0)
        let centerYConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.centerY,
                                                                       relatedBy: NSLayoutRelation.equal,
                                                                       toItem: self, attribute: NSLayoutAttribute.centerY,
                                                                       multiplier: 1.0, constant: 0.0)
        let widthConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.width,
                                                                     relatedBy: NSLayoutRelation.equal,
                                                                     toItem: self, attribute: NSLayoutAttribute.width,
                                                                     multiplier: 1.0, constant: 0.0)
        let heightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.height,
                                                                      relatedBy: NSLayoutRelation.equal,
                                                                      toItem: self, attribute: NSLayoutAttribute.height,
                                                                      multiplier: 1.0, constant: 0.0)

        // Add constraints
        self.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
    }

    /*
     * Created by: hoangnn
     * Description: Configure containerView
     */
    func configureContainerView() {
        // Set attributes
        self.containerView.backgroundColor = UIColor.white
    }

    /*
     * Created by: hoangnn
     * Description: Configure titleLabel
     */
    func configureTitleLabel() {
        // Set attributes
        self.titleLabel.font = self.titleLabel.font.withSize(13.5 * GlobalMethod.displayScale)
    }

    /*
     * Created by: hoangnn
     * Description: Configure confirmImageView
     */
    func configureConfirmImageView() {
        // Set attributes
        self.confirmImageView.layer.borderWidth = 1.0
        self.confirmImageView.layer.borderColor = UIColor(red: 108.0/255.0, green: 80.0/255.0, blue: 50.0/255.0, alpha: 1.0).cgColor
    }

    // MARK: - Public Methods

    /*
     * Created by: hoangnn
     * Description: Show popup
     */
    func showPopup() {
        // Show popup
        self.parentView?.addSubview(self)
    }

    // MARK: - Selectors

    /*
     * Created by: hoangnn
     * Description: CancelButton action
     */
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }

    /*
     * Created by: hoangnn
     * Description: ConfirmButton action
     */
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
        if let image: UIImage = self.confirmImageView.image {
            self.delegate?.didConfirmSelectedImage(popup: self, imageSelected: image)
        }
    }
}
