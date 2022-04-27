//
//  ViewController.swift
//  Photo Libary Management
//
//  Created by Ayush Singh on 27/04/22.
//

import UIKit
import Photos
import CoreData

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
    
    var photos : PHFetchResult<PHAsset>? = nil
    let reuseIdentifier = "cell"
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhoto()

        collectionView.delegate = self
        collectionView.dataSource = self
        
//        openDatabse()
    }
    
    
    
    func fetchPhoto() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                self.photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                self.getPhotos()
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            case .limited:
                print("Limited")
            @unknown default:
                print("Error Occured")
            }
        }
    }
    
     func getPhotos() {

        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        // .highQualityFormat will return better quality photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 700, height: 700)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        images.append(image)
                        self.collectionView.reloadData()
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            print("no photos to display")
        }

    }
    
    func selectMultiple(){
        if collectionView.allowsMultipleSelection == false {
            collectionView.allowsMultipleSelection = true
            selectButton.setTitle("Deselect", for: .normal)
        }else{
            selectButton.setTitle("Select", for: .normal)
            collectionView.allowsMultipleSelection = true
        }
    }
    
    func copyImagetoAlbum(){
        if let items = collectionView.indexPathsForSelectedItems {

            
            let date = Date()
            print(date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let someDateTime = formatter.string(from: date)

            
            
            for i in 0..<(items.count) {
                if myAlbum.contains(items[i].row){

                    Toast.show(message: "One of your media is already copied", controller: self)
                }else{
                    myAlbum.append(items[i].row)
                    timeData.append(someDateTime)
                    albumImages.append(images[items[i].row])

                }

            }

            print(myAlbum)
            //Save to core data
            
//           openDatabse()t
            
        }
        
       

        
    }
    @IBAction func copyBtn(_ sender: Any) {
        copyImagetoAlbum()
    }
    @IBAction func selectMultiple(_ sender: Any) {
        selectMultiple()
    }
    @IBAction func goToAlbum(_ sender: Any) {
        self.performSegue(withIdentifier: "myAlbum", sender: self)
    }
    
    
    //Core Data
    func openDatabse()
    {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Images", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        saveData(UserDBObj:newUser)
    }

    func saveData(UserDBObj:NSManagedObject)
    {
        if let items = collectionView.indexPathsForSelectedItems {
            
        UserDBObj.setValue(myAlbum, forKey: "album")


        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }

        fetchData()
        }
    }

    func fetchData()
    {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
//                let time = data.value(forKey: "time") as! String
                let album = data.value(forKey: "album") as! Int
                myAlbum.append(album)
            }
        } catch {
            print("Fetching data Failed")
        }
        print(myAlbum)
    }
    


}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        let asset = photos?.object(at: indexPath.row)
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
//        cell.imageView.fetchImage(asset: asset!, contentMode: .aspectFit, targetSize: cell.imageView.frame.size)
        cell.imageView.image = images[indexPath.row]
        

        
        return cell
    }
    

    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Got clicked!")
        
    }

    
}

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
      super.awakeFromNib()
            
      let view = UIView(frame: bounds)
      self.backgroundView = view
            
      let coloredView = UIView(frame: bounds)
      coloredView.backgroundColor = UIColor.red
      self.selectedBackgroundView = coloredView
    }
}

