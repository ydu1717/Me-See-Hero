
import UIKit
import CoreData

let screenWidth  = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let rowHeight = 80
let rowHeight_120 = 120

func NavigationBarHeight() -> CGFloat {
    
    let mainWindow : UIWindow = ((UIApplication.shared.delegate?.window)!)!
    if #available(iOS 11.0, *) {
        if mainWindow.safeAreaInsets.bottom > 0.0{
            return 88.0
        }
    }
    return 64.0
}

class ViewController: UIViewController {

    var dataArray = NSMutableArray.init(capacity: 5)

    private lazy var tableview : UITableView = {
        let rect = CGRect.init(x: 0, y: NavigationBarHeight(), width: screenWidth, height: screenHeight - NavigationBarHeight())
        let tableview = UITableView.init(frame: rect, style: UITableView.Style.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.estimatedSectionFooterHeight = 0
        tableview.estimatedSectionHeaderHeight = 0
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.tableFooterView = UIView.init()
        tableview.tableHeaderView = UIView.init()
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refresh()
    }
    
    func refresh() -> Void {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "HeroModel", in: managedObjectContext)
        
        let request = NSFetchRequest<HeroModel>(entityName: "HeroModel")
        request.fetchOffset = 0
        request.entity = entity
        
        do{
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            dataArray.removeAllObjects()
            for model:HeroModel in results as! [HeroModel]{
                dataArray.add(model)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(0.1))) {
                self.tableview.reloadData()
            }
   
        } catch{
            print("Failed to fetch data.")
        }
    }
}

// MARK : UITableViewDataSource
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight_120)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.cellForRow(at: indexPath)
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
            cell?.selectionStyle = .none
            cell?.accessoryType = .disclosureIndicator
            
            let img = UIImageView.init()
            img.contentMode = .center
            img.layer.masksToBounds = true
            img.layer.cornerRadius = 7
            img.tag = indexPath.row + 1000
            img.frame = CGRect.init(x: 20, y: 10, width: Int(screenWidth - 40 - 10), height: rowHeight_120 - 10)
            cell?.contentView.addSubview(img)
            
            let namelb = UILabel.init()
            namelb.textColor = UIColor.gray
            namelb.tag = indexPath.row + 2000
            namelb.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize + 10)
            namelb.textAlignment = NSTextAlignment.center
            namelb.frame = CGRect.init(x: 20, y: 10, width: Int(screenWidth - 40 - 10), height: Int(img.zc_height) - 60)
            cell?.contentView.addSubview(namelb)
            
            let citylb = UILabel.init()
            citylb.textColor = UIColor.gray
            citylb.tag = indexPath.row + 3000
            citylb.textAlignment = NSTextAlignment.center
            citylb.frame = CGRect.init(x: 20, y: Int(namelb.zc_bottom) + 10, width: Int(screenWidth - 40 - 10), height: 20)
            cell?.contentView.addSubview(citylb)
            
            let zodiacSignlb = UILabel.init()
            zodiacSignlb.textColor = UIColor.gray
            zodiacSignlb.tag = indexPath.row + 4000
            zodiacSignlb.textAlignment = NSTextAlignment.center
            zodiacSignlb.frame = CGRect.init(x: 20, y: Int(citylb.zc_bottom) + 10, width: Int(screenWidth - 40 - 10), height: 20)
            cell?.contentView.addSubview(zodiacSignlb)

        }
        let img : UIImageView = cell?.contentView.viewWithTag(indexPath.row + 1000) as! UIImageView
        let namelb : UILabel  = cell?.contentView.viewWithTag(indexPath.row + 2000) as! UILabel
        let citylb : UILabel  = cell?.contentView.viewWithTag(indexPath.row + 3000) as! UILabel
        let zodiacSignlb : UILabel = cell?.contentView.viewWithTag(indexPath.row + 4000) as! UILabel
        
        let model : HeroModel = self.dataArray[indexPath.row] as! HeroModel
        
        img.image         = UIImage.init(data: model.snapshot! as Data)
        namelb.text       = model.name
        citylb.text       = model.cityofresidence
        zodiacSignlb.text = model.zodiacSign
      
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model : HeroModel = self.dataArray[indexPath.row] as! HeroModel
        let vc = HeroDetailViewController.init()
        vc.title = model.name
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return NSLocalizedString("Delete", comment:"")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController.init(title: NSLocalizedString("Whether to delete this data", comment: ""), message: NSLocalizedString("Unrecoverable after deletion", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("Delete", comment: ""), style: UIAlertAction.Style.destructive, handler: { (action) in
                let model : HeroModel = self.dataArray[indexPath.row] as! HeroModel
                let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = app.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<HeroModel>(entityName:"HeroModel")
                fetchRequest.fetchLimit = 10
                fetchRequest.fetchOffset = 0
                let predicate = NSPredicate(format: "uuid = \(model.uuid)","")
                fetchRequest.predicate = predicate
                do {
                    let fetchedObjects = try context.fetch(fetchRequest)
                    
                    for info in fetchedObjects{
                        
                        context.delete(info)
                        self.refresh()
                        print("success")
                    }
                }
                catch {
                    fatalError("err：\(error)")
                }
            }))
            
            self.present(alert, animated: true) {
                
            }
        }
    }
}

extension ViewController {
    @objc func addHeroModel() -> Void {
        let vc = AddViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController {
    func initUI() -> Void {
        view.backgroundColor = .white
        title = NSLocalizedString("Me See Hero", comment: "")
        view.addSubview(self.tableview)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addHeroModel))]
    }
}

