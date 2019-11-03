
import UIKit
import CoreData

let screenWidth  = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let rowHeight = 80
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
        tableview.estimatedRowHeight           = CGFloat(rowHeight)
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
            if dataArray.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(0.1))) {
                    self.tableview.reloadData()
                }
            }
            else {
                addHeroModel()
            }
            
        } catch{
            print("Failed to fetch data.")
        }
    }
}


// MARK : UITableViewDataSource
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.cellForRow(at: indexPath)
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
            cell?.selectionStyle = .blue
            
            let passlb = UILabel.init()
            passlb.textColor = UIColor.gray
            passlb.tag = indexPath.row + 100
            passlb.textAlignment = NSTextAlignment.right
            passlb.frame = CGRect.init(x: screenWidth - 100 - 60, y: 0, width: 100, height: (cell?.frame.size.height)!)
            cell?.contentView.addSubview(passlb)
            
            let gress = UIProgressView.init(progressViewStyle: UIProgressView.Style.default)
            gress.tag = indexPath.row + 1000
            gress.frame = CGRect.init(x: Int(screenWidth - 50), y: rowHeight/2 - 10, width: 40, height: 20)
            cell?.contentView.addSubview(gress)
            
        }
     
        
        return cell!
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

