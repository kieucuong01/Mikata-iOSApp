//
//  DetailTimeLineViewController.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/25/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class DetailTimeLineViewController: NewBaseViewController {
    // Subviews
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    // Constraints
    @IBOutlet weak var mainImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextViewTopConstraint: NSLayoutConstraint!

    // Variables
    var timeLineObj: TimeLineObject? = nil

    // MARK: - View Lifecycle

    override func didReceiveMemoryWarning() {
        // Call super
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        // Call super
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Call super
        super.viewWillAppear(animated)

        // Hide NavBar
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true))

        // Update content
        self.updateContentWithModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Call super
        super.viewDidDisappear(animated)

        // Show NavBar
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false))
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    override func configureSelf() {
        // Call super
        super.configureSelf()
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    override func configureSubviews() {
        // Call super
        super.configureSubviews()

        // Configure subviews
        self.configureHeaderView()
        self.configureMainImageView()
        self.configureDateLabel()
        self.configureNameLabel()
        self.configureContentTextView()
    }

    /*
     * Created by: hoangnn
     * Description: Configure headerView
     */
    func configureHeaderView() {
        // Set attributes for titleLabel
        self.titleLabel.font = self.titleLabel.font.withSize(13.5 * GlobalMethod.displayScale)
        self.titleLabel.text = nil
    }

    /*
     * Created by: hoangnn
     * Description: Configure mainImageView
     */
    func configureMainImageView() {
        // Set attributes
        self.imageContainerViewHeightConstraint.constant = 10.0 * GlobalMethod.displayScale
    }

    /*
     * Created by: hoangnn
     * Description: Configure dateLabel
     */
    func configureDateLabel() {
        // Set attributes
        self.dateLabel.font = self.dateLabel.font.withSize(12.0 * GlobalMethod.displayScale)
        self.dateLabel.text = nil
    }

    /*
     * Created by: hoangnn
     * Description: Configure nameLabel
     */
    func configureNameLabel() {
        // Update constraint
        self.nameLabelTopConstraint.constant = 10.0 * GlobalMethod.displayScale

        // Set attributes
        self.nameLabel.font = self.nameLabel.font.withSize(13.5 * GlobalMethod.displayScale)
        self.nameLabel.text = nil
    }

    /*
     * Created by: hoangnn
     * Description: Configure contentTextView
     */
    func configureContentTextView() {
        // Update constraint
        self.contentTextViewTopConstraint.constant = 10.0 * GlobalMethod.displayScale

        // Set attributes
        self.contentTextView.font = self.contentTextView.font?.withSize(12.0 * GlobalMethod.displayScale)
        self.contentTextView.text = nil
        self.contentTextView.isEditable = false
        self.contentTextView.dataDetectorTypes = .all
        self.contentTextView.textContainer.lineBreakMode = .byTruncatingTail
        self.contentTextView.contentInset = UIEdgeInsets.zero
        self.contentTextView.textContainer.lineFragmentPadding = 0.0
        self.contentTextView.textContainer.maximumNumberOfLines = 0
    }

    // MARK: - Update Configure

    /*
     * Created by: hoangnn
     * Description: Update content with model
     */
    func updateContentWithModel() {
        // Check nil
        if self.timeLineObj != nil {
            // TitleLabel
            self.titleLabel.text = self.timeLineObj?.name

            // Image
            self.mainImageView.setImageForm(urlString: self.timeLineObj?.image_url, placeHolderImage: nil, completion: {
                self.view.layoutIfNeeded()
                if (self.mainImageView.image?.size == nil) || (self.mainImageView.image?.size == CGSize.zero) || (self.mainImageView.image?.size.width == 0.0) {
                    self.mainImageViewHeightConstraint.constant = 9.0 * GlobalMethod.displayScale
                }
                else {
                    let ratioHeightImageSize: CGFloat = (self.mainImageView.image?.size)!.height / (self.mainImageView.image?.size)!.width
                    self.mainImageViewHeightConstraint.constant = self.mainImageView.frame.size.width * ratioHeightImageSize
                }
            })

            // Date
            if let time:Double = Double(self.timeLineObj!.display_end_date) {
                let date = Date(timeIntervalSince1970:time)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                self.dateLabel.text = dateFormatter.string(from: date)
            }

            // Name
            self.nameLabel.text = self.timeLineObj?.name

            // Content
            self.contentTextView.text = self.timeLineObj?.descriptionTimeLineHTMLString
        }

        self.view.layoutIfNeeded()
    }

    // MARK: - Selectors

    /*
     * Created by: hoangnn
     * Description: backButton action
     */
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
