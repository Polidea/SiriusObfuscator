//RUN: %target-prepare-obfuscation-with-storyboard "LayoutStoryboard" %target-run-full-obfuscation

import Cocoa

class ViewController {
  
  @IBOutlet weak var informativeLabel: NSButton!

  @IBAction func switchInputRepresentation(_ sender: NSButton) {
  }

}
