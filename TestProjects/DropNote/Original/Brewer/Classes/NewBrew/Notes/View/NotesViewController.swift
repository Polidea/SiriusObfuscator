//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension NotesViewController: Activable { }
extension NotesViewController: ThemeConfigurationContainer { }

final class NotesViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var notesTextView: UITextView!

    var active: Bool = false {
        didSet {
            if var responder = notesTextView {
                responder.active = active
            }
        }
    }
    
    var viewModel: NotesViewModelType!
    var themeConfiguration: ThemeConfiguration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = BrewAttributeType.Notes.description
        notesTextView.text = viewModel.notes.value
        
        notesTextView.rx.text.bind(to: viewModel.notes).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.configureWithTheme(themeConfiguration)
        notesTextView.configureWithTheme(themeConfiguration)
    }
}
