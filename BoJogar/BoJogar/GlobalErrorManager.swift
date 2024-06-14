import Foundation
import SwiftUI

class GlobalErrorManager: ObservableObject {
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    func displayError(_ message: String) {
        self.errorMessage = message
        self.showError = true
    }
    
    func dismissError() {
        self.showError = false
        self.errorMessage = ""
    }
}
