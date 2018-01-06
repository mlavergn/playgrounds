import UIKit
import PlaygroundSupport

class DemoCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView?
    let dataSource: DemoCollectionViewDataSource

    required public init() {
        self.dataSource = DemoCollectionViewDataSource()
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // define the CTA size
        let ctaSize = CGSize(width: 90, height: 120)
        
        // define the flow layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: ctaSize.width, height: ctaSize.height)
        
        // important
        layout.scrollDirection = .horizontal
        
        // define the CTA picker size
        let pickerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: ctaSize.height)
        
        // create the collection view
        collectionView = UICollectionView(frame: pickerFrame, collectionViewLayout: layout)
        collectionView?.dataSource = dataSource
        collectionView?.delegate = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DemoKey")
        collectionView?.backgroundColor = .white

		let scrollFrame = CGRect(x: 0, y: 0, width: 375, height: 120)

		collectionView?.frame = scrollFrame

		let iphone7Frame = CGRect(x: 0, y: 0, width: 375, height: 667)
		let view = UIView(frame: iphone7Frame)
		view.addSubview(collectionView!)
	
		self.view = view
    }
}

class DemoCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoKey", for: indexPath)
        
        switch indexPath.item {
        case 0:
            cell.backgroundColor = .yellow
        case 1:
            cell.backgroundColor = .red
        case 2:
            cell.backgroundColor = .blue
        case 3:
            cell.backgroundColor = .green
        case 4:
            cell.backgroundColor = .magenta
        default:
            cell.backgroundColor = .white
        }
        
        return cell
    }
}

let vc = DemoCollectionViewController()
PlaygroundPage.current.liveView = vc
