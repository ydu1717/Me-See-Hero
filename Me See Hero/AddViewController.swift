

import UIKit
import CoreData

class AddViewController: UIViewController {

    var dataArray = NSMutableArray.init(capacity: 5)
    let pickerViewWidth:CGFloat = 320
    let pickerViewHeight:CGFloat = 162
    
    private lazy var tableview : UITableView = {
        let rect = CGRect.init(x: 0, y: NavigationBarHeight(), width: screenWidth, height: screenHeight - NavigationBarHeight())
        let tableview = UITableView.init(frame: rect, style: UITableView.Style.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedSectionFooterHeight = 0
        tableview.estimatedSectionHeaderHeight = 0
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.tableFooterView = saveBtn()
        tableview.tableHeaderView = UIView.init()
        return tableview
    }()
    
    private lazy var pickerView1: UIPickerView = {
        let picker = UIPickerView.init()
        picker.frame = CGRect(x:screenWidth/2 - pickerViewWidth/2, y: screenHeight - pickerViewHeight - 40,width: pickerViewWidth, height: pickerViewHeight)
        picker.dataSource        = self as UIPickerViewDataSource
        picker.delegate          = self as UIPickerViewDelegate
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.blue.cgColor
        return picker
    }()
    
    private lazy var pickerView2: UIPickerView = {
        let picker = UIPickerView.init()
        picker.frame = CGRect(x:screenWidth/2 - pickerViewWidth/2, y: screenHeight - pickerViewHeight - 40,width: pickerViewWidth, height: pickerViewHeight)
        picker.dataSource        = self as UIPickerViewDataSource
        picker.delegate          = self as UIPickerViewDelegate
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.blue.cgColor
        return picker
    }()
    
    var picker1Data: [String] = ["Aries","Taurus","Gemini","Cancer","Leo","Virgo","Libra","Scorpio","Sagittarius","Capricorn","Aquarius","Pisces"] //Twelve constellations
    
    var picker2Data: [String] = ["Batman","captain_america","ironman","spiderman","Hulk","Wolverine","Raytheon","Superman"]
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("add", comment: "")
        view.backgroundColor = UIColor.white
        view.addSubview(self.tableview)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        dataArray.add("name")
        dataArray.add("image")
        dataArray.add("zodiacSign") // 星座
        dataArray.add("cityofresidence") //居住城市
        dataArray.add("locationtitle") // 看到位置
        dataArray.add("snapshot") // 看到快照
    }
    
    @objc func saveClick() -> Void {
        
        self.pickerView1.removeFromSuperview()
        self.pickerView2.removeFromSuperview()
        
        let cell = self.tableview.cellForRow(at: IndexPath.init(row: 0, section: 0))
        let name : UITextField = cell?.contentView.viewWithTag(0 + 1000) as! UITextField
        
        let cell1 = self.tableview.cellForRow(at: IndexPath.init(row: 2, section: 0))
        let zodiacSign : UITextField = cell1?.contentView.viewWithTag(2 + 1000) as! UITextField
        
        let cell2 = self.tableview.cellForRow(at: IndexPath.init(row: 3, section: 0))
        let cityofresidence : UITextField = cell2?.contentView.viewWithTag(3 + 1000) as! UITextField
        
        let cell3 = self.tableview.cellForRow(at: IndexPath.init(row: 4, section: 0))
        let locationtitle : UITextField = cell3?.contentView.viewWithTag(4 + 1000) as! UITextField
        
        let cell4 = self.tableview.cellForRow(at: IndexPath.init(row: 1, section: 0))
        let img : UIImageView = cell4?.contentView.viewWithTag(1 + 2000) as! UIImageView
        
        let cell5 = self.tableview.cellForRow(at: IndexPath.init(row: 5, section: 0))
        let snapshot : UIImageView = cell5?.contentView.viewWithTag(5 + 2000) as! UIImageView
        
        if name.text?.count ?? 0 <= 0 {
            alertAction(message: NSLocalizedString("Name cannot be empty", comment: ""))
        }
        
        if zodiacSign.text?.count ?? 0 <= 0 {
            alertAction(message: NSLocalizedString("zodiacSign cannot be empty", comment: ""))
        }
        
        if cityofresidence.text?.count ?? 0 <= 0 {
            alertAction(message: NSLocalizedString("cityofresidence cannot be empty", comment: ""))
        }
        
        if locationtitle.text?.count ?? 0 <= 0 {
            alertAction(message: NSLocalizedString("locationtitle cannot be empty", comment: ""))
        }
        
        if img.image == UIImage.init(named: "add") {
            alertAction(message: NSLocalizedString("Image cannot be empty", comment: ""))
        }
        
        if snapshot.image == UIImage.init(named: "add") {
            alertAction(message: NSLocalizedString("snapshot cannot be empty", comment: ""))
        }
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let model = NSEntityDescription.insertNewObject(forEntityName: "HeroModel", into: managedObjectContext) as! HeroModel
        
        let timeInterval: TimeInterval = Date.init().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        
        model.name            = name.text
        model.image           = img.image?.pngData() as NSData?
        model.snapshot        = snapshot.image?.pngData() as NSData?
        model.zodiacSign      = zodiacSign.text
        model.cityofresidence = cityofresidence.text
        model.locationtitle   = locationtitle.text
        model.uuid            = NSUUID.init(uuidString: "\(millisecond)") as UUID?
        
        do{
            try managedObjectContext.save()
            print("Success to save data.")
            let alert = UIAlertController.init(title: NSLocalizedString("Prompt", comment: ""), message: NSLocalizedString("Successfully saved", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true) {
            }
        } catch{
            print("Failed to save data.")
        }
    }
    
    func alertAction(message : String) -> Void {
        let alert = UIAlertController.init(title: NSLocalizedString("", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            
        }
    }
}

// MARK : UITableViewDataSource
extension AddViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 5 {
            return 100 + 20
        }
        else {
            return CGFloat(rowHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.cellForRow(at: indexPath)
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
            cell?.selectionStyle = .none
        
            let lb = UILabel.init()
            lb.tag           = indexPath.row + 100
            lb.textAlignment = NSTextAlignment.left
            lb.frame = CGRect.init(x: 20, y: 0, width: 120, height: CGFloat(rowHeight))
            cell?.contentView.addSubview(lb)
            
            let tf = UITextField.init()
            tf.frame = CGRect.init(x: lb.zc_right + 10, y: 0, width: screenWidth - lb.zc_right - 10 - 20, height: CGFloat(rowHeight))
            tf.textAlignment = .right
            tf.delegate      = self
            tf.tag           = indexPath.row + 1000
            tf.placeholder = NSLocalizedString("Please enter", comment: "")
            cell?.contentView.addSubview(tf)
            
            let img = UIImageView.init()
            img.frame = CGRect.init(x: screenWidth - 150 - 10, y: 10, width: 150, height: 100)
            img.layer.masksToBounds = true
            img.layer.cornerRadius  = 5
            img.contentMode         = .scaleAspectFit
            img.isHidden            = true
            img.tag                 = indexPath.row + 2000
            img.image               = UIImage.init(named: "add")
            cell?.contentView.addSubview(img)
        }
        let lb : UILabel      = cell?.contentView.viewWithTag(indexPath.row + 100) as! UILabel
        let tf : UITextField  = cell?.contentView.viewWithTag(indexPath.row + 1000) as! UITextField
        let img : UIImageView = cell?.contentView.viewWithTag(indexPath.row + 2000) as! UIImageView

        lb.text = dataArray[indexPath.row] as? String
        
        if indexPath.row == 1 || indexPath.row == 5 {
            img.isHidden = false
            tf.isHidden  = true
        }
        else {
            img.isHidden = true
            tf.isHidden  = false
        }
        if indexPath.row == 2 {
            tf.isUserInteractionEnabled = false
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            let cell = tableview.cellForRow(at: indexPath)
            let img : UIImageView = cell?.contentView.viewWithTag(indexPath.row + 2000) as! UIImageView
            img.image = UIImage.init(named: self.picker2Data.first!)
            view.addSubview(self.pickerView2)
            self.pickerView1.removeFromSuperview()
        }
        else if indexPath.row == 2 {
            let cell = tableview.cellForRow(at: indexPath)
            let tf : UITextField = cell?.contentView.viewWithTag(indexPath.row + 1000) as! UITextField
            tf.text = self.picker1Data.first
            view.addSubview(self.pickerView1)
            self.pickerView2.removeFromSuperview()
        }
        else if indexPath.row == 5 {
            self.imagePicker.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                let alert = UIAlertController.init(title: NSLocalizedString("", comment: ""), message: "message", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("Photo Gallery", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("Camera", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                    self.imagePicker.sourceType = .camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true) {
                    
                }
            }
        }
    }
    
    func saveBtn() -> UIView {
        let view = UIView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 100)
        
        let savebtn = UIButton.init()
        savebtn.frame = CGRect.init(x: 40, y: 40, width: screenWidth - 80, height: 60)
        savebtn.setTitle(NSLocalizedString("Save", comment: ""), for: UIControl.State.normal)
        savebtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        savebtn.layer.cornerRadius = 10
        savebtn.layer.masksToBounds = true
        savebtn.backgroundColor = UIColor(red: 0.0, green: 0.4823529411764706, blue: 1.0, alpha: 1.0)
        savebtn.addTarget(self, action: #selector(saveClick), for: UIControl.Event.touchUpInside)
        view.addSubview(savebtn)
        return view
    }
}

// MARK : UIPickerViewDelegate
extension AddViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.pickerView1) {
            return self.picker1Data.count
        }else {
            return self.picker2Data.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if(pickerView == pickerView1) {
            return self.picker1Data[row]
        }
        else {
            return self.picker2Data[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == pickerView1) {
            let selectedProvince = self.picker1Data[row] as String
            let cell = self.tableview.cellForRow(at: IndexPath.init(row: 2, section: 0))
            let tf : UITextField = cell?.contentView.viewWithTag(2 + 1000) as! UITextField
            tf.text = selectedProvince
        }
        else {
            let selectedProvince = self.picker2Data[row] as String
            let cell = tableview.cellForRow(at: IndexPath.init(row: 1, section: 0))
            let img : UIImageView = cell?.contentView.viewWithTag(1 + 2000) as! UIImageView
            img.image = UIImage.init(named: selectedProvince)
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
}

extension AddViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        let cell = tableview.cellForRow(at: IndexPath.init(row: 5, section: 0))
        let img : UIImageView = cell?.contentView.viewWithTag(5 + 2000) as! UIImageView
        img.image = pickedImage
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView1.removeFromSuperview()
        self.pickerView2.removeFromSuperview()
    }
}
