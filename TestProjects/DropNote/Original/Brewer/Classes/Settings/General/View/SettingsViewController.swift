//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MessageUI

extension SettingsViewController: ThemeConfigurable { }
extension SettingsViewController: ThemeConfigurationContainer { }

final class SettingsViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

    var themeConfiguration: ThemeConfiguration?
	var viewModel: TableViewConfigurable!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = tr(.settingsItemTitle)
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        
		tableView.tableFooterView = UIView()
		tableView.delegate = self
		viewModel.configureWithTableView(tableView)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settings)
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case .MethodPicker = segueIdentifierForSegue(segue) {
            let methodPickerViewController = segue.destination as! MethodPickerViewController
            methodPickerViewController.enableSwipeToBack()
            
            _ = methodPickerViewController
                .didSelectBrewMethodSubject
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: {
                    brewMethod in
                    Analytics.sharedInstance.trackMethodPickEvent(onScreen: AppScreen.settings, method: brewMethod)
                    methodPickerViewController.performSegue(.SequenceSettings, sender: brewMethod.rawValue as AnyObject?)
            })
        }
        if case .About = segueIdentifierForSegue(segue) {
            let aboutViewController = segue.destination as! AboutViewController
            aboutViewController.enableSwipeToBack()
        }
	}
    
    fileprivate func performSegue(for indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
            case 0: performSegue(.MethodPicker); break
            case 1: performSegue(.Units); break
            case 2: performSegue(.About); break
            case 3: showEmailForm(); break
            case 4: showAppStore(); break
            default: break
        }
    }
    
    private func showEmailForm() {
        if MFMailComposeViewController.canSendMail() {
            present(configuredMailComposeViewController(), animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.mailComposeDelegate = self
        
        mailComposerViewController.setToRecipients(["hello@dropnote.today"])
        mailComposerViewController.setSubject("Dropnote App Feedback")
        mailComposerViewController.setMessageBody("Hi Dropnote Team!\n\n", isHTML: false)
        
        return mailComposerViewController
    }
    
    private func showMailError() {
        let alertController = UIAlertController(
            title: "Could Not Send Email",
            message: "Your device could not send e-mail. Please check e-mail configuration and try again.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func showAppStore() {
        let dropnoteAppStoreID = "1112293581"
      
      // swiftlint:disable line_length
        let dropnoteLinkString = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(dropnoteAppStoreID)"
      // swiftlint:enable line_length
      
        guard let dropnoteURL = URL(string: dropnoteLinkString) else { return }
        UIApplication.shared.openURL(dropnoteURL)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      print("Error when sending mail = \(String(describing: error?.localizedDescription))")
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: TabBarConfigurable {
    
    func setupTabBar() {
        tabBarItem = nil
        tabBarItem = UITabBarItem(title: tr(.settingsItemTitle),
                                  image: UIImage(asset: .Ic_tab_settings)?.alwaysOriginal(),
                                  selectedImage: UIImage(asset: .Ic_tab_settings_pressed)?.alwaysOriginal())

    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        cell.accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
        (cell as? SettingsCell)?.configureWithTheme(themeConfiguration)
	}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(for: indexPath)
    }
}
