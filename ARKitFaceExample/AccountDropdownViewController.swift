import UIKit

protocol AccountDropdownDelegate: AnyObject {
    func didSelectAccountOption(_ option: String)
}

class AccountDropdownViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet private weak var pickerView: UIPickerView!

    var accountOptions: [String] = []
    weak var delegate: AccountDropdownDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accountOptions.count
    }

    // UIPickerViewDelegate method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accountOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = accountOptions[row]
        delegate?.didSelectAccountOption(selectedOption)
    }
}
