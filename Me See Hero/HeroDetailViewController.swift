

import UIKit

class HeroDetailViewController: UIViewController {

    var model : HeroModel?
    var picker2Data: [String] = ["Batman","captain_america","ironman","spiderman","Hulk","Wolverine","Raytheon","Superman","catwoman"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        print(model as Any)
        
        let img = UIImageView.init()
        img.contentMode = .scaleAspectFill
        img.frame = CGRect.init(x: 0, y: NavigationBarHeight(), width: screenWidth, height: screenHeight - NavigationBarHeight())
        img.image = UIImage.init(data: model!.snapshot! as Data)
        view.addSubview(img)
        
        let max_x = screenWidth - 50
        let max_y = screenHeight - NavigationBarHeight() - 50
        
        for _ in 1...arc4random()%13+5 {
            let img = UIImageView.init()
            img.contentMode = .scaleAspectFill
            img.frame = CGRect.init(x: 0 + CGFloat(arc4random()%UInt32(max_x)), y: NavigationBarHeight() + CGFloat(arc4random()%UInt32(max_y)), width: 50, height: 50)
            img.image = UIImage.init(named: picker2Data[Int(arc4random()%UInt32(picker2Data.count-1))])
            view.addSubview(img)
        }
        
    }

}
